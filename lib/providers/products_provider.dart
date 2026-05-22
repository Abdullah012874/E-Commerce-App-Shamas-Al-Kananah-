import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/dummy_data.dart';
import '../models/product.dart';

class ProductsNotifier extends StateNotifier<List<Product>> {
  ProductsNotifier() : super(DummyData.products);

  void updateProductPrice(String id, double newPrice) {
    state = [
      for (final p in state)
        if (p.id == id)
          Product(
            id: p.id,
            name: p.name,
            price: newPrice,
            rating: p.rating,
            reviews: p.reviews,
            category: p.category,
            imageUrl: p.imageUrl,
            inStock: p.inStock,
          )
        else
          p,
    ];
  }

  void updateProductInfo(String id, String newName, String newCategory) {
    state = [
      for (final p in state)
        if (p.id == id)
          Product(
            id: p.id,
            name: newName,
            price: p.price,
            rating: p.rating,
            reviews: p.reviews,
            category: newCategory,
            imageUrl: p.imageUrl,
            inStock: p.inStock,
          )
        else
          p,
    ];
  }

  void deleteProduct(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}

final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) {
  return ProductsNotifier();
});

final searchProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final minPriceProvider = StateProvider<double>((ref) => 0);
final maxPriceProvider = StateProvider<double>((ref) => 1000);
final ratingFilterProvider = StateProvider<double>((ref) => 0);
final inStockProvider = StateProvider<bool>((ref) => false);

final searchedProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  final searchQuery = ref.watch(searchProvider).toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final minPrice = ref.watch(minPriceProvider);
  final maxPrice = ref.watch(maxPriceProvider);
  final rating = ref.watch(ratingFilterProvider);
  final inStock = ref.watch(inStockProvider);

  var filteredProducts = products;

  if (selectedCategory != null) {
    filteredProducts = filteredProducts.where((p) => p.category == selectedCategory).toList();
  }

  filteredProducts = filteredProducts.where((p) => p.price >= minPrice && p.price <= maxPrice).toList();
  
  if (rating > 0) {
    filteredProducts = filteredProducts.where((p) => p.rating >= rating).toList();
  }

  if (inStock) {
    filteredProducts = filteredProducts.where((p) => p.inStock).toList();
  }

  if (searchQuery.isNotEmpty) {
    filteredProducts = filteredProducts.where((product) {
      return product.name.toLowerCase().contains(searchQuery) ||
             product.category.toLowerCase().contains(searchQuery);
    }).toList();
  }

  return filteredProducts;
});
