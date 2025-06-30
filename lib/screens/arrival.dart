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

class ShipmentItem {
  final ParcelModel parcel;
  bool selected;
  bool isExpanded;
  ShipmentItem({required this.parcel, this.selected = false, this.isExpanded = false});
}

class ArrivalScreen extends StatefulWidget {
  const ArrivalScreen({Key? key}) : super(key: key);

  @override
  State<ArrivalScreen> createState() => _ArrivalScreenState();
}

class _ArrivalScreenState extends State<ArrivalScreen> {
  String userName = '';
  final TextEditingController _shipmentController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<ShipmentItem> _shipmentList = [];
  bool _selectAll = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    final user = await UserService.getUser();
    if (user != null && mounted) {
      setState(() {
        userName = user.fullName;
      });
    }
  }

  void _showSidebar() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SidebarScreen(
          userName: userName,
          onProfile: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
          onResetPassword: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
            );
          },
          onLogout: () async {
            await UserService.logout();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
      ),
    );
  }

  void _addShipment() async {
    final trackingNumber = _shipmentController.text.trim();
    if (trackingNumber.isNotEmpty && !_shipmentList.any((item) => item.parcel.trackingNumber == trackingNumber)) {
      try {
        // Fetch parcel details from API
        final parcel = await ParcelService.getParcelByTrackingNumber(trackingNumber);
        
        if (parcel != null) {
          setState(() {
            _shipmentList.add(ShipmentItem(parcel: parcel));
            _shipmentController.clear();
          });
          FocusScope.of(context).unfocus();
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Shipment added successfully: ${parcel.recipientName}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Shipment not found. Please check the tracking number.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding shipment: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else if (_shipmentList.any((item) => item.parcel.trackingNumber == trackingNumber)) {
      // Show error if shipment already exists
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This shipment is already in the list.'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      for (var item in _shipmentList) {
        item.selected = _selectAll;
      }
    });
  }

  void _deleteSelected() {
    setState(() {
      _shipmentList.removeWhere((item) => item.selected);
      _selectAll = false;
    });
  }

  void _showDeleteDialog() {
    final selectedCount = _shipmentList.where((item) => item.selected).length;
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
                    ? 'You want to delete this shipment'
                    : 'You want to delete all shipments',
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
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
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
                'All Shipments have been created',
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Ok', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openQrScanner() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QrScannerScreen(
          validIds: {},
          onScanSuccess: (trackingNumber) {
            setState(() {
              _shipmentController.text = trackingNumber;
            });
          },
        ),
      ),
    );
  }

  List<ShipmentItem> get _filteredShipmentList {
    if (_searchQuery.isEmpty) return _shipmentList;
    return _shipmentList
        .where((item) => 
          item.parcel.trackingNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.parcel.recipientName.toLowerCase().contains(_searchQuery.toLowerCase())
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasSelected = _shipmentList.any((item) => item.selected);
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
          title: Text('Arrival', style: GoogleFonts.poppins(color: Colors.black, fontSize: 18)),
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
                // Enter Shipment Number
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _shipmentController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter Shipment Number',
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
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD9D9D9),
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: _addShipment,
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Scan by CN Dropdown
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: 'Scan by CN',
                    items: const [
                      DropdownMenuItem(
                        value: 'Scan by CN',
                        child: Text('Scan by CN'),
                      ),
                    ],
                    onChanged: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                    disabledHint: const Text('Scan by CN'),
                  ),
                ),
                const SizedBox(height: 16),
                // Click to Scan
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: 'Click to Scan',
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
                      child: InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: _openQrScanner,
                        child: const Icon(Icons.qr_code_2, color: Colors.black),
                      ),
                    ),
                  ],
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
                if (_shipmentList.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _filteredShipmentList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(
                            'No ID found',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      )
                    : Expanded(
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
                                if (hasSelected)
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
                                itemCount: _filteredShipmentList.length,
                                itemBuilder: (context, index) {
                                  final item = _filteredShipmentList[index];
                                  return Card(
                                    color: item.selected ? Colors.grey[100] : Colors.white,
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Checkbox(
                                            value: item.selected,
                                            onChanged: (val) {
                                              setState(() {
                                                item.selected = val ?? false;
                                                _selectAll = _shipmentList.isNotEmpty && _shipmentList.every((e) => e.selected);
                                              });
                                            },
                                          ),
                                          title: Text(
                                            item.parcel.trackingNumber,
                                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                            item.parcel.recipientName,
                                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(item.parcel.status),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  item.parcel.status,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              IconButton(
                                                icon: Icon(
                                                  item.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                  color: const Color(0xFF18136E),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    item.isExpanded = !item.isExpanded;
                                                  });
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
                                                  _buildDetailRow('Recipient', item.parcel.recipientName),
                                                  _buildDetailRow('Phone', item.parcel.recipientPhone),
                                                  _buildDetailRow('Address', item.parcel.recipientAddress),
                                                  const Divider(height: 16),
                                                  _buildDetailRow('Sender', item.parcel.senderName),
                                                  _buildDetailRow('Sender Phone', item.parcel.senderPhone),
                                                  _buildDetailRow('Sender Address', item.parcel.senderAddress),
                                                  const Divider(height: 16),
                                                  _buildDetailRow('Weight', item.parcel.weight),
                                                  _buildDetailRow('Dimensions', item.parcel.dimensions),
                                                  _buildDetailRow('Package Type', item.parcel.packageType),
                                                  _buildDetailRow('Insurance', item.parcel.insuranceValue),
                                                  _buildDetailRow('Current Location', item.parcel.currentLocation),
                                                  _buildDetailRow('Estimated Delivery', item.parcel.estimatedDelivery),
                                                  if (item.parcel.notes.isNotEmpty) ...[
                                                    const Divider(height: 16),
                                                    _buildDetailRow('Notes', item.parcel.notes),
                                                  ],
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
                      ),
                  if (_filteredShipmentList.isNotEmpty)
                    SafeArea(
                      top: false,
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
                ],
              ],
            ),
          ),
        ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return const Color(0xFF4CAF50);
      case 'out for delivery':
        return const Color(0xFFFF9800);
      case 'in transit':
        return const Color(0xFF2196F3);
      case 'pending pickup':
        return const Color(0xFF9C27B0);
      case 'processed':
        return const Color(0xFF607D8B);
      case 'received':
        return const Color(0xFF795548);
      default:
        return const Color(0xFF757575);
    }
  }
}
