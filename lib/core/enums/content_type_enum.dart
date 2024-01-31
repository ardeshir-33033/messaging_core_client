import 'package:flutter/cupertino.dart';
import 'package:messaging_core/core/utils/extensions.dart';

enum ContentTypeEnum {
  text,
  linkableText,
  image,
  file,
  location,
  sticker,
  gif,
  transaction,
  unsupported,
  command,
  voice,
  encryptedText,
  localDeleted,
  referralBonus,
  sms,
  call;

  static ContentTypeEnum fromString(String name) {
    switch (name) {
      case "text":
        return text;
      case "linkableText":
        return linkableText;
      case "image":
        return image;
      case "file":
        return file;
      case "location":
        return location;
      case "sticker":
        return sticker;
      case "gif":
        return gif;
      case "transaction":
        return transaction;
      case "call":
        return call;
      case "localDeleted":
        return localDeleted;
      case "voice":
        return voice;
      case "command":
        return command;
      case "encryptedText":
        return encryptedText;
      case "referralBonus":
        return referralBonus;
      case "sms":
        return sms;
      default:
        return unsupported;
    }
  }

  String translate(BuildContext context) {
    switch (this) {
      case ContentTypeEnum.voice:
        return "Voice Message";
      case ContentTypeEnum.image:
        return "Image";
      case ContentTypeEnum.file:
        return "File";
      default:
        return "";
    }
  }

  bool get isGeneralContent {
    switch (this) {
      case ContentTypeEnum.call:
        return true;
      case ContentTypeEnum.command:
        return true;
      case ContentTypeEnum.referralBonus:
        return true;
      default:
        return false;
    }
  }
}
