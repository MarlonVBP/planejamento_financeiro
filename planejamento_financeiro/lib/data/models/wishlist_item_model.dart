class WishlistItemModel {
  final String id;
  final String title;
  final double price;
  final double savedAmount;
  final int priority; // 1: Alta, 2: Média, 3: Baixa
  final bool isCompleted;

  WishlistItemModel({
    required this.id,
    required this.title,
    required this.price,
    required this.savedAmount,
    this.priority = 2,
    this.isCompleted = false,
  });

  factory WishlistItemModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return WishlistItemModel(
      id: id,
      title: map['title'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      savedAmount: (map['savedAmount'] ?? 0).toDouble(),
      priority: map['priority'] ?? 2,
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'savedAmount': savedAmount,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }
}