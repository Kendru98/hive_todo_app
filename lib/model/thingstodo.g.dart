// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thingstodo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ToDoAdapter extends TypeAdapter<ToDo> {
  @override
  final int typeId = 1;

  @override
  ToDo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ToDo()
      ..name = fields[0] as String
      ..createdDate = fields[1] as DateTime
      ..setreminder = fields[2] as bool
      ..endDate = fields[3] as DateTime
      ..thingstodo = (fields[4] as List).cast<String>()
      ..progress = fields[5] as double
      ..isChecked = (fields[6] as List).cast<bool>();
  }

  @override
  void write(BinaryWriter writer, ToDo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.createdDate)
      ..writeByte(2)
      ..write(obj.setreminder)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.thingstodo)
      ..writeByte(5)
      ..write(obj.progress)
      ..writeByte(6)
      ..write(obj.isChecked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToDoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
