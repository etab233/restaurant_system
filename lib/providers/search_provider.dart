import 'package:restaurants_system/notifier/search_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider = NotifierProvider<SearchNotifier, SearchState>((){
  return SearchNotifier();
});

final queryProvider = Provider<String>((ref){
  return ref.watch(searchProvider).query;
});

final messageProvider = Provider<String>((ref){
  return ref.watch(searchProvider).message;
});