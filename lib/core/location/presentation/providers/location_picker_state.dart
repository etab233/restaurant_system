import 'package:latlong2/latlong.dart';

class LocationPickerScreenState {
  final LatLng pickedLocation;
  final String addressText;
  final bool addressLoading;
  final bool findAddress;
  final String message;

  const LocationPickerScreenState({
    required this.pickedLocation,
    required this.addressText,
    required this.addressLoading,
    this.findAddress = false,
    this.message = "",
  });

  LocationPickerScreenState copyWith({
    LatLng? pickedLocation,
    String? addressText,
    bool? addressLoading,
    bool? findAddress,
    String? message,
  }) {
    return LocationPickerScreenState(
      pickedLocation: pickedLocation ?? this.pickedLocation,
      addressText: addressText ?? this.addressText,
      addressLoading: addressLoading ?? this.addressLoading,
      findAddress: findAddress ?? this.findAddress,
      message: message ?? this.message,
    );
  }
}