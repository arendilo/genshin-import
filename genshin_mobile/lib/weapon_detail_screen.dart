import 'package:flutter/material.dart';

class WeaponDetail {
  final String name;
  final String type;
  final int price;
  final String image;
  final int rarity;
  final String description;
  final int stock;
  final int baseAttack;
  final String critRate;

  const WeaponDetail({
    required this.name,
    required this.type,
    required this.price,
    required this.image,
    required this.rarity,
    required this.description,
    required this.stock,
    required this.baseAttack,
    required this.critRate,
  });
}

class WeaponDetailScreen extends StatefulWidget {
  final int weaponId;

  const WeaponDetailScreen({Key? key, required this.weaponId}) : super(key: key);

  @override
  State<WeaponDetailScreen> createState() => _WeaponDetailScreenState();
}

class _WeaponDetailScreenState extends State<WeaponDetailScreen> {
  bool _isFavorite = false;

  final Map<int, WeaponDetail> _weaponDetails = {
    1: const WeaponDetail(
      name: "Primordial Jade Cutter",
      type: "Sword",
      price: 4999,
      image: "assets/images/jade-cutter.png",
      rarity: 5,
      description: "A ceremonial sword masterfully crafted from pure jade. It has a faint, ethereal glow that seems to transcend the boundaries of this world.",
      stock: 12,
      baseAttack: 542,
      critRate: "44.1%",
    ),
  };

  @override
  Widget build(BuildContext context) {
    // Fallback to weapon 1 if not found
    final weapon = _weaponDetails[widget.weaponId] ?? _weaponDetails[1]!;

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
              // AppBar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0F35).withOpacity(0.95),
                  border: Border(bottom: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Color(0xFFD4AF37)),
                    ),
                    const Text('Weapon Details', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 18)),
                    GestureDetector(
                      onTap: () => setState(() => _isFavorite = !_isFavorite),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? const Color(0xFFD4AF37) : const Color(0xFFA89EC9),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 100),
                  children: [
                    // Image Card
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E143C).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                        boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.15), blurRadius: 32, offset: const Offset(0, 8))],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0, right: 0,
                            child: Container(
                              width: 120, height: 120,
                              decoration: BoxDecoration(color: const Color(0xFFD4AF37).withOpacity(0.1), shape: BoxShape.circle),
                            ),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star, size: 100, color: Colors.white24), // Placeholder image
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(weapon.rarity, (index) => const Icon(Icons.star, color: Color(0xFFD4AF37), size: 16)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(weapon.name, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 28, fontFamily: 'Serif')),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                          ),
                          child: Text(weapon.type, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 14)),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B5BB5).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF6B5BB5).withOpacity(0.3)),
                          ),
                          child: const Text('5-Star Weapon', style: TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Description
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E143C).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Description', style: TextStyle(color: Color(0xFFF5F3FF), fontSize: 16, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 12),
                          Text(weapon.description, style: const TextStyle(color: Color(0xFFA89EC9), height: 1.5)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stats
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('Base ATK', weapon.baseAttack.toString())),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStatCard('CRIT Rate', weapon.critRate)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Price & Stock
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E143C).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Price', style: TextStyle(color: Color(0xFFA89EC9))),
                              const SizedBox(height: 4),
                              Text('${weapon.price.toLocaleString()} Mora', style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 24, fontFamily: 'Serif')),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('In Stock', style: TextStyle(color: Color(0xFFA89EC9))),
                              const SizedBox(height: 4),
                              Text('${weapon.stock} units', style: const TextStyle(color: Color(0xFFF5F3FF), fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Bar
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0F35).withOpacity(0.95),
          border: Border(top: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2))),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart, color: Color(0xFFF5F3FF)),
                label: const Text('Add to Cart', style: TextStyle(color: Color(0xFFF5F3FF))),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                  backgroundColor: const Color(0xFF1E143C).withOpacity(0.6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8941F)]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 4))],
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Buy Now', style: TextStyle(color: Color(0xFF1A0F35), fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E143C).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: Color(0xFFD4AF37), size: 16),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Color(0xFFA89EC9), fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Color(0xFFF5F3FF), fontSize: 20)),
        ],
      ),
    );
  }
}

extension on int {
  String toLocaleString() {
    return this.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}
