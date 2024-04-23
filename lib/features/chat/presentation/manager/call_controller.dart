import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/component/dialog_box.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/services/network/websocket/messaging_client.dart';
import 'package:messaging_core/features/chat/data/data_sources/chat_data_source.dart';
import 'package:messaging_core/features/chat/data/models/call_content_payload_model.dart';
import 'package:messaging_core/features/chat/data/models/call_model.dart';
import 'package:messaging_core/features/chat/domain/entities/category_users.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/call/call_page.dart';
import 'package:messaging_core/locator.dart';
import 'package:messaging_core/main.dart';

class CallController extends GetxController {
  MessagingClient messagingClient;
  ChatDataSource chatDataSource;

  CallController(this.messagingClient, this.chatDataSource);
  CallStatus callStatus = CallStatus.noCall;
  CallMode callMode = CallMode.video;
  CallType callType = CallType.single;

  bool myVideoClosed = false;
  bool myVoiceClosed = false;
  bool opponentVideoClosed = false;

  List<CategoryUser> participants = [];
  List<CategoryUser> addedParticipants = [];
  bool addParticipant = false;

  setCallStatus(CallStatus status) {
    callStatus = status;
    if (status == CallStatus.inCall) {
      fillParticipants();
    }
    if (status == CallStatus.noCall) {
      participants = [];
    }
    update(["status", "app_bar"]);
  }

  setOpponentVideo() {
    opponentVideoClosed = !opponentVideoClosed;
    update(["status"]);
  }

  setCallMode(CallMode mode) {
    if (mode == CallMode.voice) {
      myVideoClosed = true;
      opponentVideoClosed = true;
    } else {
      myVideoClosed = false;
      opponentVideoClosed = false;
    }
    callMode = mode;
    update(["status"]);
  }

  toggleCallMode() {
    if (callMode == CallMode.voice) {
      callMode = CallMode.video;
      myVideoClosed = false;
    } else {
      callMode = CallMode.voice;
      myVideoClosed = true;
    }
    update(["status"]);
  }

  toggleVoice() {
    myVoiceClosed = !myVoiceClosed;
    update(["status"]);
  }

  fillParticipants() {
    participants = [];
    ChatController chatController = locator<ChatController>();
    if (chatController.currentChat!.isGroup()) {
      chatController.currentChat!.groupUsers?.forEach((element) {
        CategoryUser? categoryUser = chatController.users
            .firstWhereOrNull((user) => element.id == user.id);
        if (categoryUser != null) {
          participants.add(categoryUser);
        }
      });
    } else {
      participants.add(chatController.currentChat! as CategoryUser);
    }
  }

  addNewParticipants(List<CategoryUser> users) {
    final ChatController chatController = locator<ChatController>();

    addedParticipants = [];
    addedParticipants.add(chatController.currentChat as CategoryUser);
    addedParticipants.addAll(users);
    update(["participants"]);
  }

  removeAllParticipants() {
    addedParticipants = [];
    update(["participants"]);
  }
}

enum CallStatus {
  noCall,
  inCall,
  IN_CALL,
  RINGING,
  WAITING,
  REJECTED,
}

enum CallType {
  group,
  single,
}

enum CallMode {
  video,
  voice,
}
