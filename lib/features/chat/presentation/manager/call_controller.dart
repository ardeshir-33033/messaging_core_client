import 'dart:async';
import 'dart:convert';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messaging_core/app/component/dialog_box.dart';
import 'package:messaging_core/core/services/network/websocket/messaging_client.dart';
import 'package:messaging_core/features/chat/data/models/call_content_payload_model.dart';
import 'package:messaging_core/features/chat/data/models/call_model.dart';
import 'package:messaging_core/features/chat/presentation/pages/call/call_page.dart';
import 'package:messaging_core/main.dart';

class CallController extends GetxController {
  MessagingClient messagingClient;

  CallController(this.messagingClient);

  static const String INVITE_COMMAND = 'invite';
  static const String LEAVE_COMMAND = 'leave';
  static const String ACCEPT_COMMAND = 'accept';
  static const String REJECT_COMMAND = 'reject';

  static const appId = '427d6ee8ca4f44c1b84df6041a5e95cb';

  String? callName;
  String? token;
  int? calleeId;
  int? callerId;
  String? channelId;
  bool? enableVideo;
  AgoraClient? client;
  late CallStatus status;
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
    channelId = null;
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
    if (callModel.callCommand == null) return;

    switch (callModel.callCommand) {
      case INVITE_COMMAND:
        if (callModel.callName == null ||
            callModel.channelId == null ||
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
        if (callModel.callName == null || callModel.channelId == null) return;
        incomingRejectCall(callModel);
        break;
      default:
        return;
    }
  }

  void incomingCall(CallModel callModel) async {
    if (status != CallStatus.NO_CALL && callModel.channelId != channelId) {
      rejectCall('busy', callModel, false);
    } else if (status != CallStatus.NO_CALL &&
        callModel.channelId == channelId) {
      return;
    } else {
      status = CallStatus.RINGING; // fixme change to ringing

      enableVideo = callModel.enableVideo;
      callName = callModel.callName;
      channelId = callModel.channelId;
      token = callModel.token;
      calleeId = callModel.calleeId;
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
        channelId: busyCallModel == null ? channelId : busyCallModel.channelId);
    messagingClient.sendSignal([177], payload);
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
      await messagingClient.sendSignal([177], payload);
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
        channelId: '_',
      );

      messagingClient.sendSignal([177], payload);
    }

    if (starter != null && channelId != null && starter!) {
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
}

enum CallStatus {
  NO_CALL,
  WAITING_TOKEN,
  IN_CALL,
  RINGING,
  WAITING,
  REJECTED,
}
