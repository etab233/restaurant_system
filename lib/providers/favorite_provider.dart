import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/notifier/favorite_notifier.dart';

final favoritesProvider =
    NotifierProvider<FavoriteNotifier, FavoriteState>(
  FavoriteNotifier.new,
);