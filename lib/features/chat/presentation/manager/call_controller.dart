import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:agora_uikit/agora_uikit.dart';
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

  static const String INVITE_COMMAND = 'invite';
  static const String LEAVE_COMMAND = 'leave';
  static const String ACCEPT_COMMAND = 'accept';
  static const String REJECT_COMMAND = 'reject';

  static const appId = '427d6ee8ca4f44c1b84df6041a5e95cb';

  String? callName;
  String? token;
  String? callerName;
  String? calleeName;
  int? calleeId;
  int? callerId;
  int? initiatorId;
  int? receiverId;
  bool? enableVideo;
  AgoraClient? client;
  CallStatus status = CallStatus.NO_CALL;
  String? opponentCallRejectionReason;
  // ContactProfile? profile;
  String? opponentId;

  Timer? rejectedTimer;
  Timer? waitingTimer;
  Timer? waitingTokenTimer;

  bool? starter = false;
  DateTime? startTime;
  bool? started = false;
  bool? missedCall = false;

  bool speakerBeforeCall = false;

  reset() {
    callName = null;
    initiatorId = null;
    receiverId = null;
    callerName = null;
    calleeName = null;
    token = null;
    calleeId = null;
    opponentCallRejectionReason = null;
    starter = null;
    started = null;
    startTime = null;
    // profile = null;
    opponentId = null;
    client?.release();
    client = null;
    enableVideo = false;
    speakerBeforeCall = false;
    if (rejectedTimer != null) rejectedTimer!.cancel();
    if (waitingTimer != null) waitingTimer!.cancel();
    if (waitingTokenTimer != null) waitingTokenTimer!.cancel();

    status = CallStatus.NO_CALL;
  }

  void receiveCallSignal(String signal) async {
    CallModel callModel = CallModel.fromJson(jsonDecode(signal));
    Fluttertoast.showToast(msg: callModel.token ?? "",toastLength: Toast.LENGTH_LONG);

    if (callModel.callCommand == null) return;

    switch (callModel.callCommand) {
      case INVITE_COMMAND:
        if (callModel.callName == null ||
            callModel.initiatorId == null ||
            callModel.enableVideo == null ||
            callModel.token == null ||
            callModel.calleeId == null) return;

        incomingCall(callModel);

        break;
      case LEAVE_COMMAND:
        if (callModel.callName == null) return;
        incomingLeave(callModel);
        break;
      case ACCEPT_COMMAND:
        if (callModel.callName == null) return;

        incomingAcceptCall(callModel);
        break;
      case REJECT_COMMAND:
        if (callModel.callName == null || callModel.initiatorId == null) return;
        incomingRejectCall(callModel);
        break;
      default:
        return;
    }
  }

  void incomingCall(CallModel callModel) async {
    if (status != CallStatus.NO_CALL && callModel.initiatorId != initiatorId) {
      rejectCall('busy', callModel, false);
    } else if (status != CallStatus.NO_CALL &&
        callModel.initiatorId == initiatorId) {
      return;
    } else {
      status = CallStatus.RINGING; // fixme change to ringing

      enableVideo = callModel.enableVideo;
      callName = callModel.callName;
      initiatorId = callModel.initiatorId;
      receiverId = callModel.receiverId;
      token = callModel.token;
      calleeId = callModel.calleeId;
      callerName = callModel.callerName;
      calleeName = callModel.calleeName;
      // _getOpponentUserId().then((id) {
      //   if (id == null) return;
      //   opponentId = id;
      //   notifyListeners();
      //   userUsecase.getUserById(id).then((profile) {
      //     this.profile = profile;
      //     notifyListeners();
      //   });
      // });

      if (MyApp.navigatorKey.currentContext != null) {
        Navigator.push(MyApp.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const CallPage()));
      }
    }
  }

  void incomingLeave(CallModel callModel) {
    if (status != CallStatus.NO_CALL) {
      if (callModel.callName == callName) {
        Navigator.pop(MyApp.navigatorKey.currentContext!);

        disconnect(false);
      }
    }
  }

  Future<void> requestCall(
      int opponentId, int myId, String calleeName, bool enableVideo) async {
    if (status != CallStatus.NO_CALL) return; //fixme

    bool permission = await callPermissions(enableVideo);
    if (!permission) {
      showPermissionMessage();
      return;
    }

    var rng = Random();
    callName = rng.nextInt(100000).toString();
    callerId = rng.nextInt(100);
    calleeId = rng.nextInt(100);
    this.calleeName = calleeName;
    callerName = AppGlobalData.userName;

    String? currentCallName = callName;

    status = CallStatus.WAITING_TOKEN;

    Navigator.push(MyApp.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => const CallPage()));
    waitingTokenTimer = Timer(const Duration(seconds: 30), () {
      if (currentCallName != callName) {
        return; // check we are  in same call with 15 seconds ago
      }
      if (status != CallStatus.WAITING_TOKEN) return;
      missedCall = true;
      Navigator.pop(MyApp.navigatorKey.currentContext!);
      disconnect(true);
    });

    initiatorId = myId;
    receiverId = opponentId;
    this.enableVideo = enableVideo;

    // _getOpponentUserId().then((id) {
    //   if (id == null) return;
    //   opponentId = id;
    //   notifyListeners();
    //   userUsecase.getUserById(id).then((profile) {
    //     this.profile = profile;
    //     notifyListeners();
    //   });
    // });

    chatDataSource
        .generateAgoraToken(locator<ChatController>().getRoomId()!)
        .then((value) {
      if (currentCallName != callName) {
        return; // check we are  in same call with 15 seconds ago
      }
      if (status != CallStatus.WAITING_TOKEN && status != CallStatus.WAITING) {
        return;
      }
      String calleeToken = value;
      CallModel payload = CallModel(
          callCommand: INVITE_COMMAND,
          callName: callName,
          calleeId: calleeId,
          calleeName: callerName,
          callerName: callerName,
          token: calleeToken,
          receiverId: receiverId,
          initiatorId: initiatorId,
          enableVideo: this.enableVideo);
      messagingClient.sendSignal([receiverId!], payload);
    });

    chatDataSource
        .generateAgoraToken(locator<ChatController>().getRoomId()!)
        .then((value) {
      if (currentCallName != callName) {
        return; // check we are  in same call with 15 secods ago
      }
      if (status != CallStatus.WAITING_TOKEN) return;

      String callerToken = value;
      token = callerToken;
      starter = true;

      status = CallStatus.WAITING;
      waitingTimer = Timer(const Duration(seconds: 25), () {
        if (status != CallStatus.WAITING) return;
        missedCall = true;
        Navigator.pop(MyApp.navigatorKey.currentContext!);
        disconnect(true);
      });
      update();
    });
  }

  void incomingAcceptCall(CallModel callModel) async {
    if (status != CallStatus.WAITING) return;
    if (callName != callModel.callName) return;
    startTime = DateTime.now();
    started = true;

    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: appId,
        channelName: callName!,
        tempToken: token,
        uid: callerId,
      ),
    );
    await _initAgora();
    status = CallStatus.IN_CALL;
    update();
  }

  incomingRejectCall(CallModel callModel) {
    if (status == CallStatus.WAITING && callModel.callName == callName) {
      status = CallStatus.REJECTED;
      opponentCallRejectionReason = callModel.reason;
      update();
      if (rejectedTimer != null) rejectedTimer!.cancel();
      rejectedTimer = Timer(const Duration(seconds: 3), () {
        Navigator.pop(MyApp.navigatorKey.currentContext!);
        disconnect(false);
      });
    }
  }

  void rejectCall(String reason, CallModel? busyCallModel, bool popPage) {
    CallModel payload = CallModel(
        callCommand: REJECT_COMMAND,
        reason: reason, //fixme
        callName: busyCallModel == null ? callName : busyCallModel.callName,
        initiatorId:
            busyCallModel == null ? initiatorId : busyCallModel.initiatorId);
    messagingClient.sendSignal([initiatorId!], payload);
    if (popPage) {
      status = CallStatus.NO_CALL;
      Navigator.pop(MyApp.navigatorKey.currentContext!);
    }
    if (busyCallModel == null) disconnect(false);
  }

  void acceptCall() async {
    if (status == CallStatus.RINGING) {
      bool permission = await callPermissions(enableVideo!);
      if (permission == false) {
        rejectCall("Rejected", null, true);
        DialogBoxes(
            title: "Permission Denied",
            des:
                "To continue using this feature you have to give access to the application",
            mainTask: () {
              Navigator.pop(MyApp.navigatorKey.currentContext!);
            }).showMyDialog();
        //
        return;
      }
      CallModel payload = CallModel(
        callCommand: ACCEPT_COMMAND,
        callName: callName,
      );
      await messagingClient.sendSignal([initiatorId!], payload);
      client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: appId,
          channelName: callName!,
          tempToken: token,
          uid: calleeId,
        ),
      );
      await _initAgora();
      status = CallStatus.IN_CALL;
      update();
    }
  }

  disconnect(bool notifyOponent) async {
    CallStatusEnum callStatus = CallStatusEnum.accepted;
    if (notifyOponent) {
      CallModel payload = CallModel(
        callCommand: LEAVE_COMMAND,
        callName: callName,
        initiatorId: 999,
      );

      messagingClient.sendSignal([initiatorId!, receiverId!], payload);
    }

    if (starter != null && initiatorId != null && starter!) {
      if (missedCall != null && missedCall!) {
        callStatus = CallStatusEnum.missed;
        // currentChannelContentProvider.sendContent(
        //   channelId!,
        //   CallContentPayloadModel(
        //     callStatus: CallStatusEnum.missed,
        //     startTime: startTime ?? DateTime.now(),
        //     callType:
        //         enableVideo == true ? CallTypeEnum.video : CallTypeEnum.voice,
        //     callerUserId: userId ?? "",
        //   ),
        // );
      } else {
        if (started != null && started!) {
          callStatus = CallStatusEnum.accepted;
          // currentChannelContentProvider.sendContent(
          //   channelId!,
          //   CallContentPayloadModel(
          //     callStatus: CallStatusEnum.accepted,
          //     startTime: startTime ?? DateTime.now(),
          //     callType:
          //         enableVideo == true ? CallTypeEnum.video : CallTypeEnum.voice,
          //     callerUserId: userId ?? "",
          //     durationInSeconds:
          //         DateTime.now().difference(startTime!).inSeconds,
          //   ),
          // );
        } else {
          if (opponentCallRejectionReason == null) {
            callStatus = CallStatusEnum.missed;
            // currentChannelContentProvider.sendContent(
            //   channelId!,
            //   CallContentPayloadModel(
            //     callStatus: CallStatusEnum.missed,
            //     startTime: startTime ?? DateTime.now(),
            //     callType: enableVideo == true
            //         ? CallTypeEnum.video
            //         : CallTypeEnum.voice,
            //     callerUserId: userId ?? "",
            //   ),
            // );
          } else {
            callStatus = opponentCallRejectionReason == "busy"
                ? CallStatusEnum.busy
                : CallStatusEnum.rejected;
          }
        }
      }
      // String? opponentUserId = getIt
      //     .call<CurrentChannelProvider>()
      //     .getMembers()
      //     .firstWhereOrNull((element) => element.userId != userId)
      //     ?.userId;
      // if (opponentUserId != null) {
      //   callUsecase.createInAppCallLog(
      //     fromUserId: userId ?? "",
      //     toUserId: opponentUserId,
      //     status: callStatus,
      //     type: enableVideo == true ? CallTypeEnum.video : CallTypeEnum.voice,
      //     duration: (started != null && started!)
      //         ? DateTime.now().difference(startTime!).inSeconds
      //         : 0,
      //   );
      // }
    }

    reset();
    update();
  }

  Future<void> _initAgora() async {
    if (client != null) {
      await client!.initialize();
      await client!.sessionController.value.engine
          ?.enableLocalVideo(enableVideo ?? false);
    }
  }

  Future<bool> callPermissions(bool enableVideo) async {
    PermissionStatus cameraStatus = await Permission.camera.status;
    PermissionStatus microphoneStatus = await Permission.microphone.status;
    if (enableVideo) {
      if (!cameraStatus.isGranted || !microphoneStatus.isGranted) {
        if (!(await Permission.camera.request().isGranted)) {
          return false;
        }
        if (!(await Permission.microphone.request().isGranted)) {
          return false;
        }
      }
    } else {
      if (!microphoneStatus.isGranted) {
        if (!(await Permission.microphone.request().isGranted)) {
          return false;
        }
      }
    }
    return true;
  }

  bool isOpponentVideoDisabled() {
    if (client!.sessionController.value.users.isNotEmpty) {
      return client!.sessionController.value.users[0].videoDisabled;
    } else {
      return false;
    }
  }

  void toggleVideoCam() {
    if (status != CallStatus.IN_CALL) return;
    enableVideo = !(enableVideo!);
    update();

    client!.sessionController.value.engine?.enableLocalVideo(enableVideo!);
  }

  showPermissionMessage() {
    DialogBoxes(
        title: "Permission Denied",
        des:
            "To continue using this feature you have to give access to the application",
        mainTask: () {
          Navigator.pop(MyApp.navigatorKey.currentContext!);
        }).showMyDialog();
  }
}

enum CallStatus {
  NO_CALL,
  WAITING_TOKEN,
  IN_CALL,
  RINGING,
  WAITING,
  REJECTED,
}
