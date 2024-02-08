import 'dart:typed_data';

import 'package:dio/dio.dart';

class FileModel {
  Uint8List formData;
  String? fileName;
  Uint8List? thumbnailData;
  // FilePosition filePosition;
  String? filePath;
  String? thumbnailPath;
  double? sizeInKB;
  int? width;
  int? height;
  CancelToken? cancelToken;

  FileModel({
    required this.formData,
    required this.fileName,
    this.thumbnailData,
    this.filePath,
    this.thumbnailPath,
    this.width,
    this.height,
    this.sizeInKB,
    this.cancelToken,
    // required this.filePosition,
  });

  CancelToken get fileCancelToken {
    cancelToken ??= CancelToken();
    return cancelToken!;
  }
}

enum FilePosition { profile, message }
