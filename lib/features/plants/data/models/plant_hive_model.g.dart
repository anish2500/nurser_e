// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantHiveModelAdapter extends TypeAdapter<PlantHiveModel> {
  @override
  final int typeId = 1;

  @override
  PlantHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantHiveModel(
      id: fields[0] as String?,
      name: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      price: fields[4] as double,
      plantImages: (fields[5] as List).cast<String>(),
      createdAt: fields[6] as DateTime?,
      stock: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlantHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.plantImages)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.stock);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
