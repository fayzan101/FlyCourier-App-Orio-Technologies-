import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sidebar_menu.dart';
import '../services/user_service.dart';
import '../services/parcel_service.dart';
import '../models/parcel_model.dart';
import 'dashboard.dart';
import 'login_screen.dart';
import 'forgot_password.dart';
import 'profile_screen.dart';
import 'qr_scanner_screen.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_card_controller.dart';

class PickupItem {
  final ParcelModel parcel;
  bool selected;
  bool isExpanded;
  PickupItem({required this.parcel, this.selected = false, this.isExpanded = false});
}

class PickupScreen extends StatefulWidget {
  const PickupScreen({Key? key}) : super(key: key);

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  String userName = '';
  final TextEditingController _searchController = TextEditingController();
  final DashboardCardController cardController = Get.find<DashboardCardController>();
  bool _selectAll = false;
  String _searchQuery = '';
  String? _selectedShipmentNo;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final userInfo = await UserService.getUserInfo();
    if (userInfo['emp_name'] != null && userInfo['emp_name']!.isNotEmpty) {
      setState(() {
        userName = userInfo['emp_name']!;
      });
    } else {
      final user = await UserService.getUser();
      if (user != null && mounted) {
        setState(() {
          userName = user.fullName;
        });
      }
    }
  }

  void _showSidebar() async {
    await _loadUserName();
    if (!mounted) return;
    Get.to(() => SidebarScreen(
      userName: userName.isNotEmpty ? userName : 'Loading...',
      onProfile: () {
        Get.to(() => const ProfileScreen());
      },
      onResetPassword: () {
        Get.to(() => const ForgotPasswordScreen());
      },
      onLogout: () async {
        await UserService.logout();
        Get.offAll(() => const LoginScreen());
      },
    ));
  }

  void _toggleSelectAll() {
    _selectAll = !_selectAll;
    for (var item in cardController.pickupList) {
      item.selected = _selectAll;
    }
    cardController.pickupList.refresh();
  }

  void _deleteSelected() {
    final deletedIds = cardController.pickupList.where((item) => item.selected).map((item) => item.parcel.shipmentNo).toList();
    cardController.pickupList.removeWhere((item) => item.selected);
    _selectAll = false;
    for (final id in deletedIds) {
      if (QrScannerScreen.scannerKey.currentState != null) {
        QrScannerScreen.scannerKey.currentState!.removeScannedId(id);
      }
    }
  }

  void _showDeleteDialog() {
    final selectedCount = cardController.pickupList.where((item) => item.selected).length;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(top: 80),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 56),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE7E6F5),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(24),
                child: const Icon(Icons.delete_outline, color: Color(0xFF18136E), size: 56),
              ),
              const SizedBox(height: 24),
              Text(
                'Are you Sure',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                selectedCount == 1
                    ? 'You want to delete this pickup'
                    : 'You want to delete all pickups',
                style: GoogleFonts.poppins(color: Color(0xFF7B7B7B), fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F3F3),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('No', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF18136E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _deleteSelected();
                      },
                      child: Text('Yes', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE7E6F5),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(24),
                      child: const Icon(Icons.check, color: Color(0xFF18136E), size: 56),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Success!',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All Pickups has been created',
                      style: GoogleFonts.poppins(color: Color(0xFF7B7B7B), fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF18136E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          cardController.pickupList.clear();
                          _selectAll = false;
                        },
                        child: Text('Ok', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _startContinuousScan() async {
    final scannedNumbers = cardController.pickupList.map((item) => item.parcel.shipmentNo).toSet();
    await Get.to(() => QrScannerScreen(
      key: QrScannerScreen.scannerKey,
      validIds: scannedNumbers,
      onScanSuccess: (trackingNumber) async {
        if (!cardController.pickupList.any((item) => item.parcel.shipmentNo == trackingNumber)) {
          final parcel = await ParcelService.getParcelByTrackingNumber(trackingNumber);
          if (parcel != null) {
            cardController.pickupList.add(PickupItem(parcel: parcel));
          }
        }
      },
    ));
  }

  List<PickupItem> get _filteredPickupList {
    if (_searchQuery.isEmpty) return cardController.pickupList;
    return cardController.pickupList
        .where((item) => 
          item.parcel.shipmentNo.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.parcel.consigneeName.toLowerCase().contains(_searchQuery.toLowerCase())
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Pickup', style: GoogleFonts.poppins(color: Colors.black, fontSize: 18)),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: _showSidebar,
            ),
          ],
        ),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Click to Scan styled box
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _startContinuousScan,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Click to Scan',
                          style: TextStyle(
                            color: Color(0xFF7B7B7B),
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.qr_code_2, color: Color(0xFF18136E)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Search
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by tracking number or recipient name',
                          filled: true,
                          fillColor: const Color(0xFFF3F3F3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.search, color: Colors.black),
                    ),
                  ],
                ),
                Obx(() {
                  if (cardController.pickupList.isEmpty) return SizedBox.shrink();
                  final filtered = _filteredPickupList;
                  return Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _selectAll,
                              onChanged: (val) => _toggleSelectAll(),
                            ),
                            Text(_selectAll ? 'Unselect All' : 'Select All',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                            const Spacer(),
                            if (filtered.any((item) => item.selected))
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[100],
                                  foregroundColor: Colors.red,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                onPressed: _showDeleteDialog,
                                child: const Text('Delete'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _selectedShipmentNo == null ? filtered.length : filtered.where((item) => item.parcel.shipmentNo == _selectedShipmentNo).length,
                            itemBuilder: (context, index) {
                              final item = _selectedShipmentNo == null ? filtered[index] : filtered.firstWhere((i) => i.parcel.shipmentNo == _selectedShipmentNo);
                              return Card(
                                color: item.selected ? Colors.grey[100] : Colors.white,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Checkbox(
                                        value: item.selected,
                                        onChanged: (val) {
                                          item.selected = val ?? false;
                                          _selectAll = cardController.pickupList.isNotEmpty && cardController.pickupList.every((e) => e.selected);
                                          cardController.pickupList.refresh();
                                        },
                                      ),
                                      title: Text(
                                        'Pickup ID: ${item.parcel.shipmentNo}',
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              item.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                              color: const Color(0xFF18136E),
                                            ),
                                            onPressed: () {
                                              item.isExpanded = !item.isExpanded;
                                              cardController.pickupList.refresh();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (item.isExpanded)
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(4),
                                            bottomRight: Radius.circular(4),
                                          ),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildDetailRow('Shipment No', item.parcel.shipmentNo),
                                              _buildDetailRow('Shipment Date', item.parcel.shipmentDate),
                                              _buildDetailRow('TPCN No', item.parcel.tpcnno),
                                              _buildDetailRow('TP Name', item.parcel.tpname),
                                              _buildDetailRow('Shipment Reference', item.parcel.shipmentReference),
                                              _buildDetailRow('Consignee Name', item.parcel.consigneeName),
                                              _buildDetailRow('Consignee Contact', item.parcel.consigneeContact),
                                              _buildDetailRow('Product Detail', item.parcel.productDetail),
                                              _buildDetailRow('Consignee Address', item.parcel.consigneeAddress),
                                              _buildDetailRow('Destination City', item.parcel.destinationCity),
                                              _buildDetailRow('Peices', item.parcel.peices),
                                              _buildDetailRow('Weight', item.parcel.weight),
                                              _buildDetailRow('Cash Collect', item.parcel.cashCollect),
                                              _buildDetailRow('Created By', item.parcel.createdBy),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _selectedShipmentNo == null && cardController.pickupList.isNotEmpty
            ? SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF18136E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _showSuccessDialog,
                      child: Text('Submit', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black54,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}