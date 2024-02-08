import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart';
import 'package:messaging_core/core/enums/file_type.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileHelper {
  static final List<String> _initialPaths = ['.thumbnails/'];
  static List<String> audioSupportedExt = [
    "mp3",
    "m4a",
    "fmp4",
    "wav",
    "flv",
    "flac",
    "ogg",
    "amr",
    "mpeg"
  ];
  static List<String> imageSupportedExt = [
    "apng",
    "avif",
    "jpeg",
    "jpg",
    "png",
    "svg",
    "webp"
  ];

  static setupInitialPaths(String subPath) async {
    Directory baseDir = await getApplicationDocumentsDirectory();
    for (var path in _initialPaths) {
      Directory thumbnailDir = Directory('${baseDir.path}/$path');
      if (!thumbnailDir.existsSync()) {
        await thumbnailDir.create();
      }
    }
  }

  static Future<String> writeFileToDoc(String subPath, List<int> data) async {
    await setupInitialPaths(subPath);
    Directory baseDir = await getApplicationDocumentsDirectory();
    final file = File('${baseDir.path}$subPath');
    await file.writeAsBytes(data);
    return file.path;
  }

  static Future<Uint8List> readFile(String path) {
    final file = File(path);
    return file.readAsBytes();
  }

  static String getFileName(String path) {
    return path.split('/').last;
  }

  static double fileSizeInKB(int sizeInBytes) {
    return sizeInBytes / 1024;
  }

  static FileType getFileTypeFromExtension(String extension) {
    if (audioSupportedExt.contains(extension)) {
      return FileType.audio;
    }
    if (imageSupportedExt.contains(extension)) {
      return FileType.image;
    }
    return FileType.file;
  }

  static FileType getFileTypeFromPath(String? path) {
    return getFileTypeFromExtension(getFileExtension(path));
  }

  static Future<void> saveFileInDownloads(String fileName, File file) async {
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        var status = await Permission.manageExternalStorage.status;
        if (!status.isGranted) {
          await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            Fluttertoast.showToast(msg: "Unable to save the file.");
            return;
          }
        }
      } else {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
          if (!status.isGranted) {
            Fluttertoast.showToast(msg: "Unable to save the file.");
            return;
          }
        }
      }
      final path = Directory("/storage/emulated/0/Download/Pinngle");
      if (path.existsSync() == false) {
        await path.create();
      }
      var filePath = "/storage/emulated/0/Download/Pinngle/$fileName";
      Uint8List data = file.readAsBytesSync();
      var bytes = ByteData.view(file.readAsBytesSync().buffer);
      final buffer = bytes.buffer;
      await File(filePath).writeAsBytes(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      Fluttertoast.showToast(msg: "File saved in downloads");
    } catch (e) {
      Fluttertoast.showToast(msg: "Unable to save the file.");
    }
  }

  static Future<FileModel> fileModelFromPath(String path,
      {CancelToken? cancelToken,
      FilePosition filePosition = FilePosition.message}) async {
    final file = File(path);
    Image? image;
    if (getFileTypeFromPath(path) == FileType.image) {
      image = await decodeImageFile(path);
    }
    return FileModel(
        formData: file.readAsBytesSync(),
        fileName: FileHelper.getFileName(path),
        filePath: path,
        sizeInKB: FileHelper.fileSizeInKB(file.lengthSync()),
        cancelToken: cancelToken,
        width: image?.width,
        height: image?.height);
  }
}
