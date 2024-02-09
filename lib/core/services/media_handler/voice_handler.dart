import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:messaging_core/core/enums/content_type_enum.dart';
import 'package:messaging_core/core/enums/file_type.dart';
import 'package:messaging_core/core/services/media_handler/file_model.dart';
import 'package:messaging_core/core/services/media_handler/media_handler.dart';
import 'package:messaging_core/core/utils/utils.dart';
import 'package:messaging_core/features/chat/domain/entities/content_model.dart';
import 'package:messaging_core/features/chat/domain/entities/content_payload_model.dart';
import 'package:messaging_core/features/chat/domain/entities/voice_content_payload_model.dart';
import 'package:messaging_core/features/chat/presentation/widgets/voice_content_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

enum RecordStateEnum {
  pause,
  record,
  stop,
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

class VoiceHandler extends MediaHandler {
  static const String voiceRecordingFormat = "m4a";
  final int minimumRecordingDurationMilliSeconds = 1000;
  late ValueNotifier<RecordStateEnum> recordingState;
  late ValueNotifier<int> milliSeconds;
  late ValueNotifier<AudioState> audioStateNotifier;
  late ValueNotifier<CurrentPlayingAudio?> currentPlayingAudio =
      ValueNotifier(null);
  late Record record;
  String? recordingVoiceId;

  final player = AudioPlayer();

  static final VoiceHandler _instance = VoiceHandler._internal();

  factory VoiceHandler() {
    return _instance;
  }
  //
  VoiceHandler._internal() {
    // MediaUploadManager().registerMediaHandler(ContentTypeEnum.voice, this);
  }
  //
  // CurrentChannelContentProvider get currentChannelContentProvider =>
  //     getIt.call<CurrentChannelContentProvider>();
  //
  @override
  void initState() {
    audioStateNotifier = ValueNotifier(AudioState.paused);
    listenToPlayerState();
  }

  @override
  void resetState() {}

  Future<void> initialRecording() async {
    milliSeconds = ValueNotifier(0);
    recordingState = ValueNotifier(RecordStateEnum.stop);
    record = Record();
    record.onStateChanged().listen(
      (state) {
        if (state == RecordState.record &&
            recordingState.value != RecordStateEnum.pause) {
          milliSeconds.value = 0;
          Timer.periodic(
            const Duration(milliseconds: 100),
            (timer) {
              switch (recordingState.value) {
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
              }
            },
          );
        }
        recordingState.value = recordingState.value.fromRecordState(state);
      },
    );
  }

  Future<void> disposeRecording() async {
    await record.dispose();
    recordingState.dispose();
    milliSeconds.dispose();
  }

  Future<void> recordAudio() async {
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
    recordingState.value = RecordStateEnum.lockRecord;
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
      await player.play();
    } else {
      if (player.playing) {
        pausePlayer();
      } else {
        resumePlayer();
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

  void changeAudioSpeed() {
    double speed = player.speed;
    if (speed == 1) {
      speed = 1.5;
    } else if (speed == 1.5) {
      speed = 2;
    } else {
      speed = 1;
    }
    player.setSpeed(speed);
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

  @override
  onUploadCompleted(ContentModel pendingContent, List<String> downloadUrls) {
    final durationInMilliSeconds =
        (pendingContent.contentPayload as VoiceContentPayloadModel)
            .durationInMilliSeconds;
    pendingContent.contentPayload = VoiceContentPayloadModel(
      url: downloadUrls.first,
      extension: voiceRecordingFormat,
      durationInMilliSeconds: durationInMilliSeconds,
    );
  }

  @override
  Future<List<String>?> uploadPendingFile(
      ContentModel pendingContent, FileModel fileModel) async {
    // final response = await uploadMedia(
    //   FileType.audio,
    //   HttpHeaderType.audio,
    //   fileModel,
    //   pendingContent.contentId,
    //   cacheKey: pendingContent.contentId,
    //   cancelToken: fileModel.fileCancelToken,
    // );
    // return response.fold(
    //   (fail) {
    //     //todo handle
    //     return null;
    //   },
    //   (downloadUrls) {
    //     return downloadUrls;
    //   },
    // );
  }

  @override
  ContentPayloadModel makeContentPayloadModel(FileModel fileModel,
      {String? caption}) {
    return VoiceContentPayloadModel(
      url: '',
      extension: voiceRecordingFormat,
      durationInMilliSeconds: milliSeconds.value,
    );
  }
}

class CurrentPlayingAudio {
  final String audioKey;
  final String title;

  const CurrentPlayingAudio({
    required this.audioKey,
    required this.title,
  });

  @override
  int get hashCode => audioKey.hashCode;

  @override
  bool operator ==(Object other) {
    return audioKey == (other as CurrentPlayingAudio).audioKey;
  }
}
