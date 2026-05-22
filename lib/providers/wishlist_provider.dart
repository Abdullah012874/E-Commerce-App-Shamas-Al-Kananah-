import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import 'package:state_notifier/state_notifier.dart';
final wishlistProvider = StateNotifierProvider<WishlistNotifier, List<Product>>((ref) {
  return WishlistNotifier();
});

class WishlistNotifier extends StateNotifier<List<Product>> {
  WishlistNotifier() : super([]);

  void toggleWishlist(Product product) {
    final isFavorite = state.any((p) => p.id == product.id);
    if (isFavorite) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
  }

  bool isWishlist(String productId) {
    return state.any((p) => p.id == productId);
  }

  void clearAll() {
    state = [];
  }
}
