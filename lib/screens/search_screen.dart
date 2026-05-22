import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';
import '../providers/search_history_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/app_drawer.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const FilterSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(searchedProductsProvider);
    final searchHistory = ref.watch(searchHistoryProvider);
    final searchQuery = ref.watch(searchProvider);
    final searchController = TextEditingController(text: searchQuery);

    // To prevent cursor from jumping to beginning
    searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Search & Explore'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: (value) {
                      ref.read(searchProvider.notifier).state = value;
                    },
                    onSubmitted: (value) {
                      ref.read(searchHistoryProvider.notifier).addSearchTerm(value.trim());
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: () => _showFilterSheet(context, ref),
                  ),
                ),
              ],
            ),
          ),
          if (searchQuery.isEmpty && searchHistory.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Searches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  TextButton(
                    onPressed: () => ref.read(searchHistoryProvider.notifier).clearHistory(),
                    child: const Text('Clear All', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                children: searchHistory.map((term) {
                  return InputChip(
                    label: Text(term),
                    onDeleted: () => ref.read(searchHistoryProvider.notifier).removeSearchTerm(term),
                    onPressed: () {
                      ref.read(searchProvider.notifier).state = term;
                    },
                  );
                }).toList(),
              ),
            ),
            const Divider(),
          ],
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('No products found.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  @override
  Widget build(BuildContext context) {
    final minPrice = ref.watch(minPriceProvider);
    final maxPrice = ref.watch(maxPriceProvider);
    final rating = ref.watch(ratingFilterProvider);
    final inStock = ref.watch(inStockProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filters', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          
          const Text('Price Range', style: TextStyle(fontWeight: FontWeight.bold)),
          RangeSlider(
            values: RangeValues(minPrice, maxPrice),
            min: 0,
            max: 1000,
            divisions: 20,
            labels: RangeLabels('${minPrice.round()} SAR', '${maxPrice.round()} SAR'),
            activeColor: Colors.orange,
            onChanged: (values) {
              ref.read(minPriceProvider.notifier).state = values.start;
              ref.read(maxPriceProvider.notifier).state = values.end;
            },
          ),
          
          const SizedBox(height: 16),
          const Text('Minimum Rating', style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: rating,
            min: 0,
            max: 5,
            divisions: 5,
            label: rating > 0 ? '$rating Stars' : 'Any',
            activeColor: Colors.orange,
            onChanged: (value) {
              ref.read(ratingFilterProvider.notifier).state = value;
            },
          ),
          
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('In Stock Only', style: TextStyle(fontWeight: FontWeight.bold)),
            value: inStock,
            activeColor: Colors.orange,
            onChanged: (value) {
              ref.read(inStockProvider.notifier).state = value;
            },
            contentPadding: EdgeInsets.zero,
          ),
          
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                ref.read(searchProvider.notifier).state = '';
                ref.read(selectedCategoryProvider.notifier).state = null;
                ref.read(minPriceProvider.notifier).state = 0;
                ref.read(maxPriceProvider.notifier).state = 1000;
                ref.read(ratingFilterProvider.notifier).state = 0;
                ref.read(inStockProvider.notifier).state = false;
                Navigator.pop(context);
              },
              child: const Text('Clear All Filters'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
