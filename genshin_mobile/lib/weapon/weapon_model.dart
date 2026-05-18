class WeaponDetail {
  final int id;
  final String name;
  final String type;
  final int price;
  final String image;
  final int rarity;
  final String description;
  final int stock;
  final int baseAttack;
  final String critRate;
  bool isFavorite;

  WeaponDetail({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.image,
    required this.rarity,
    required this.description,
    required this.stock,
    required this.baseAttack,
    required this.critRate,
    this.isFavorite = false,
  });
}

class WeaponData {
  static List<WeaponDetail> allWeapons = [
    WeaponDetail(
      id: 1,
      name: "Primordial Jade Cutter",
      type: "Sword",
      price: 4999,
      image: "assets/images/jade-cutter.png",
      rarity: 5,
      description:
          "A ceremonial sword masterfully crafted from pure jade. It has a faint, ethereal glow.",
      stock: 12,
      baseAttack: 542,
      critRate: "44.1%",
    ),
    WeaponDetail(
      id: 2,
      name: "Staff of Homa",
      type: "Polearm",
      price: 5999,
      image: "assets/images/homa.png",
      rarity: 5,
      description:
          "A crimson polearm used in ancient rituals. Sharp as funeral pyre flames.",
      stock: 5,
      baseAttack: 608,
      critRate: "66.2% CDMG",
      isFavorite: true,
    ),
    WeaponDetail(
      id: 3,
      name: "Amos' Bow",
      type: "Bow",
      price: 4599,
      image: "assets/images/amos-bow.png",
      rarity: 5,
      description:
          "An ancient bow that draws power from the air. Stronger impact at distance.",
      stock: 8,
      baseAttack: 608,
      critRate: "49.6% ATK",
    ),
    WeaponDetail(
      id: 4,
      name: "Lost Prayer",
      type: "Catalyst",
      price: 4799,
      image: "assets/images/lost-prayer.png",
      rarity: 5,
      description:
          "A manual used by the faithful. Grants movement speed and elemental power.",
      stock: 15,
      baseAttack: 608,
      critRate: "33.1%",
    ),
    WeaponDetail(
      id: 5,
      name: "Wolf's Gravestone",
      type: "Claymore",
      price: 5299,
      image: "assets/images/wolfs-gravestone.png",
      rarity: 5,
      description:
          "A heavy claymore that resonates with the user's fighting spirit.",
      stock: 3,
      baseAttack: 608,
      critRate: "49.6% ATK",
      isFavorite: true,
    ),
    WeaponDetail(
      id: 6,
      name: "Skyward Blade",
      type: "Sword",
      price: 4399,
      image: "assets/images/skyward-blade.png",
      rarity: 5,
      description:
          "The sword representing Dvalin's honor. Pulses with sky power.",
      stock: 20,
      baseAttack: 608,
      critRate: "55.1% ER",
    ),
  ];
}
