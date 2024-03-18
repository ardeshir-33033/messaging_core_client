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
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/call/call_page.dart';
import 'package:messaging_core/locator.dart';
import 'package:messaging_core/main.dart';

class CallController extends GetxController {
  MessagingClient messagingClient;
  ChatDataSource chatDataSource;

  CallController(this.messagingClient, this.chatDataSource);
  CallStatus callStatus = CallStatus.noCall;


  setCallStatus(CallStatus status){
    callStatus = status;
    update(["status"]);
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
