import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:restaurants_system/features/order_tracking/data/datasources/order_realtime_data_source.dart';
import 'package:restaurants_system/features/order_tracking/data/datasources/order_remote_data_source.dart';
import 'package:restaurants_system/features/order_tracking/data/repositories/order_repository_impl.dart';
import 'package:restaurants_system/features/order_tracking/domain/repositories/order_repository.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order/order_notifier.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order/order_state.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(
    OrderRemoteDataSource(),
    OrderRealtimeDataSource(),
  );
});

final orderNotifierProvider = NotifierProvider<OrderNotifier, OrderState>(
  OrderNotifier.new,
);
// لمراقبة حالة كل طلب لحاله لمعرفة أي طلب قام المتخدم بالضغط على زر الدفع الخاص به
final shamCashPaymentLoadingProvider = StateProvider.family<bool, String>(
  (ref, referenceNumber) => false,
);
