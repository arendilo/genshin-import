class CartItem {
  final int id;
  final String name;
  final String type;
  final int price;
  int quantity;
  final int maxStock;
  final String? image;

  CartItem({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    this.quantity = 1,
    required this.maxStock,
    this.image,
  });
}

class CartState {
  static List<CartItem> items = [];
}
