import 'package:firebase_database/firebase_database.dart';
import '../models/wishlist_item_model.dart';

class WishlistService {
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('wishlist');

  Future<void> addItem(WishlistItemModel item) async {
    await _ref.push().set(item.toMap());
  }

  Future<void> updateItem(WishlistItemModel item) async {
    await _ref.child(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await _ref.child(id).remove();
  }

  Stream<List<WishlistItemModel>> getWishlistStream() {
    return _ref.onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];

      final Map<dynamic, dynamic> map = data as Map<dynamic, dynamic>;
      final List<WishlistItemModel> items = [];

      map.forEach((key, value) {
        items.add(WishlistItemModel.fromMap(key, value));
      });

      // Ordenar: Não completados primeiro
      items.sort((a, b) {
        if (a.isCompleted == b.isCompleted) return 0;
        return a.isCompleted ? 1 : -1;
      });
      return items;
    });
  }
}
