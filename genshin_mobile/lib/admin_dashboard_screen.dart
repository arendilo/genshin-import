import 'package:flutter/material.dart';
import 'admin_add_product_screen.dart';
import 'admin_edit_product_screen.dart';

class AdminWeapon {
  final int id;
  final String name;
  final String type;
  final int price;
  final int stock;
  final int rarity;

  AdminWeapon(this.id, this.name, this.type, this.price, this.stock, this.rarity);
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final List<AdminWeapon> _mockAdminWeapons = [
    AdminWeapon(1, "Primordial Jade Cutter", "Sword", 4999, 12, 5),
    AdminWeapon(2, "Staff of Homa", "Polearm", 5999, 8, 5),
    AdminWeapon(3, "Amos' Bow", "Bow", 4599, 15, 5),
    AdminWeapon(4, "Lost Prayer", "Catalyst", 4799, 10, 5),
    AdminWeapon(5, "Wolf's Gravestone", "Claymore", 5299, 6, 5),
  ];

  String _searchQuery = '';

  List<AdminWeapon> get _filteredWeapons {
    return _mockAdminWeapons.where((w) => w.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  void _deleteWeapon(int id) {
    setState(() {
      _mockAdminWeapons.removeWhere((w) => w.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0820), Color(0xFF1A0F35), Color(0xFF2A1F4A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header & Search
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0F35).withOpacity(0.95),
                  border: Border(bottom: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2))),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: Color(0xFFD4AF37)),
                        ),
                        const Text('Admin Dashboard', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 20)),
                        const SizedBox(width: 24),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: const TextStyle(color: Color(0xFFF5F3FF)),
                      decoration: InputDecoration(
                        hintText: 'Search weapons...',
                        hintStyle: const TextStyle(color: Color(0xFF6B5BB5)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFFA89EC9)),
                        filled: true,
                        fillColor: const Color(0xFF1E143C).withOpacity(0.6),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Weapon Management', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 20)),
                            const SizedBox(height: 4),
                            Text('${_mockAdminWeapons.length} total weapons', style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8941F)]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 4))],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminAddProductScreen()));
                            },
                            icon: const Icon(Icons.add, color: Color(0xFF1A0F35)),
                            label: const Text('Add Weapon', style: TextStyle(color: Color(0xFF1A0F35), fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    ..._filteredWeapons.map((weapon) => _buildWeaponCard(weapon)).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeaponCard(AdminWeapon weapon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E143C).withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
        boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.1), blurRadius: 32, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(weapon.name, style: const TextStyle(color: Color(0xFFF5F3FF), fontSize: 18)),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(weapon.rarity, (index) => const Icon(Icons.star, color: Color(0xFFD4AF37), size: 12)),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminEditProductScreen(weaponId: weapon.id)));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E143C).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.edit, color: Color(0xFFD4AF37), size: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _deleteWeapon(weapon.id),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E143C).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.delete, color: Color(0xFFD4183D), size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoBox('Type', weapon.type),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoBox('Price', '${weapon.price}', isGold: true),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoBox('Stock', '${weapon.stock} units', isRed: weapon.stock < 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, {bool isGold = false, bool isRed = false}) {
    Color valueColor = const Color(0xFFF5F3FF);
    if (isGold) valueColor = const Color(0xFFD4AF37);
    if (isRed) valueColor = const Color(0xFFD4183D);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E143C).withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontFamily: isGold ? 'Serif' : null,
            ),
          ),
        ],
      ),
    );
  }
}
