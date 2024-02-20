import 'package:flutter/cupertino.dart';
import 'package:messaging_core/core/utils/extensions.dart';

enum OtherContentTypeEnum {
  contact,
  unsupported;

  static OtherContentTypeEnum fromString(String name) {
    name = name.toLowerCase();
    switch (name) {
      case "contact":
        return contact;
      default:
        return unsupported;
    }
  }

  @override
  String toString() {
    switch (this) {
      case contact:
        return "contact";
      default:
        return "contact";
    }
  }
}
