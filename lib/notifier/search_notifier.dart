import 'package:restaurants_system/services/api/search_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class SearchState {
  final String query;
  final List<String> suggestions;
  final String message;

  SearchState({required this.query, required this.suggestions, required this.message});

  SearchState copyWith({String? query, List<String>? suggestions, String? message}) {
    return SearchState(
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
      message: message ?? this.message
    );
  }
}

class SearchNotifier extends Notifier<SearchState> {
  late SearchServices _searchService;
  @override
  SearchState build() {
    _searchService = SearchServices();
    return SearchState(query: "", suggestions: [], message: "");
  }

  Future<void> search({required query}) async {
    state = state.copyWith(query: "", suggestions: []);
    try {
      final response = await _searchService.search(query: query);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final suggestions = data['data'];
        final status = data['status'];
        state = state.copyWith(suggestions: suggestions, message: status);
      }
      else{
        final data = json.decode(response.body);
        state = state.copyWith(message: data['errors']);
      }
    } catch (e) {
      state = state.copyWith(message: "An error occured $e");
    }
  }
}
