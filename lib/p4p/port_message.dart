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
    final int type = BytesReader(bytes).readUint(0, 1);
    final int port = BytesReader(bytes).readUint(1, 2);
    final int xx = BytesReader(bytes).readUint(3, 11);
    final Uint8List data =
        BytesReader(bytes).readBytes(19, bytes.lengthInBytes);
    return PortMessage(port, type, xx, data);
  }

  @override
  Uint8List encode(PortMessage message) {
    final writer = BytesWriter(message.data.lengthInBytes + 32);
    // write 1byte id at offset 0
    writer.writeSingleByte(message.type);
    // write 2bytes port at offset 1
    writer.writeUint(message.port, 2); // port is 2bytes length
    writer.writeUint(message.data.length, 8); //data len
    writer.writeUint(message.xx, 8); //xxhash
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
