import 'package:restaurants_system/services/api/restaurant_request_services.dart';
import 'package:riverpod/riverpod.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class RestaurantRequestState {
  final String status;
  final String message;
  final bool isLoading;
  final LatLng pickedLocation;
  final String addressField;
  final bool findAddress; // إذا المستخد كتب بالحقل عنوان محدد و استطعنا ايجاده
  final Map<String, int> categories;
  final bool isLoadCategories;

  const RestaurantRequestState({
    required this.status,
    required this.message,
    required this.isLoading,
    required this.pickedLocation,
    required this.addressField,
    required this.findAddress,
    required this.categories,
    required this.isLoadCategories,
  });

  RestaurantRequestState copyWith({
    String? status,
    String? message,
    bool? isLoading,
    LatLng? pickedLocation,
    String? addressField,
    bool? findAddress,
    Map<String, int>? categories,
    bool? isLoadCategories,
  }) {
    return RestaurantRequestState(
      status: status ?? this.status,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      pickedLocation: pickedLocation ?? this.pickedLocation,
      addressField: addressField ?? this.addressField,
      findAddress: findAddress ?? this.findAddress,
      categories: categories ?? this.categories,
      isLoadCategories: isLoadCategories ?? this.isLoadCategories,
    );
  }
}

class RestaurantRequestNotifier extends Notifier<RestaurantRequestState> {
  late RestaurantRequestServices _restaurantRequestService;
  final noLocationErrorMessage =
      "this address not found, please type it in the field above";

  @override
  RestaurantRequestState build() {
    _restaurantRequestService = RestaurantRequestServices();
    return const RestaurantRequestState(
      status: "",
      message: "",
      isLoading: true,
      pickedLocation: LatLng(35.5148, 35.7768),
      addressField: "",
      findAddress: false,
      categories: {},
      isLoadCategories: false,
    );
  }

  // تقديم طلب ليصبح صاحب مطعم
  Future<void> sendRestaurantRequest({
    required String name,
    required String description,
    required String number,
    required String address,
    double? latitude,
    double? longitude,
    required List<int> categories,
    required String token,
  }) async {
    state = state.copyWith(status: "", message: "");
    try {
      final result = await _restaurantRequestService.sendRestaurantRequest(
        name: name,
        description: description,
        number: number,
        address: address,
        latitude: latitude,
        longitude: longitude,
        categories: categories,
        token: token,
      );
      if (result.statusCode == 200) {
        final data = json.decode(result.body);
        state = state.copyWith(
          isLoading: false,
          status: data['data']?['status'] ?? "",
          message: data['message'] ?? "",
        );
      } else {
        final data = json.decode(result.body);
        if (data['errors'] != null && data['errors'] is Map) {
          final Map<String, dynamic> errors = data['errors'];

          state = state.copyWith(
            isLoading: false,
            status: "refused",
            message: errors.values.first[0],
          );
        } else if (data['message'] != null) {
          state = state.copyWith(
            isLoading: false,
            status: "refused",
            message: data['message'],
          );
        }
      }
    } catch (e) {
      state = state.copyWith(
        status: "refused",
        isLoading: false,
        message: "try again please..",
      );
    }
  }

  Future<void> updateAddressFromMap(LatLng location) async {
    state = state.copyWith(
      addressField: "",
      pickedLocation: LatLng(35.5148, 35.7768),
      message: "",
    );
    try {
      final response = await _restaurantRequestService.updateAddressFromMap(
        location,
      );

      if (response.statusCode != 200) {
        state = state.copyWith(message: noLocationErrorMessage);
        return;
      }

      final data = jsonDecode(response.body);
      if (data["display_name"] == null) {
        state = state.copyWith(message: noLocationErrorMessage);
        return;
      }

      final address = data["display_name"];
      state = state.copyWith(pickedLocation: location, addressField: address);
    } catch (e) {
      state = state.copyWith(message: noLocationErrorMessage);
      return;
    }
  }

  Future<void> getCurrentLocation() async {
    state = state.copyWith(message: "");
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(message: "Location service disabled");
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          state = state.copyWith(message: "Location permission denied");
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();

      final location = LatLng(position.latitude, position.longitude);
      state = state.copyWith(pickedLocation: location);

      // تحويل الإحداثيات إلى عنوان
      await updateAddressFromMap(location);
    } catch (e) {
      state = state.copyWith(message: "location error: $e");
    }
  }

  Future<void> searchAddress(String address) async {
    state = state.copyWith(message: "", findAddress: false);
    final query = address.trim();
    if (query.isEmpty) return;

    state = state.copyWith(message: "");

    List<String> parts = query.split(" ");
    for (int i = parts.length; i > 0; i--) {
      String attempt = parts.sublist(0, i).join(" ");

      try {
        final response = await _restaurantRequestService.searchAddress(attempt);

        if (response.statusCode != 200) continue;

        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]["lat"]);
          final lon = double.parse(data[0]["lon"]);

          final newPosition = LatLng(lat, lon);
          state = state.copyWith(
            pickedLocation: newPosition,
            addressField: query,
            findAddress: true,
          );

          //_mapController.move(newPosition, 15);
          if (attempt != query) {
            state = state.copyWith(
              findAddress: false,
              message:
                  "لم يتم العثور على العنوان بدقة. تم تحديد أقرب موقع معروف. يرجى ضبط الموقع على الخريطة",
            );
          }
          return;
        }
      } catch (e) {
        state = state.copyWith(message: "search error", findAddress: false);
        return;
      }
    }
    state = state.copyWith(
      findAddress: false,
      message: "لم يتم العثور على العنوان، يرجى تحديده على الخريطة",
    );
  }

  Future<void> fetchCategories({required String token}) async {
    state = state.copyWith(isLoadCategories: true, categories: {});
    try {
      final response = await _restaurantRequestService.fetchCategories(
        token: token,
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, int> categoriesMap = {};

        (data['data'] as Map<String, dynamic>).forEach((key, value) {
          categoriesMap[key] = value as int;
        });
        state = state.copyWith(
          isLoadCategories: false,
          categories: categoriesMap,
        );
      } else {
        state = state.copyWith(isLoadCategories: false, categories: {});
      }
    } catch (e) {
      state = state.copyWith(isLoadCategories: false, categories: {});
    }
  }
}
