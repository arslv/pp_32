import 'dart:typed_data';
import 'package:hive/hive.dart';

class ImageAdapter extends TypeAdapter<Uint8List> {
  @override
  final typeId = 10;

  @override
  Uint8List read(BinaryReader reader) {
    final length = reader.readInt32();
    return Uint8List.fromList(reader.readByteList(length));
  }

  @override
  void write(BinaryWriter writer, Uint8List obj) {
    writer.writeInt32(obj.length);
    writer.writeByteList(obj);
  }
}