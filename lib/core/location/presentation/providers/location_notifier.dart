// location_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:restaurants_system/core/location/presentation/providers/location_provider.dart';
import '../../domain/repositories/location_repository.dart';
import 'location_state.dart';

final userLocationProvider = Provider<LatLng>((ref) {
  return ref.watch(locationProvider).userLocation;
});

class LocationNotifier extends Notifier<LocationState> {
  late LocationRepository _repository;

  @override
  LocationState build() {
    _repository = ref.read(locationRepositoryProvider);
    return LocationState(lat: 35.5317, lng: 35.7900, message: "");
  }

  Future<void> getCurrentLocation() async {
    state = state.copyWith(lat: 35.5317, lng: 35.7900);
    final result = await _repository.getCurrentLocation();

    state = result.isSuccess
        ? state.copyWith(lat: result.lat, lng: result.lng, message: "true")
        : state.copyWith(message: result.message);
  }
}
