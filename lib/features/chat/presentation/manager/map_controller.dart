import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/features/chat/domain/entities/contact_payload_model.dart';
import 'package:messaging_core/features/chat/domain/entities/location_payload_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/locator.dart';

class MapController extends GetxController {
  sendMapLocation(LatLng selectedLocation) {
    final ChatController controller = locator<ChatController>();

    LocationPayloadModel model = LocationPayloadModel(
        lat: selectedLocation.latitude, lng: selectedLocation.longitude);

    OtherJsonModel jsonModel = OtherJsonModel(
        data: model.toJson(), contentType: ContentTypeEnum.location);

    controller.attachLocation(
        text: jsonEncode(jsonModel.toJson()),
        content: model,
        contentType: ContentTypeEnum.other,
        receiverId: controller.currentChat!.id!);
  }
}
