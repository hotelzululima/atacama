import 'dart:typed_data';

import 'package:typed_messages/typed_messages.dart';

class PortMessage extends Message {
  const PortMessage(this.port, this.type, this.xx, this.data);
  final int port;
  final int type; //0 request, 1 satisfy
  final int xx;
  final Uint8List data;
  @override
  String toString() => 'PortMessage($port)';
}

class PortMessagePrototype implements IMessagePrototype<PortMessage> {
  const PortMessagePrototype();

  @override
  PortMessage decode(Uint8List bytes) {
    // read 2bytes at offset 1

    List<int> iz = [];
    var b = new ByteData.view(bytes.buffer);
    var w = 0;
    while (w < 32) {
      iz.add(b.getInt64(w));
      w += 8;
    }

    //final Uint64List iz = Uint64List.fromList(bytes.sublist(0, 32)).toList();
    int type = iz[0];
    int port = iz[1];
    int lgt = iz[2];
    int xx = iz[3];
    /*final int type = BytesReader(bytes).readUint(0, 8);
    final int port = BytesReader(bytes).readUint(8, 8);
    final int lgt = BytesReader(bytes).readUint(16, 8);
    final int xx = BytesReader(bytes).readUint(24, 8);*/

    //final Uint8List data = BytesReader(bytes).readBytes(32, 32 + lgt);
    return PortMessage(port, type, xx, bytes.sublist(32));
  }

  @override
  Uint8List encode(PortMessage message) {
    final writer = BytesWriter(message.data.lengthInBytes + 32);
    // write 1byte id at offset 0
    writer.writeBytes(Uint8List(8)
      ..buffer.asByteData().setInt64(0, message.type, Endian.big));
    writer.writeBytes(Uint8List(8)
      ..buffer.asByteData().setInt64(0, message.port, Endian.big));
    writer.writeBytes(Uint8List(8)
      ..buffer
          .asByteData()
          .setInt64(0, message.data.lengthInBytes, Endian.big));
    writer.writeBytes(
        Uint8List(8)..buffer.asByteData().setInt64(0, message.xx, Endian.big));

    /*writer.writeUint(message.type, 8);
    // write 2bytes port at offset 1
    writer.writeUint(message.port, 8); // port is 2bytes length
    writer.writeUint(message.data.length, 8); //data len
    writer.writeUint(message.xx, 8); //xxhash
    */
    writer.writeBytes(message.data);
    return writer.toBuffer();
  }

  @override
  bool validate(Uint8List bytes) {
    //TODO xxhash calc + check
    return true;
    /*final reader = BytesReader(bytes);
    if (reader.length != 3) return false;
    return reader.readSingleByte(0) == kPortMessageId;*/
  }
}
