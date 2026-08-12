import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:restaurants_system/core/location/domain/repositories/location_repository.dart';
import 'package:restaurants_system/core/location/presentation/providers/location_picker_state.dart';
import 'package:restaurants_system/core/location/presentation/providers/location_provider.dart';

const _defaultLocation = LatLng(35.5148, 35.7768);

final locationPickerNotifierProvider =
    NotifierProvider.autoDispose<LocationPickerNotifier, LocationPickerScreenState>(
  LocationPickerNotifier.new,
);

class LocationPickerNotifier extends Notifier<LocationPickerScreenState> {
  late LocationRepository _repository;

  @override
  LocationPickerScreenState build() {
    _repository = ref.read(locationRepositoryProvider);
    return const LocationPickerScreenState(
      pickedLocation: _defaultLocation,
      addressText: 'Move the map to select location',
      addressLoading: false,
    );
  }

  void initializeWith(LatLng location) {
    state = state.copyWith(pickedLocation: location);
  }

  Future<void> pickLocationOnMap(LatLng location) async {
    state = state.copyWith(addressLoading: true, message: "");
    final result = await _repository.reverseGeocode(location);

    state = state.copyWith(
      pickedLocation: location,
      addressText: result.isSuccess
          ? result.address!
          : "this address not found, please type it in the field above",
      addressLoading: false,
    );
  }

  Future<void> useCurrentLocation() async {
    state = state.copyWith(addressLoading: true, message: "");
    final result = await _repository.getCurrentLocation();

    if (!result.isSuccess) {
      state = state.copyWith(message: result.message, addressLoading: false);
      return;
    }

    await pickLocationOnMap(LatLng(result.lat!, result.lng!));
  }

  /// نفس خوارزمية "جرب كلمات أقل" الأصلية بالضبط
  Future<void> searchAddress(String address) async {
    state = state.copyWith(message: "", findAddress: false);
    final query = address.trim();
    if (query.isEmpty) return;

    final parts = query.split(" ");
    for (int i = parts.length; i > 0; i--) {
      final attempt = parts.sublist(0, i).join(" ");
      final result = await _repository.searchAddress(attempt);

      if (result.isNetworkError) {
        state = state.copyWith(message: "search error", findAddress: false);
        return;
      }

      if (!result.isSuccess) continue;

      final newPosition = LatLng(result.lat!, result.lon!);
      state = state.copyWith(
        pickedLocation: newPosition,
        addressText: query,
        findAddress: true,
      );

      if (attempt != query) {
        state = state.copyWith(
          findAddress: false,
          message: "لم يتم العثور على العنوان بدقة. تم تحديد أقرب موقع معروف. يرجى ضبط الموقع على الخريطة",
        );
      }
      return;
    }

    state = state.copyWith(
      findAddress: false,
      message: "لم يتم العثور على العنوان، يرجى تحديده على الخريطة",
    );
  }
}