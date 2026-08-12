import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/order_tracking/data/datasources/order_realtime_data_source.dart';
import 'package:restaurants_system/features/order_tracking/data/datasources/order_remote_data_source.dart';
import 'package:restaurants_system/features/order_tracking/data/repositories/order_repository_impl.dart';
import 'package:restaurants_system/features/order_tracking/domain/repositories/order_repository.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order_track/order_track_notifier.dart';
import 'package:restaurants_system/features/order_tracking/presentation/providers/order_track/order_track_state.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(OrderRemoteDataSource(), OrderRealtimeDataSource());
});

final orderTrackNotifierProvider =
    NotifierProvider<OrderTrackNotifier, OrderTrackState>(OrderTrackNotifier.new);
