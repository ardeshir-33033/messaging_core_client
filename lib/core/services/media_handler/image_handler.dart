import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/services/media_handler/media_handler.dart';
import 'package:messaging_core/core/utils/file_helper.dart';
import 'package:messaging_core/core/utils/utils.dart';

class ImageHandler extends MediaHandler {
  static final ImageHandler _instance = ImageHandler._internal();

  factory ImageHandler() {
    return _instance;
  }

  ImageHandler._internal() {
    // MediaUploadManager().registerMediaHandler(ContentTypeEnum.image, this);
  }

  // Future<List<String>?> uploadGroupImage(FileModel fileModel) async {
  //   return _uploadMediaGeneral(fileModel, RestClient().getUploadUrl)
  //       .then((downloadUrls) {
  //     return downloadUrls;
  //   });
  // }

  // Future<List<String>?> uploadImage() async {
  //   FileModel? fileModel = await selectImageFile(FilePosition.profile);
  //
  //   if (fileModel == null) return null;
  //   return _uploadMediaGeneral(fileModel, RestClient().getUploadUrl)
  //       .then((downloadUrls) {
  //     return downloadUrls;
  //   });
  // }

  // Future<List<String>?> uploadUserImage({
  //   required ImageSource imageSource,
  //   Function(FileModel)? onSelectImage,
  // }) async {
  //   FileModel? fileModel =
  //       await selectImageFile(FilePosition.profile, source: imageSource);
  //
  //   if (fileModel == null) return null;
  //   onSelectImage?.call(fileModel);
  //   return _uploadMediaGeneral(
  //     fileModel,
  //     RestClient().getUploadUrl,
  //   ).then((downloadUrls) {
  //     return downloadUrls;
  //   });
  // }

  // Future<List<String>?> _uploadMediaGeneral(FileModel? fileModel,
  //     Future<List<String>> Function(List<String>) getUploadUrlFunc,
  //     {String? cacheKey, bool? withThumbnail}) async {
  //   if (fileModel == null) return null;
  //   var fileExtensions = [getFileExtension(fileModel.fileName)];
  //   if (withThumbnail == true) {
  //     fileExtensions.add(thumbnailFileExtension);
  //   }
  //   List<String> uploadLinks = await getUploadUrlFunc(fileExtensions);
  //
  //   String mainUploadUrl = uploadLinks.first;
  //   String? thumbnailUploadUrl = uploadLinks.elementAtOrNull(1);
  //
  //   cacheFile(
  //       cacheKey ?? convertToDownloadUrl(mainUploadUrl), fileModel.formData);
  //
  //   Future mainUploadFuture = RestClient().uploadFile(
  //     mainUploadUrl,
  //     data: fileModel.formData,
  //     fileType: FileType.image,
  //   );
  //
  //   Future thumbnailUploadFuture =
  //       (fileModel.thumbnailData != null && thumbnailUploadUrl != null)
  //           ? (RestClient().uploadFile(
  //               thumbnailUploadUrl,
  //               data: fileModel.thumbnailData!,
  //               fileType: FileType.image,
  //             ))
  //           : Future(() => null);
  //
  //   return Future.wait([mainUploadFuture, thumbnailUploadFuture]).then((value) {
  //     var urls = [mainUploadUrl];
  //     if (thumbnailUploadUrl != null) {
  //       urls.add(thumbnailUploadUrl);
  //     }
  //     return urls.map((upUrl) => convertToDownloadUrl(upUrl)).toList();
  //   });
  // }

  selectAndSendImage(String channelId, {ImageSource? source}) async {
    // FileModel? fileModel =
    await selectImageFile(source: source);

    // if (fileModel == null) return;
    //
    // return sendMedia(channelId, fileModel);
  }

  Future<FileModel?> selectImageFile(
      // FilePosition filePosition,
      {
    ImageSource? source,
    bool? allowCrop = true,
  }) async {
    File? image;
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: source ?? ImageSource.gallery);

    String? mainFilePath = pickedFile?.path;
    if (pickedFile != null) {
      if (allowCrop == true) {
        final fileExtension = getFileExtension(pickedFile.path);
        if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
          final compressFormat = fileExtension == 'png'
              ? ImageCompressFormat.png
              : ImageCompressFormat.jpg;
          final imageCropper = ImageCropper();
          final croppedFile = await imageCropper.cropImage(
              sourcePath: pickedFile.path,
              // aspectRatio: filePosition == FilePosition.profile
              //     ? const CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
              //     : null,
              compressQuality: 100,
              compressFormat: compressFormat);
          mainFilePath = croppedFile?.path;
        }
      }

