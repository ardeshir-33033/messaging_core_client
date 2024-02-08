import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:messaging_core/core/error/failures.dart';
import 'package:messaging_core/core/services/media_handler/media_progress_data.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:path_provider/path_provider.dart';

abstract class MediaHandler {
  StreamController<MediaProgressData> progressController =
      StreamController.broadcast();

  // Future<List<String>> _getUploadUrl(List<String> fileExtensions,
  //     {CancelToken? cancelToken}) async {
  //   // final response = RestClient().getConversationMediaUploadUrl(
  //   //   fileExtensions,
  //   //   cancelToken: cancelToken,
  //   // );
  //   // return response;
  // }
  //
  // Future<Either<Failure?, List<String>?>> uploadMedia(
  //   FileType fileType,
  //   HttpHeaderType headerType,
  //   FileModel? fileModel,
  //   String contentId, {
  //   String? cacheKey,
  //   CancelToken? cancelToken,
  // }) async {
  //   if (fileModel == null) return left(null);
  //   var fileExtensions = [getFileExtension(fileModel.fileName)];
  //   if (fileModel.thumbnailData != null) {
  //     fileExtensions.add(thumbnailFileExtension);
  //   }
  //   try {
  //     List<String> uploadLinks =
  //         await _getUploadUrl(fileExtensions, cancelToken: cancelToken);
  //     String mainUploadUrl = uploadLinks.first;
  //     String? thumbnailUploadUrl = uploadLinks.elementAtOrNull(1);
  //     await cachingFile(
  //       cacheKey ?? convertToDownloadUrl(mainUploadUrl),
  //       fileModel.formData,
  //       fileType,
  //       getFileExtension(fileModel.fileName),
  //     );
  //
  //     Future mainUploadFuture = RestClient().uploadFile(
  //       mainUploadUrl,
  //       data: fileModel.formData,
  //       fileType: fileType,
  //       cancelToken: cancelToken,
  //       onSendProgress: (count, total) {
  //         progressController.sink.add(
  //           MediaProgressData(contentId: contentId, total: total, count: count),
  //         );
  //       },
  //       extension: getFileExtension(fileModel.fileName),
  //     );
  //
  //     Future thumbnailUploadFuture =
  //         (fileModel.thumbnailData != null && thumbnailUploadUrl != null)
  //             ? (RestClient().uploadFile(
  //                 thumbnailUploadUrl,
  //                 data: fileModel.thumbnailData!,
  //                 fileType: FileType.image,
  //                 extension: thumbnailFileExtension,
  //               ))
  //             : Future(() => null);
  //     List<String> urls = [];
  //     await Future.wait([mainUploadFuture, thumbnailUploadFuture])
  //         .then((value) {
  //       urls = [mainUploadUrl];
  //       if (thumbnailUploadUrl != null) {
  //         urls.add(thumbnailUploadUrl);
  //       }
  //     });
  //     return right(urls.map((upUrl) => convertToDownloadUrl(upUrl)).toList());
  //   } catch (e) {
  //     if (e is CancelRequestException) {
  //       return left(
  //         ServerFailure(message: e.error ?? "", exception: e),
  //       );
  //     }
  //     return left(null);
  //   }
  // }
  //
  // static cachingFile(
  //     String key, Uint8List data, FileType fileType, String extension) async {
  //   if (fileType == FileType.file || fileType == FileType.audio) {
  //     final directory = await getTemporaryDirectory();
  //     final file = await File("${directory.path}/$key.$extension").create();
  //     file.writeAsBytesSync(data);
  //     return;
  //   }
  //   await cacheFile(key, data);
  // }
  //
  // static Future<FileModel?> getFileModel(String contentId) async {
  //   LocalPathModel? pathModel =
  //       await getIt.call<LocalStorageRepository>().getLocalPath(contentId);
  //   if (pathModel == null || pathModel.paths.isEmpty) {
  //     return null;
  //   }
  //   Uint8List formData = await FileHelper.readFile(pathModel.paths.first);
  //   Uint8List? thumbnailData = pathModel.paths.length > 1
  //       ? await FileHelper.readFile(pathModel.paths[1])
  //       : null;
  //   String fileName = FileHelper.getFileName(pathModel.paths.first);
  //   return FileModel(
  //     formData: formData,
  //     fileName: fileName,
  //     thumbnailData: thumbnailData,
  //     filePath: pathModel.paths.first,
  //     thumbnailPath: pathModel.paths.elementAtOrNull(1),
  //     filePosition: FilePosition.message,
  //     cancelToken: CancelToken(),
  //   );
  // }
  //
  // Future<void> cancelUploadingContent(ContentModel contentModel) async {
  //   MediaUploadManager().cancelUploading(contentModel.contentId);
  //   getIt
  //       .call<CurrentChannelContentProvider>()
  //       .deleteUnsentMessage(contentModel);
  // }
  //
  // Future<bool> downloadMedia(
  //   String url,
  //   String contentId,
  //   FileType fileType,
  //   String extension, {
  //   CancelToken? cancelToken,
  //   Function(int count, int total)? onReceiveProgress,
  // }) async {
  //   try {
  //     final appDirectory = await getTemporaryDirectory();
  //     await RestClient().download(
  //       url: url,
  //       savePath: '${appDirectory.path}/$contentId.$extension',
  //       cancelToken: cancelToken,
  //       onReceiveProgress: (count, total) {
  //         progressController.sink.add(
  //           MediaProgressData(contentId: contentId, total: total, count: count),
  //         );
  //       },
  //     );
  //     await cachingFile(
  //       contentId,
  //       await File('${appDirectory.path}/$contentId.$extension').readAsBytes(),
  //       fileType,
  //       extension,
  //     );
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }
  //
  // sendMedia(String channelId, FileModel fileModel, {String? caption}) async {
  //   ContentModel pendingContent =
  //       await getIt.call<CurrentChannelContentProvider>().storePendingContent(
  //             channelId,
  //             makeContentPayloadModel(fileModel, caption: caption),
  //             contentFile: fileModel.formData,
  //           );
  //
  //   await MediaUploadManager().startUploadAndSend(pendingContent, fileModel);
  // }
  //
  // ContentPayloadModel makeContentPayloadModel(FileModel fileModel,
  //     {String? caption});
  //
  // Future<List<String>?> uploadPendingFile(
  //     ContentModel pendingContent, FileModel fileModel);
  //
  // onUploadCompleted(ContentModel pendingContent, List<String> downloadUrls);
}
