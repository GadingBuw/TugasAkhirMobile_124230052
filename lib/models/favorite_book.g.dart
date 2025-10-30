// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteBookAdapter extends TypeAdapter<FavoriteBook> {
  @override
  final int typeId = 0;

  @override
  FavoriteBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteBook(
      id: fields[0] as int,
      title: fields[1] as String,
      author: fields[2] as String,
      imageUrl: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteBook obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
