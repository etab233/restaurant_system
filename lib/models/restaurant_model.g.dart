// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantModelAdapter extends TypeAdapter<RestaurantModel> {
  @override
  final int typeId = 0;

  @override
  RestaurantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantModel(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      description: fields[2] as String,
      address: fields[3] as String,
      phone: fields[4] as String,
      logo: fields[5] as String?,
      coverImage: fields[6] as String?,
      hours: fields[7] as RestaurantHours,
      location: fields[8] as RestaurantLocation,
      categories: (fields[9] as List).cast<Category>(),
      rate: (fields[10] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.logo)
      ..writeByte(6)
      ..write(obj.coverImage)
      ..writeByte(7)
      ..write(obj.hours)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.categories)
      ..writeByte(10)
      ..write(obj.rate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RestaurantHoursAdapter extends TypeAdapter<RestaurantHours> {
  @override
  final int typeId = 1;

  @override
  RestaurantHours read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantHours(
      opens: fields[0] as String?,
      closes: fields[1] as String?,
      isOpen: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantHours obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.opens)
      ..writeByte(1)
      ..write(obj.closes)
      ..writeByte(2)
      ..write(obj.isOpen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantHoursAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RestaurantLocationAdapter extends TypeAdapter<RestaurantLocation> {
  @override
  final int typeId = 2;

  @override
  RestaurantLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantLocation(
      latitude: (fields[0] as num?)?.toDouble(),
      longitude: (fields[1] as num?)?.toDouble(),
      distanceKm: (fields[2] as num?)?.toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantLocation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.distanceKm);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
