import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/services/media_handler/media_handler.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_payload_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/locator.dart';

import '../../utils/file_helper.dart';

class FileHandler extends MediaHandler {
  static final FileHandler _instance = FileHandler._internal();

  factory FileHandler() {
    return _instance;
  }

  FileHandler._internal() {
    // MediaUploadManager().registerMediaHandler(ContentTypeEnum.file, this);
  }

  @override
  void initState() {}

  Future<void> selectAndSendFile(ChatParentClass chat) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    FileModel fileModel = FileModel(
      formData: File(result.files.single.path!).readAsBytesSync(),
      fileName: result.files.single.name,
      filePath: result.files.single.path,
      cancelToken: CancelToken(),
      sizeInKB: FileHelper.fileSizeInKB(result.files.single.size),
    );
    final ChatController controller = locator<ChatController>();
    controller.sendTextMessage(
      chat.getReceiverType(),
      result.files.single.name,
      chat.id!,
      ContentTypeEnum.file,
      fileModel,
    );

    // await sendMedia(channelId, fileModel);
  }

  Future<void> selectMusicAndSendFile(ChatParentClass chat) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null) return;

    FileModel fileModel = FileModel(
      formData: File(result.files.single.path!).readAsBytesSync(),
      fileName: result.files.single.name,
      filePath: result.files.single.path,
      cancelToken: CancelToken(),
      sizeInKB: FileHelper.fileSizeInKB(result.files.single.size),
    );

    final ChatController controller = locator<ChatController>();
    controller.sendTextMessage(
      chat.getReceiverType(),
      result.files.single.name,
      chat.id!,
      ContentTypeEnum.file,
      fileModel,
    );
    // FileModel fileModel = FileModel(
    //   formData: File(result.files.single.path!).readAsBytesSync(),
    //   fileName: result.files.single.name,
    //   filePosition: FilePosition.message,
    //   filePath: result.files.single.path,
    //   cancelToken: CancelToken(),
    //   sizeInKB: FileHelper.fileSizeInKB(result.files.single.size),
    // );
    // await sendMedia(channelId, fileModel);
  }

  Future<void> selectDocumentAndSendFile(ChatParentClass chat) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);
    if (result == null) return;

    FileModel fileModel = FileModel(
      formData: File(result.files.single.path!).readAsBytesSync(),
      fileName: result.files.single.name,
      filePath: result.files.single.path,
      cancelToken: CancelToken(),
      sizeInKB: FileHelper.fileSizeInKB(result.files.single.size),
    );

    final ChatController controller = locator<ChatController>();
    controller.sendTextMessage(
      chat.getReceiverType(),
      result.files.single.name,
      chat.id!,
      ContentTypeEnum.file,
      fileModel,
    );

    // FileModel fileModel = FileModel(
    //   formData: File(result.files.single.path!).readAsBytesSync(),
    //   fileName: result.files.single.name,
    //   filePosition: FilePosition.message,
    //   filePath: result.files.single.path,
    //   cancelToken: CancelToken(),
    //   sizeInKB: FileHelper.fileSizeInKB(result.files.single.size),
    // );
    // await sendMedia(channelId, fileModel);
  }

  @override
  makeContentPayloadModel(fileModel, {String? caption}) {
    // TODO: implement makeContentPayloadModel
    throw UnimplementedError();
  }

  @override
  onUploadCompleted(ContentModel pendingContent, List<String> downloadUrls) {
    // TODO: implement onUploadCompleted
    throw UnimplementedError();
  }

  @override
  Future<List<String>?> uploadPendingFile(
      ContentModel pendingContent, fileModel) {
    // TODO: implement uploadPendingFile
    throw UnimplementedError();
  }

  // Future<void> sendFile(String channelId, FileModel fileModel) async{
  //   FileContentPayloadModel fileContentPayloadModel = FileContentPayloadModel(
  //     url: '',
  //     name: fileModel.fileName ?? "",
  //     extension: getFileExtension(fileModel.filePath!),
  //     sizeInKB: fileModel.sizeInKB ?? 0,
  //   );
  //   ContentModel pendingContent =
  //   await getIt.call<CurrentChannelContentProvider>().storePendingContent(
  //     channelId,
  //     fileContentPayloadModel,
  //     contentFile: fileModel.formData,
  //   );
  //   await MediaUploadManager().startUploadAndSend(pendingContent, fileModel);
}

@override
onUploadCompleted(ContentModel pendingContent, List<String> downloadUrls) {
  // pendingContent.contentPayload =
  //     (pendingContent.contentPayload as FileContentPayloadModel).copyWith(
  //   url: downloadUrls.first,
  // );
}

@override
void resetState() {}

// @override
// Future<List<String>?> uploadPendingFile(
//     ContentModel pendingContent, FileModel fileModel) async {
//   // final response = await uploadMedia(
//   //   fileType.FileType.file,
//   //   HttpHeaderType.multipart,
//   //   fileModel,
//   //   pendingContent.contentId,
//   //   cacheKey: pendingContent.contentId,
//   //   cancelToken: fileModel.fileCancelToken,
//   // );
//   // return response.fold(
//   //       (fail) {
//   //     //todo handle
//   //     return null;
//   //   },
//   //       (downloadUrls) {
//   //     return downloadUrls;
//   //   },
//   // );
// }

// @override
// ContentPayloadModel makeContentPayloadModel(FileModel fileModel, {String? caption}) {
//   // return FileContentPayloadModel(
//   //   url: '',
//   //   name: fileModel.fileName ?? "",
//   //   extension: getFileExtension(fileModel.filePath!),
//   //   sizeInKB: fileModel.sizeInKB ?? 0,
//   // );
// }
// }
