import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurants_system/core/location/data/datasources/location_device_data_source.dart';
import 'package:restaurants_system/core/location/data/datasources/location_geocoding_data_source.dart';
import 'package:restaurants_system/core/location/data/datasources/location_local_data_source.dart';
import 'package:restaurants_system/core/location/data/repositories/location_repository_impl.dart';
import 'package:restaurants_system/core/location/domain/repositories/location_repository.dart';
import 'package:restaurants_system/core/location/presentation/providers/location_notifier.dart';
import 'package:restaurants_system/core/location/presentation/providers/location_state.dart';

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl(
    LocationDeviceDataSource(),
    LocationGeocodingDataSource(),
    LocationLocalDataSource(),
  );
});

final locationProvider = NotifierProvider<LocationNotifier, LocationState>(
  LocationNotifier.new,
);