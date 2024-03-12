import 'package:flutter/cupertino.dart';
import 'package:messaging_core/core/utils/extensions.dart';

enum OtherContentTypeEnum {
  contact,
  location,
  unsupported;

  static OtherContentTypeEnum fromString(String name) {
    name = name.toLowerCase();
    switch (name) {
      case "contact":
        return contact;
      case "location":
        return location;
      default:
        return unsupported;
    }
  }

  @override
  String toString() {
    switch (this) {
      case contact:
        return "contact";
      case location:
        return "location";
      default:
        return "contact";
    }
  }
}
