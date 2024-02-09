import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messaging_core/core/enums/file_type.dart';
import 'package:messaging_core/core/env/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

void postFrameCallback(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) => callback.call());
}

String? getThumbnailUrl(String? originalUrl) {
  return originalUrl?.replaceFirst(
      RegExp(r'_\d+\.\w+$'), '_1.$thumbnailFileExtension');
}

String getFileExtension(String? fileName) {
  if (fileName == null) return '';
  return RegExp(r'\.(\w+)$').firstMatch(fileName)?.group(1) ?? '';
}

void dismissKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

Future<void> copyToClipboard(String text) async {
  await Clipboard.setData(
    ClipboardData(
      text: text,
    ),
  );
  Fluttertoast.showToast(
    msg: "Copied",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey[600],
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future<void> launchExternalUrl(
  String url, {
  Function(dynamic)? onError,
}) async {
  try {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.platformDefault,
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
      ),
    );
  } catch (e) {
    onError?.call(e);
  }
}

Future<bool> isImageCached(String key) async {
  return await DefaultCacheManager().getFileFromCache(key) != null;
}

String getImageCacheKey(String key, {bool thumbnail = false}) {
  return 'image_$key${thumbnail ? '_thumbnail' : ''}';
}

Future<File?> getCachedFile(String key, FileType fileType) async {
  if (fileType == FileType.file || fileType == FileType.audio) {
    final directory = await getTemporaryDirectory();
    final file = File("${directory.path}/$key");
    if (file.existsSync()) {
      return file;
    }
    return null;
  }
  final fileInfo = await getCachedImage(key);
  return fileInfo?.file;
}

Future<FileInfo?> getCachedImage(String key) {
  return DefaultCacheManager().getFileFromCache(key);
}

String generateUUID() {
  var uuid = const Uuid();
  return uuid.v4();
}


Future cacheFile(String key, Uint8List fileBytes) async {
  await DefaultCacheManager().putFile(key, fileBytes);
}
