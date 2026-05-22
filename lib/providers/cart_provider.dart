import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      final newState = [...state];
      newState[existingIndex] = CartItem(
        product: newState[existingIndex].product, 
        quantity: newState[existingIndex].quantity + 1
      );
      state = newState;
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final newState = [...state];
    final index = newState.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      newState[index] = CartItem(
        product: newState[index].product,
        quantity: quantity
      );
      state = newState;
    }
  }

  double get totalPrice {
    return state.fold(0.0, (total, item) => total + (item.product.price * item.quantity));
  }

  void clearAll() {
    state = [];
  }
}
