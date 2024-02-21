import 'package:flutter/cupertino.dart';
import 'package:messaging_core/core/utils/extensions.dart';

enum ContentTypeEnum {
  text,
  linkableText,
  image,
  file,
  video,
  location,
  sticker,
  gif,
  other,
  transaction,
  unsupported,
  command,
  voice,
  contact,
  encryptedText,
  localDeleted,
  referralBonus,
  sms,
  call;

  static ContentTypeEnum fromString(String name) {
    // switch (name) {
    //   case "mp4":
    //     name = "video";
    //   case "mp3":
    //     name = "video";
    //   case "jpg":
    //     name = "image";
    //   default:
    //     name = "text";
    // }
    switch (name) {
      case "text":
        return text;
      case "linkableText":
        return linkableText;
      case "image":
        return image;
      case "file":
        return file;
      case "video":
        return video;
      case "location":
        return location;
      case "sticker":
        return sticker;
      case "gif":
        return gif;
      case "transaction":
        return transaction;
      case "contact":
        return contact;
      case "call":
        return call;
      case "localDeleted":
        return localDeleted;
      case "voice":
        return voice;
      case "audio":
        return voice;
      case "command":
        return command;
      case "encryptedText":
        return encryptedText;
      case "referralBonus":
        return referralBonus;
      case "sms":
        return sms;
      case "other":
        return other;
      default:
        return unsupported;
    }
  }

  @override
  String toString() {
    switch (this) {
      case text:
        return "text";
      case voice:
        return "audio";
      case video:
        return "video";
      case image:
        return "image";
      case file:
        return "file";
      case contact:
        return "contact";
      case other:
        return "other";
      default:
        return "text";
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
