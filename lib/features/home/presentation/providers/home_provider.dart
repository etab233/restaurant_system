import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/home/data/datasources/home_local_data_source.dart';
import 'package:restaurants_system/features/home/data/datasources/home_remote_data_source.dart';
import 'package:restaurants_system/features/home/data/repositories/home_repository_impl.dart';
import 'package:restaurants_system/features/home/domain/repositories/home_repository.dart';
import 'package:restaurants_system/features/home/presentation/providers/home_notifier.dart';
import 'package:restaurants_system/features/home/presentation/providers/home_state.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(HomeRemoteDataSource(), HomeLocalDataSource());
});

final homeNotifierProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);