      if (mainFilePath != null) {
        image = File(mainFilePath);
        String fileName = FileHelper.getFileName(image.path);

        Image originalImage = (await decodeImageFile(mainFilePath))!;
        Image resizedImage = copyResize(originalImage, width: 64);
        Uint8List thumbnail = encodePng(resizedImage);
        String thumbnailPath = await FileHelper.writeFileToDoc(
            '/.thumbnails/${fileName}', thumbnail.toList());

        return FileModel(
          formData: File(image.path).readAsBytesSync(),
          fileName: fileName,
          thumbnailData: thumbnail,
          // filePosition: filePosition,
          filePath: image.path,
          width: originalImage.width,
          height: originalImage.height,
          thumbnailPath: thumbnailPath,
        );
      }
    }

    return null;
  }

  Future<FileModel> cropImage(FileModel file, FilePosition filePosition) async {
    final fileExtension = getFileExtension(file.filePath);

    if (['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      final compressFormat = fileExtension == 'png'
          ? ImageCompressFormat.png
          : ImageCompressFormat.jpg;
      final imageCropper = ImageCropper();
      final croppedFile = await imageCropper.cropImage(
          sourcePath: file.filePath!,
          aspectRatio: filePosition == FilePosition.profile
              ? const CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
              : null,
          compressQuality: 100,
          compressFormat: compressFormat);
      final mainFilePath = croppedFile?.path;

      if (croppedFile != null) {
        File image = File(mainFilePath!);
        String fileName = FileHelper.getFileName(image.path);

        Image originalImage = (await decodeImageFile(mainFilePath))!;
        Image resizedImage = copyResize(originalImage, width: 64);
        Uint8List thumbnail = encodePng(resizedImage);
        String thumbnailPath = await FileHelper.writeFileToDoc(
            '/.thumbnails/${fileName}', thumbnail.toList());

        return FileModel(
          formData: File(mainFilePath).readAsBytesSync(),
          fileName: fileName,
          thumbnailData: thumbnail,
          // filePosition: filePosition,
          filePath: image.path,
          width: originalImage.width,
          height: originalImage.height,
          thumbnailPath: thumbnailPath,
        );
      } else {
        return file;
      }
    } else {
      return file;
    }
  }

  Future<FileModel?> takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      String fileName = pickedFile.path.split('/').last;

      Image originalImage = (await decodeImageFile(pickedFile.path))!;
      Image resizedImage = copyResize(originalImage, width: 64);
      Uint8List thumbnail = encodePng(resizedImage);
      String thumbnailPath = await FileHelper.writeFileToDoc(
          '/.thumbnails/${fileName}', thumbnail.toList());

      return FileModel(
        formData: File(pickedFile.path).readAsBytesSync(),
        fileName: fileName,
        thumbnailData: thumbnail,
        // filePosition: FilePosition.profile,
        filePath: pickedFile.path,
        width: originalImage.width,
        height: originalImage.height,
        thumbnailPath: thumbnailPath,
      );
    }
    return null;
  }

  @override
  void initState() {}

  @override
  void resetState() {}

  // @override
  // Future<List<String>?> uploadPendingFile(
  //     ContentModel pendingContent, FileModel fileModel) async {
  //   try {
  //     final response = await uploadMedia(
  //       FileType.image,
  //       HttpHeaderType.image,
  //       fileModel,
  //       pendingContent.contentId,
  //       cacheKey: getImageCacheKey(pendingContent.contentId),
  //       cancelToken: fileModel.fileCancelToken,
  //     );
  //     return response.fold(
  //       (fail) {
  //         return null;
  //       },
  //       (downloadUrls) {
  //         return downloadUrls;
  //       },
  //     );
  //   } catch (e) {
  //     Log().d(e);
  //   }
  //   return null;
  // }
  //
  // @override
  // onUploadCompleted(ContentModel pendingContent, List<String> downloadUrls) {
  //   ImageContentPayloadModel model =
  //       pendingContent.contentPayload as ImageContentPayloadModel;
  //   model.url = downloadUrls.first;
  //   model.thumbnailUrl = downloadUrls.elementAtOrNull(1);
  // }

  // @override
  // ContentPayloadModel makeContentPayloadModel(FileModel fileModel,
  //     {String? caption}) {
  //   return ImageContentPayloadModel(
  //     url: fileModel.filePath ?? "",
  //     width: fileModel.width ?? 0,
  //     height: fileModel.height ?? 0,
  //     caption: caption,
  //   );
  // }
}
