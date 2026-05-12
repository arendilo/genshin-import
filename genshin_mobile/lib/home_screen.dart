import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'weapon_detail_screen.dart';
import 'profile_screen.dart';
class Weapon {
  final int id;
  final String name;
  final String type;
  final int price;
  final String image;
  final int rarity;
  final bool isFavorite;

  Weapon({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.image,
    required this.rarity,
    required this.isFavorite,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ["All", "Sword", "Claymore", "Polearm", "Bow", "Catalyst"];

  List<Weapon> _weapons = [
    Weapon(id: 1, name: "Primordial Jade Cutter", type: "Sword", price: 4999, image: "assets/images/jade-cutter.png", rarity: 5, isFavorite: false),
    Weapon(id: 2, name: "Staff of Homa", type: "Polearm", price: 5999, image: "assets/images/homa.png", rarity: 5, isFavorite: true),
    Weapon(id: 3, name: "Amos' Bow", type: "Bow", price: 4599, image: "assets/images/amos-bow.png", rarity: 5, isFavorite: false),
    Weapon(id: 4, name: "Lost Prayer", type: "Catalyst", price: 4799, image: "assets/images/lost-prayer.png", rarity: 5, isFavorite: false),
    Weapon(id: 5, name: "Wolf's Gravestone", type: "Claymore", price: 5299, image: "assets/images/wolfs-gravestone.png", rarity: 5, isFavorite: true),
    Weapon(id: 6, name: "Skyward Blade", type: "Sword", price: 4399, image: "assets/images/skyward-blade.png", rarity: 5, isFavorite: false),
  ];

  void _toggleFavorite(int id) {
    setState(() {
      final index = _weapons.indexWhere((w) => w.id == id);
      if (index != -1) {
        final w = _weapons[index];
        _weapons[index] = Weapon(
          id: w.id, name: w.name, type: w.type, price: w.price,
          image: w.image, rarity: w.rarity, isFavorite: !w.isFavorite,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredWeapons = _weapons.where((w) {
      final matchesSearch = w.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || w.type == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0820),
              Color(0xFF1A0F35),
              Color(0xFF2A1F4A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Welcome back,', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 24)),
                    const SizedBox(height: 4),
                    const Text('Traveler', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 32, fontFamily: 'Serif')),
                    const SizedBox(height: 24),

                    // Search Bar
                    TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: const TextStyle(color: Color(0xFFF5F3FF)),
                      decoration: InputDecoration(
                        hintText: 'Search for weapons...',
                        hintStyle: const TextStyle(color: Color(0xFF6B5BB5)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFFA89EC9)),
                        filled: true,
                        fillColor: const Color(0xFF1E143C).withOpacity(0.6),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Categories
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategory == category;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedCategory = category),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8941F)])
                                      : null,
                                  color: isSelected ? null : const Color(0xFF1E143C).withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                  border: isSelected ? null : Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                                  boxShadow: isSelected
                                      ? [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 4))]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color: isSelected ? const Color(0xFF1A0F35) : const Color(0xFFA89EC9),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: filteredWeapons.length,
                  itemBuilder: (context, index) {
                    final weapon = filteredWeapons[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WeaponDetailScreen(weaponId: weapon.id)),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E143C).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD4AF37).withOpacity(0.1),
                              blurRadius: 32,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                // Weapon Image Mock
                                Expanded(
                                  child: Center(
                                    // Normally Image.asset(weapon.image), using Icon for now until assets are added to pubspec.yaml
                                    child: Icon(Icons.star, size: 80, color: Colors.white.withOpacity(0.2)),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Rarity
                                Row(
                                  children: List.generate(weapon.rarity, (i) => const Icon(Icons.star, color: Color(0xFFD4AF37), size: 12)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  weapon.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Color(0xFFF5F3FF), fontWeight: FontWeight.w500),
                                ),
                                Text(weapon.type, style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 12)),
                                const SizedBox(height: 8),
                                Text(
                                  '${weapon.price} Mora',
                                  style: const TextStyle(color: Color(0xFFD4AF37), fontFamily: 'Serif', fontSize: 16),
                                ),
                              ],
                            ),
                            // Favorite Button
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _toggleFavorite(weapon.id),
                                child: Icon(
                                  weapon.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: weapon.isFavorite ? const Color(0xFFD4AF37) : const Color(0xFFA89EC9),
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      
      // Bottom Nav
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF1A0F35).withOpacity(0.95),
          border: Border(top: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', true, () {}),
            _buildNavItem(Icons.shopping_cart_outlined, 'Cart', false, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            }),
            _buildNavItem(Icons.person_outline, 'Profile', false, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFFA89EC9)),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFFA89EC9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
