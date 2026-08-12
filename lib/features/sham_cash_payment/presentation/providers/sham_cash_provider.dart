import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/sham_cash_payment/data/datasources/sham_cash_remote_data_source.dart';
import 'package:restaurants_system/features/sham_cash_payment/data/repositories/sham_cash_repository_impl.dart';
import 'package:restaurants_system/features/sham_cash_payment/domain/repositories/sham_cash_repository.dart';
import 'package:restaurants_system/features/sham_cash_payment/presentation/providers/sham_cash_notifier.dart';
import 'package:restaurants_system/features/sham_cash_payment/presentation/providers/sham_cash_state.dart';

final shamCashRepositoryProvider = Provider<ShamCashRepository>((ref) {
  return ShamCashRepositoryImpl(ShamCashRemoteDataSource());
});

final shamCashNotifierProvider = NotifierProvider<ShamCashNotifier, ShamCashState>(
  ShamCashNotifier.new,
);