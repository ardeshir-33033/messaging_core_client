import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/file_type.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:messaging_core/features/chat/domain/entities/chats_parent_model.dart';
import 'package:messaging_core/features/chat/presentation/manager/chat_controller.dart';
import 'package:messaging_core/features/chat/presentation/widgets/voice_content_widget.dart';
import 'package:messaging_core/locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordVoiceController extends GetxController {
  static const String voiceRecordingFormat = "m4a";
  final int minimumRecordingDurationMilliSeconds = 1000;
  RecordStateEnum recordingState = RecordStateEnum.stop;
  String? recordingVoiceId;
  int? recordedFileDuration;
  late ValueNotifier<int> milliSeconds;
  late ValueNotifier<AudioState> audioStateNotifier;
  late ValueNotifier<CurrentPlayingAudio?> currentPlayingAudio =
      ValueNotifier(null);
  String? recordedFilePath;
  Record record = Record();

  AudioPlayer player = AudioPlayer();

  initialRecording() {
    milliSeconds = ValueNotifier(0);
    recordingState = RecordStateEnum.stop;
    audioStateNotifier = ValueNotifier(AudioState.paused);

    listenToPlayerState();
    record = Record();
    record.onStateChanged().listen(
      (state) {
        if (state == RecordState.record &&
            recordingState != RecordStateEnum.pause) {
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

  Future<void> stopRecording(ChatParentClass chat) async {
    final voicePath = await record.stop();
    if (voicePath == null ||
        milliSeconds.value < minimumRecordingDurationMilliSeconds) return;
    FileModel fileModel = FileModel(
      formData: await File(voicePath).readAsBytes(),
      fileName: voicePath,
      filePath: voicePath,
    );
    recordedFileDuration = milliSeconds.value;
    final ChatController controller = locator<ChatController>();

    controller.sendTextMessage(voicePath.substring(voicePath.length - 7),
        chat.id!, ContentTypeEnum.voice, fileModel);
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

  Future<void> playVoiceMessage(
    CurrentPlayingAudio playingAudio, {
    int? seek,
    FileType fileType = FileType.audio,
  }) async {
    if (currentPlayingAudio.value != playingAudio) {
      await player.seek(Duration.zero);
      await player.pause();
      final file = await getCachedFile(playingAudio.audioKey, fileType);
      if (file == null) return;
      currentPlayingAudio.value = playingAudio;

      await player.setFilePath(
        file.path,
        initialPosition: Duration(milliseconds: seek ?? 0),
      );

      audioStateNotifier.value = AudioState.playing;

      await player.play();
    } else {
      if (player.playing) {
        pausePlayer();
        audioStateNotifier.value = AudioState.paused;
      } else {
        resumePlayer();
        audioStateNotifier.value = AudioState.playing;
      }
    }
  }

  void listenToPlayerState() {
    player.playerStateStream.listen((playerState) async {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading) {
        audioStateNotifier.value = AudioState.loading;
      } else if (!isPlaying) {
        if (audioStateNotifier.value == AudioState.stopped) {
          currentPlayingAudio.value = null;
        } else {
          audioStateNotifier.value = AudioState.paused;
        }
      } else if (processingState != ProcessingState.completed) {
        audioStateNotifier.value = AudioState.playing;
      } else {
        stopPlayer();
      }
    });
  }

  Future<void> stopPlayer() async {
    await player.stop();
    await player.seek(Duration.zero);
    audioStateNotifier.value = AudioState.stopped;
  }

  Future<void> pausePlayer() async {
    audioStateNotifier.value = AudioState.paused;
    await player.pause();
  }

  Future<void> seek(int seek) async {
    await player.seek(Duration(milliseconds: seek));
  }

  Future<void> resumePlayer() async {
    audioStateNotifier.value = AudioState.playing;
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

class CurrentPlayingAudio {
  final String audioKey;
  // final String title;

  const CurrentPlayingAudio({
    required this.audioKey,
    // required this.title,
  });

  @override
  int get hashCode => audioKey.hashCode;

  @override
  bool operator ==(Object other) {
    return audioKey == (other as CurrentPlayingAudio).audioKey;
  }
}
