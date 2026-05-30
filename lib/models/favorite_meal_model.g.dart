// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_meal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteMealAdapter extends TypeAdapter<FavoriteMeal> {
  @override
  final int typeId = 4;

  @override
  FavoriteMeal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteMeal(
      itemId: (fields[0] as num).toInt(),
      restaurantId: (fields[1] as num).toInt(),
      name: fields[2] as String,
      image: fields[3] as String?,
      description: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteMeal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.restaurantId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteMealAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
