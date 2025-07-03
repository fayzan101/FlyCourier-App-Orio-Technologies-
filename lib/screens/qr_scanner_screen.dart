import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../services/user_service.dart';
import '../services/parcel_service.dart';
import '../models/parcel_model.dart';
import 'sidebar_menu.dart';
import 'profile_screen.dart';
import 'forgot_password.dart';
import 'login_screen.dart';
import 'dart:async';

class QrScannerScreen extends StatefulWidget {
  final Set<String> validIds;
  final void Function(String id) onScanSuccess;
  static final GlobalKey<_QrScannerScreenState> scannerKey = GlobalKey<_QrScannerScreenState>();

  const QrScannerScreen({Key? key, required this.validIds, required this.onScanSuccess}) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedId;
  bool showSuccess = false;
  bool showError = false;
  String? errorMessage;
  String userName = 'Loading...';
  ParcelModel? scannedParcel;
  bool isLoading = false;
  bool _isLoadingUserName = true;
  late Set<String> scannedIds;
  Timer? _messageTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
    _loadUserName();
    scannedIds = Set<String>.from(widget.validIds);
  }

  Future<void> _loadUserName() async {
    if (!_isLoadingUserName) return; // Prevent multiple calls
    
    try {
      final userInfo = await UserService.getUserInfo();
      if (userInfo['emp_name'] != null && userInfo['emp_name']!.isNotEmpty && mounted) {
        setState(() {
          userName = userInfo['emp_name']!;
          _isLoadingUserName = false;
        });
      } else {
        // Fallback to UserModel if getUserInfo doesn't work
        final user = await UserService.getUser();
        if (user != null && mounted) {
          setState(() {
            userName = user.fullName;
            _isLoadingUserName = false;
          });
        } else if (mounted) {
          setState(() {
            userName = 'User';
            _isLoadingUserName = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userName = 'User';
          _isLoadingUserName = false;
        });
      }
    }
  }

  void _showSidebar() async {
    // If username is still loading, try to load it now
    if (_isLoadingUserName) {
      await _loadUserName();
    }
    
    Get.to(() => SidebarScreen(
      userName: userName,
      onProfile: () {
        Get.back();
        Get.to(() => const ProfileScreen());
      },
      onResetPassword: () {
        Get.back();
        Get.to(() => const ForgotPasswordScreen());
      },
      onLogout: () async {
        await UserService.logout();
        Get.offAll(() => const LoginScreen());
      },
    ));
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    ctrl.scannedDataStream.listen((scanData) async {
      // Normalize function to avoid case/whitespace duplicates
      String normalized(String? s) => (s ?? '').trim().toLowerCase();
      final code = scanData.code;
      final normalizedCode = normalized(code);
      if (scannedId != code && !isLoading) {
        setState(() {
          scannedId = code;
          isLoading = true;
        });
        if (code != null) {
          if (scannedIds.any((id) => normalized(id) == normalizedCode)) {
            _showMessage(success: false, error: 'Already scanned');
            setState(() {
              scannedParcel = null;
              isLoading = false;
            });
            // Resume camera after short delay for next scan
            await Future.delayed(const Duration(milliseconds: 700));
            controller?.resumeCamera();
            return;
          }
          try {
            final parcel = await ParcelService.getParcelByTrackingNumber(code);
            if (parcel != null) {
              setState(() {
                scannedParcel = parcel;
                isLoading = false;
                scannedIds.add(code);
              });
              _showMessage(success: true);
              widget.onScanSuccess(code);
            } else {
              _showMessage(success: false, error: 'Invalid tracking number');
              setState(() {
                scannedParcel = null;
                isLoading = false;
              });
            }
          } catch (e) {
            setState(() {
              showError = true;
              showSuccess = false;
              scannedParcel = null;
              isLoading = false;
            });
          }
          // Resume camera after short delay for next scan
          await Future.delayed(const Duration(milliseconds: 700));
          controller?.resumeCamera();
        }
      }
    });
  }

  void removeScannedId(String id) {
    setState(() {
      scannedIds.remove(id);
    });
  }

  void _showMessage({required bool success, String? error}) {
    setState(() {
      showSuccess = success;
      showError = !success;
      errorMessage = error;
    });
    _messageTimer?.cancel();
    _messageTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          showSuccess = false;
          showError = false;
          errorMessage = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(28);
    return WillPopScope(
      onWillPop: () async {
        await controller?.pauseCamera();
        controller?.dispose();
        return true;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light, // For iOS
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () async {
                await controller?.pauseCamera();
                controller?.dispose();
                Navigator.of(context).pop();
              },
            ),
            title: Text('Scan Barcode', style: GoogleFonts.poppins(color: Colors.black)),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: _showSidebar,
              ),
            ],
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
            },
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
                // Custom dimmed overlay
                IgnorePointer(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _ScannerOverlayPainter(
                      cutOutSize: MediaQuery.of(context).size.width * 0.7,
                      borderRadius: 12,
                    ),
                  ),
                ),
                if (showSuccess)
                  Positioned(
                    top: 56,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Parcel Found!',
                              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            if (scannedParcel != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                '${scannedParcel!.consigneeName} - ${scannedParcel!.shipmentNo}',
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                if (showError)
                  Positioned(
                    top: 56,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(errorMessage ?? 'Error', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                if (isLoading)
                  Positioned(
                    top: 56,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Searching parcel...',
                              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewPadding.bottom + 36,
                      top: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 32),
                          onPressed: () {
                            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                            controller?.flipCamera();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.flash_on, color: Colors.white, size: 32),
                          onPressed: () {
                            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                            controller?.toggleFlash();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double cutOutSize;
  final double borderRadius;

  _ScannerOverlayPainter({required this.cutOutSize, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cutOutSize,
      height: cutOutSize,
    );

    final overlayPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutOutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)))
      ..close();
    overlayPath.addPath(cutOutPath, Offset.zero);

    canvas.drawPath(
      Path.combine(PathOperation.difference, overlayPath, cutOutPath),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}