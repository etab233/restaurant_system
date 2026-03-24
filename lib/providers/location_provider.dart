import 'package:latlong2/latlong.dart';
import 'package:riverpod/riverpod.dart';
import 'package:restaurants_system/notifier/location_notifier.dart';

final locationProvider = NotifierProvider<LocationNotifier,LocationState>((){
  return LocationNotifier();
});

final userLocationProvider = Provider<LatLng>((ref) {
  return ref.watch(locationProvider).userLocation;
});
