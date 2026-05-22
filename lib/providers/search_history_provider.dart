import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchHistoryNotifier extends StateNotifier<List<String>> {
  SearchHistoryNotifier() : super([]);

  void addSearchTerm(String term) {
    if (term.isEmpty) return;
    final currentState = state;
    if (currentState.contains(term)) {
      currentState.remove(term);
    }
    state = [term, ...currentState];
  }

  void removeSearchTerm(String term) {
    state = state.where((t) => t != term).toList();
  }

  void clearHistory() {
    state = [];
  }
}

final searchHistoryProvider = StateNotifierProvider<SearchHistoryNotifier, List<String>>((ref) {
  return SearchHistoryNotifier();
});
