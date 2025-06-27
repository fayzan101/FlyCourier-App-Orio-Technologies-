import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sidebar_menu.dart';
import '../services/user_service.dart';
import 'dashboard.dart';
import 'login_screen.dart';
import 'forgot_password.dart';
import 'profile_screen.dart';

class PickupItem {
  final String id;
  bool selected;
  PickupItem({required this.id, this.selected = false});
}

class PickupScreen extends StatefulWidget {
  const PickupScreen({Key? key}) : super(key: key);

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  String userName = '';
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<PickupItem> _pickupList = [];
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

  void _addPickup() {
    final id = _pickupController.text.trim();
    if (id.isNotEmpty && !_pickupList.any((item) => item.id == id)) {
      setState(() {
        _pickupList.add(PickupItem(id: id));
        _pickupController.clear();
      });
      FocusScope.of(context).unfocus();
    }
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      for (var item in _pickupList) {
        item.selected = _selectAll;
      }
    });
  }

  void _deleteSelected() {
    setState(() {
      _pickupList.removeWhere((item) => item.selected);
      _selectAll = false;
    });
  }

  void _showDeleteDialog() {
    final selectedCount = _pickupList.where((item) => item.selected).length;
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

  List<PickupItem> get _filteredPickupList {
    if (_searchQuery.isEmpty) return _pickupList;
    return _pickupList
        .where((item) => item.id.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final hasSelected = _pickupList.any((item) => item.selected);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
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
                // Enter Pickup Number
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pickupController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter Pickup Number',
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
                        onPressed: _addPickup,
                        child: const Text('Add'),
                      ),
                    ),
                  ],
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
                      child: const Icon(Icons.qr_code_2, color: Colors.black),
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
                          hintText: 'Search',
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
                if (_pickupList.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _filteredPickupList.isEmpty
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
                                itemCount: _filteredPickupList.length,
                                itemBuilder: (context, index) {
                                  final item = _filteredPickupList[index];
                                  return Card(
                                    color: item.selected ? Colors.grey[100] : Colors.white,
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: CheckboxListTile(
                                      value: item.selected,
                                      onChanged: (val) {
                                        setState(() {
                                          item.selected = val ?? false;
                                          _selectAll = _pickupList.isNotEmpty && _pickupList.every((e) => e.selected);
                                        });
                                      },
                                      title: Text('Pickup ID: ${item.id}', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                      controlAffinity: ListTileControlAffinity.leading,
                                      secondary: const Icon(Icons.keyboard_arrow_down),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  if (_filteredPickupList.isNotEmpty)
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
}
