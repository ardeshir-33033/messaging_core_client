import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordVoiceController extends GetxController {
  static const String voiceRecordingFormat = "m4a";
  final int minimumRecordingDurationMilliSeconds = 1000;
  RecordStateEnum recordingState = RecordStateEnum.stop;
  String? recordingVoiceId;
  int? recordedFileDuration;
  late ValueNotifier<int> milliSeconds;
  String? recordedFilePath;
  Record record = Record();

  final player = AudioPlayer();

  initialRecording() {
    milliSeconds = ValueNotifier(0);
    recordingState = RecordStateEnum.stop;
    // audioStateNotifier = ValueNotifier(AudioState.paused);
    // listenToPlayerState();
    record = Record();
    record.onStateChanged().listen(
      (state) {
        if (state == RecordState.record &&
            recordingState != RecordStateEnum.pause) {
          print("------- Record State Listener");
          milliSeconds.value = 0;
          Timer.periodic(
            const Duration(milliseconds: 100),
            (timer) {
              switch (recordingState) {
                case RecordStateEnum.record:
                  milliSeconds.value += 100;
                  break;
                case RecordStateEnum.lockRecord:
                  milliSeconds.value += 100;
                  break;
                case RecordStateEnum.stop:
                  // recordingVoiceId = null;
                  timer.cancel();
                  break;
                case RecordStateEnum.pause:
                  break;
                case RecordStateEnum.review:
                // TODO: Handle this case.
              }
            },
          );
        }
        recordingState = recordingState.fromRecordState(state);
        update();
      },
    );
  }

  Future<void> disposeRecording() async {
    await record.dispose();
    player.dispose();
    milliSeconds.dispose();
  }

  Future<void> recordAudio() async {
    recordingState = RecordStateEnum.record;
    update();
    String voiceId = generateUUID();
    if (await record.hasPermission()) {
      final appDirectory = await getTemporaryDirectory();
      await record.start(
        path: '${appDirectory.path}/$voiceId.$voiceRecordingFormat',
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
      );
      recordingVoiceId = voiceId;
    }
  }

  Future<void> pauseRecording() async {
    await record.pause();
  }

  Future<void> resumeRecording() async {
    await record.resume();
  }

  Future<void> cancelRecording() async {
    final recordedPath = await record.stop();
    if (recordedPath == null) return;
    try {
      File(recordedPath).delete();
    } catch (e) {
      //
    }
  }

  Future<void> lockRecord() async {
    recordingState = RecordStateEnum.lockRecord;
    update();
  }

  Future<void> stopRecording(String channelId) async {
    final voicePath = await record.stop();
    if (voicePath == null ||
        milliSeconds.value < minimumRecordingDurationMilliSeconds) return;
    FileModel fileModel = FileModel(
      formData: await File(voicePath).readAsBytes(),
      fileName: voicePath,
      filePath: voicePath,
    );
    recordedFileDuration = milliSeconds.value;
    // await sendMedia(channelId, fileModel);
  }

  Future<void> playRecordingVoice({int seek = 0}) async {
    if (recordingVoiceId == null) return;
    if (player.playing) {
      await player.seek(Duration.zero);
      await player.pause();
    }
    final appDirectory = await getTemporaryDirectory();

    // currentPlayingAudio.value.contentId = recordingVoiceId!;
    await player.setAudioSource(
      AudioSource.file("${appDirectory.path}/$recordingVoiceId.m4a"),
      initialPosition: Duration(seconds: seek),
    );
    await player.play();
  }

  Future<void> stopPlayer() async {
    await player.stop();
    await player.seek(Duration.zero);
    // audioStateNotifier = AudioState.stopped;
  }

  Future<void> pausePlayer() async {
    await player.pause();
  }

  Future<void> seek(int seek) async {
    await player.seek(Duration(milliseconds: seek));
  }

  Future<void> resumePlayer() async {
    await player.play();
  }
}

enum RecordStateEnum {
  pause,
  record,
  stop,
  review,
  lockRecord;

  RecordStateEnum fromRecordState(RecordState state) {
    if (this == RecordStateEnum.pause && state == RecordState.record) {
      return RecordStateEnum.lockRecord;
    }
    return switch (state) {
      RecordState.pause => RecordStateEnum.pause,
      RecordState.stop => RecordStateEnum.stop,
      RecordState.record => RecordStateEnum.record,
    };
  }
}
