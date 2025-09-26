enum MessageType {
  text,
  image,
  file,
}

extension MessageTypeExtension on MessageType {
  String get name {
    switch (this) {
      case MessageType.text:
        return "text";
      case MessageType.image:
        return "image";
      case MessageType.file:
        return "file";
    }
  }
}
