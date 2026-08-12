import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/realtime/pusher_manager.dart';
import 'package:restaurants_system/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:restaurants_system/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:restaurants_system/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:restaurants_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_notifier.dart';
import 'package:restaurants_system/features/auth/presentation/providers/auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final repo=  AuthRepositoryImpl(AuthRemoteDatasource(), AuthLocalDataSource());
  PusherManager.instance.setAuthRepository(repo);
  return repo;
});

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);