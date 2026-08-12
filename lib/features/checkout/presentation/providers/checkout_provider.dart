import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/features/checkout/presentation/providers/checkout_notifier.dart';
import 'package:restaurants_system/features/checkout/presentation/providers/checkout_state.dart';

final checkoutProvider = NotifierProvider<CheckoutNotifier, CheckoutState>(
  CheckoutNotifier.new,
);