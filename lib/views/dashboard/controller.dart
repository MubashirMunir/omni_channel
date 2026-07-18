import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import '../../models/convo_list.dart' as convo_data;
import '../../models/message_model.dart';
import '../../widgets/formatted_time.dart';

class DashboardController extends GetxController {
  /// ============================================================
  /// SELECTED CONVERSATION
  /// ============================================================

  final Rxn<convo_data.ConversationModel> convoModel =
      Rxn<convo_data.ConversationModel>();

  /// ============================================================
  /// GENERAL UI STATES
  /// ============================================================

  final RxInt selectedIndex = 0.obs;
  final RxString selectedTab = 'All'.obs;
  final RxString selectedCenterView = ''.obs;
  final RxBool showEmojiBoard = false.obs;

  String? expandedList;
  bool isSelected = false;

  /// ============================================================
  /// TEXT AND SCROLL CONTROLLERS
  /// ============================================================

  final TextEditingController msgController = TextEditingController();
  final ScrollController messageScrollController = ScrollController();

  /// ============================================================
  /// CONVERSATIONS
  /// ============================================================

  final List<convo_data.ConversationModel> conversations =
      List<convo_data.ConversationModel>.from(convo_data.conversations);

  /// ============================================================
  /// MESSAGES
  /// ============================================================

  List<MessageModel> messages = [];

  final Map<String, List<MessageModel>> _messagesByConversation = {};

  /// ============================================================
  /// VOICE RECORDING
  /// ============================================================

  final AudioRecorder _voiceRecorder = AudioRecorder();

  /// Stopwatch is used instead of relying on Timer ticks for duration.
  /// Even if Flutter Web UI becomes busy, elapsed time stays correct.
  final Stopwatch _voiceStopwatch = Stopwatch();

  Timer? _voiceUiTimer;
  Timer? _voiceAmplitudeTimer;

  StreamSubscription<RecordState>? _voiceRecorderStateSub;

  /// Recording states.
  final RxBool isVoiceStarting = false.obs;
  final RxBool isVoiceRecording = false.obs;
  final RxBool isVoicePaused = false.obs;
  final RxBool isVoiceSending = false.obs;

  /// Recording duration.
  final RxInt voiceRecordingSeconds = 0.obs;
  final RxString voiceRecordingTime = '00:00'.obs;

  /// Current microphone level: 0.0 - 1.0.
  final RxDouble voiceLevel = 0.0.obs;

  /// Conversation where recording originally started.
  String? _recordingConversationId;

  /// Prevent overlapping start/stop/pause/resume actions.
  bool _voiceActionInProgress = false;

  /// Prevent multiple simultaneous getAmplitude() calls.
  bool _amplitudePollInProgress = false;

  /// Used to reject stale async amplitude results.
  int _voiceSessionId = 0;

  /// Maximum voice-note length.
  final int maxVoiceNoteSeconds = 120;

  /// ============================================================
  /// VOICE PLAYBACK
  /// ============================================================

  final AudioPlayer voicePlayer = AudioPlayer();

  final RxnString playingVoiceMessageId = RxnString();
  final RxBool isVoicePlaying = false.obs;

  final Rx<Duration> voicePosition = Duration.zero.obs;
  final Rx<Duration> voiceDuration = Duration.zero.obs;

  StreamSubscription<PlayerState>? _voicePlayerStateSub;
  StreamSubscription<Duration>? _voicePositionSub;
  StreamSubscription<Duration>? _voiceDurationSub;
  StreamSubscription<void>? _voiceCompleteSub;

  /// ============================================================
  /// CONTROLLER LIFECYCLE
  /// ============================================================

  @override
  void onInit() {
    super.onInit();

    /// ------------------------------------------------------------
    /// VOICE PLAYER LISTENERS
    /// ------------------------------------------------------------

    _voicePositionSub = voicePlayer.onPositionChanged.listen((position) {
      voicePosition.value = position;
    });

    _voiceDurationSub = voicePlayer.onDurationChanged.listen((duration) {
      voiceDuration.value = duration;
    });

    _voiceCompleteSub = voicePlayer.onPlayerComplete.listen((_) {
      _resetVoicePlaybackState();
      update();
    });

    _voicePlayerStateSub = voicePlayer.onPlayerStateChanged.listen((state) {
      isVoicePlaying.value = state == PlayerState.playing;
    });

    /// ------------------------------------------------------------
    /// RECORDER STATE LISTENER
    /// ------------------------------------------------------------
    ///
    /// This helps detect cases where the browser unexpectedly stops
    /// the microphone recording.
    _voiceRecorderStateSub = _voiceRecorder.onStateChanged().listen(
      (state) {
        debugPrint('VOICE RECORDER STATE: $state');

        if (state == RecordState.stop &&
            isVoiceRecording.value &&
            !isVoiceSending.value &&
            !_voiceActionInProgress) {
          debugPrint('VOICE RECORDER STOPPED UNEXPECTEDLY');

          _stopVoiceRuntimeTimers();

          _voiceStopwatch.stop();

          isVoiceRecording.value = false;
          isVoicePaused.value = false;

          voiceLevel.value = 0.0;

          Get.snackbar(
            'Recording Stopped',
            'The browser stopped microphone recording unexpectedly.',
          );

          update();
        }
      },
      onError: (Object error) {
        debugPrint('VOICE RECORDER STATE ERROR: $error');
      },
    );
  }

  @override
  void onClose() {
    _stopVoiceRuntimeTimers();

    _voiceRecorderStateSub?.cancel();

    _voicePlayerStateSub?.cancel();
    _voicePositionSub?.cancel();
    _voiceDurationSub?.cancel();
    _voiceCompleteSub?.cancel();

    unawaited(_voiceRecorder.cancel());
    unawaited(_voiceRecorder.dispose());

    unawaited(voicePlayer.dispose());

    msgController.dispose();
    messageScrollController.dispose();

    super.onClose();
  }

  /// ============================================================
  /// NAVIGATION / UI METHODS
  /// ============================================================

  void changeIndex(int index) {
    selectedIndex.value = index;
    update();
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
    update();
  }

  void toggleExpandedList(String title, bool value) {
    expandedList = value ? title : null;
    update();
  }

  /// ============================================================
  /// EMOJI METHODS
  /// ============================================================

  void toggleEmojiBoard() {
    showEmojiBoard.value = !showEmojiBoard.value;

    update();
  }

  void hideEmojiBoard() {
    showEmojiBoard.value = false;
    update();
  }

  void showEmojiKeyboard() {
    showEmojiBoard.value = true;
    update();
  }

  void addEmoji(String emoji) {
    final oldText = msgController.text;
    final selection = msgController.selection;

    final cursorPosition = selection.baseOffset < 0
        ? oldText.length
        : selection.baseOffset;

    final newText = oldText.replaceRange(cursorPosition, cursorPosition, emoji);

    msgController.text = newText;

    msgController.selection = TextSelection.collapsed(
      offset: cursorPosition + emoji.length,
    );

    update();
  }

  /// ============================================================
  /// SCROLL TO LATEST MESSAGE
  /// ============================================================

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!messageScrollController.hasClients) {
        return;
      }

      messageScrollController.animateTo(
        messageScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  /// ============================================================
  /// OPEN / SELECT CONVERSATION
  /// ============================================================

  Future<void> selectConversation(
    convo_data.ConversationModel conversation,
  ) async {
    final currentConversationId = convoModel.value?.id;

    final isDifferentConversation = currentConversationId != conversation.id;

    if (isDifferentConversation) {
      await stopVoiceMessage();

      msgController.clear();
      hideEmojiBoard();

      if (isVoiceRecording.value ||
          isVoicePaused.value ||
          isVoiceStarting.value) {
        await cancelVoiceRecording();
      }
    }

    final conversationIndex = conversations.indexWhere(
      (item) => item.id == conversation.id,
    );

    if (conversationIndex != -1) {
      conversations[conversationIndex] = conversations[conversationIndex]
          .copyWith(unread: 0);

      convoModel.value = conversations[conversationIndex];
    } else {
      msgController.clear();
      hideEmojiBoard();

      convoModel.value = conversation;
    }

    loadMessages(conversation.id);

    update();
    scrollToBottom();
  }

  Future<void> openChat(convo_data.ConversationModel model) async {
    selectedCenterView.value = model.platform;

    await selectConversation(model);
  }

  void openGmail() {
    if (isVoiceRecording.value ||
        isVoicePaused.value ||
        isVoiceStarting.value) {
      unawaited(cancelVoiceRecording());
    }

    isSelected = !isSelected;

    selectedCenterView.value = 'Gmail';

    convoModel.value = null;

    update();
  }

  /// ============================================================
  /// SELECTED CHAT HELPERS
  /// ============================================================

  bool get hasSelectedConversation {
    return convoModel.value != null;
  }

  convo_data.ConversationModel? get selectedConversation {
    return convoModel.value;
  }

  /// ============================================================
  /// LOAD MESSAGES
  /// ============================================================

  void loadMessages(String conversationId) {
    final conversation = conversations.firstWhereOrNull(
      (item) => item.id == conversationId,
    );

    if (conversation == null) {
      messages = [];
      update();
      return;
    }

    messages = _messagesByConversation.putIfAbsent(
      conversationId,
      () => _getDefaultMessagesByPlatform(conversation.platform),
    );

    update();
  }

  /// ============================================================
  /// SEND TEXT MESSAGE
  /// ============================================================

  void sendMessage() {
    final text = msgController.text.trim();

    if (text.isEmpty) {
      return;
    }

    final selectedConversation = convoModel.value;

    if (selectedConversation == null) {
      return;
    }

    final now = DateTime.now();

    final newMessage = MessageModel(
      id: now.microsecondsSinceEpoch.toString(),
      text: text,
      isMe: true,
      time: formatTime(now),
      timestamp: now,
      type: MessageType.text,
      status: MessageStatus.sent,
    );

    final chatMessages = _messagesByConversation.putIfAbsent(
      selectedConversation.id,
      () => _getDefaultMessagesByPlatform(selectedConversation.platform),
    );

    chatMessages.add(newMessage);

    messages = chatMessages;

    _updateConversationPreview(
      conversationId: selectedConversation.id,
      previewText: text,
      updatedAt: now,
    );

    msgController.clear();
    hideEmojiBoard();

    update();
    scrollToBottom();
  }

  /// ============================================================
  /// DIRECT VOICE MESSAGE ADD
  /// ============================================================

  void sendVoiceMessage({required String audioPath, required int duration}) {
    final selectedConversation = convoModel.value;

    if (selectedConversation == null) {
      return;
    }

    _sendVoiceMessageToConversation(
      conversation: selectedConversation,
      audioPath: audioPath,
      duration: duration,
    );

    hideEmojiBoard();

    update();
    scrollToBottom();
  }

  /// ============================================================
  /// START VOICE RECORDING
  /// ============================================================

  Future<void> startVoiceRecording() async {
    final selectedConversation = convoModel.value;

    if (selectedConversation == null) {
      Get.snackbar(
        'No Chat Selected',
        'Please select a conversation before recording voice note.',
      );

      return;
    }

    /// Prevent double tap / duplicate start.
    if (_voiceActionInProgress ||
        isVoiceStarting.value ||
        isVoiceRecording.value ||
        isVoicePaused.value ||
        isVoiceSending.value) {
      return;
    }

    _voiceActionInProgress = true;

    isVoiceStarting.value = true;

    update();

    try {
      /// Pause currently playing voice message.
      if (isVoicePlaying.value) {
        await voicePlayer.pause();
      }

      /// Microphone permission.
      final hasPermission = await _voiceRecorder.hasPermission();

      debugPrint('MIC PERMISSION: $hasPermission');

      if (!hasPermission) {
        Get.snackbar(
          'Microphone Permission',
          'Please allow microphone access to record voice notes.',
        );

        return;
      }

      /// Clear any previous recording state.
      _resetVoiceState(clearConversation: true);

      /// Save the conversation where
      /// recording started.
      _recordingConversationId = selectedConversation.id;

      /// Choose the best encoder for
      /// the current browser/platform.
      final config = await _createVoiceRecordConfig();

      debugPrint('VOICE ENCODER: ${config.encoder}');

      final path = _createVoiceRecordingPath(config.encoder);

      debugPrint('VOICE RECORDING PATH: $path');

      /// Start actual microphone recording.
      await _voiceRecorder.start(config, path: path);

      /// Make sure recorder actually started.
      final recorderStarted = await _voiceRecorder.isRecording();

      if (!recorderStarted) {
        throw StateError('Recorder failed to start.');
      }

      /// Create a new recording session ID.
      final currentSessionId = _voiceSessionId;

      /// Reset and start accurate clock.
      _voiceStopwatch
        ..reset()
        ..start();

      voiceRecordingSeconds.value = 0;
      voiceRecordingTime.value = '00:00';

      voiceLevel.value = 0.0;

      isVoiceStarting.value = false;
      isVoiceRecording.value = true;
      isVoicePaused.value = false;
      isVoiceSending.value = false;

      /// Start lightweight UI duration updates.
      _startVoiceUiTimer(currentSessionId);

      /// Start safe amplitude polling.
      ///
      /// We intentionally do NOT use
      /// onAmplitudeChanged() here.
      _startAmplitudePolling(currentSessionId);

      debugPrint('VOICE RECORDING STARTED');

      update();
    } catch (error, stackTrace) {
      debugPrint('VOICE RECORDING ERROR: $error');

      debugPrintStack(stackTrace: stackTrace);

      try {
        await _voiceRecorder.cancel();
      } catch (_) {}

      _resetVoiceState(clearConversation: true);

      Get.snackbar('Recording Error', error.toString());

      update();
    } finally {
      isVoiceStarting.value = false;
      _voiceActionInProgress = false;
    }
  }

  /// ============================================================
  /// CREATE RECORDING CONFIG
  /// ============================================================

  Future<RecordConfig> _createVoiceRecordConfig() async {
    /// ------------------------------------------------------------
    /// WEB
    /// ------------------------------------------------------------
    ///
    /// Chrome / Edge / Firefox commonly support Opus
    /// through the browser's native MediaRecorder.
    ///
    /// Prefer it when available instead of forcing
    /// Flutter/Dart-side WAV processing.
    if (kIsWeb) {
      final opusSupported = await _voiceRecorder.isEncoderSupported(
        AudioEncoder.opus,
      );

      if (opusSupported) {
        debugPrint('USING OPUS FOR WEB RECORDING');

        return const RecordConfig(
          encoder: AudioEncoder.opus,
          bitRate: 64000,
          sampleRate: 48000,
          numChannels: 1,
          autoGain: true,
          echoCancel: true,
          noiseSuppress: true,
        );
      }

      final wavSupported = await _voiceRecorder.isEncoderSupported(
        AudioEncoder.wav,
      );

      if (!wavSupported) {
        throw UnsupportedError(
          'This browser does not support a compatible audio encoder.',
        );
      }

      debugPrint('USING WAV FALLBACK FOR WEB RECORDING');

      return const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 48000,
        numChannels: 1,
        autoGain: true,
        echoCancel: true,
        noiseSuppress: true,
      );
    }

    /// ------------------------------------------------------------
    /// NON-WEB
    /// ------------------------------------------------------------

    final aacSupported = await _voiceRecorder.isEncoderSupported(
      AudioEncoder.aacLc,
    );

    if (aacSupported) {
      return const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 64000,
        sampleRate: 44100,
        numChannels: 1,
        autoGain: true,
        echoCancel: true,
        noiseSuppress: true,
      );
    }

    return const RecordConfig(
      encoder: AudioEncoder.wav,
      sampleRate: 44100,
      numChannels: 1,
    );
  }

  /// ============================================================
  /// CREATE RECORDING PATH
  /// ============================================================

  String _createVoiceRecordingPath(AudioEncoder encoder) {
    /// Web requires an empty path.
    if (kIsWeb) {
      return '';
    }

    String extension;

    switch (encoder) {
      case AudioEncoder.opus:
        extension = 'opus';
        break;

      case AudioEncoder.aacLc:
      case AudioEncoder.aacEld:
      case AudioEncoder.aacHe:
        extension = 'm4a';
        break;

      case AudioEncoder.wav:
        extension = 'wav';
        break;

      case AudioEncoder.flac:
        extension = 'flac';
        break;

      case AudioEncoder.pcm16bits:
        extension = 'pcm';
        break;

      case AudioEncoder.amrNb:
      case AudioEncoder.amrWb:
        extension = '3gp';
        break;
    }

    return 'voice_note_'
        '${DateTime.now().millisecondsSinceEpoch}'
        '.$extension';
  }

  /// ============================================================
  /// RECORDING UI TIMER
  /// ============================================================

  void _startVoiceUiTimer(int sessionId) {
    _voiceUiTimer?.cancel();

    _voiceUiTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      /// Ignore an old recording session.
      if (sessionId != _voiceSessionId) {
        return;
      }

      if (!isVoiceRecording.value) {
        return;
      }

      /// Stopwatch remains accurate even
      /// if Flutter UI frames are delayed.
      final elapsedSeconds = _voiceStopwatch.elapsed.inSeconds;

      /// Only notify Rx when the displayed
      /// second actually changes.
      if (voiceRecordingSeconds.value != elapsedSeconds) {
        voiceRecordingSeconds.value = elapsedSeconds;

        voiceRecordingTime.value = _formatVoiceDuration(elapsedSeconds);
      }

      if (elapsedSeconds >= maxVoiceNoteSeconds) {
        _voiceUiTimer?.cancel();
        _voiceUiTimer = null;

        unawaited(stopVoiceRecordingAndSend());
      }

      /// IMPORTANT:
      ///
      /// NO update() here.
      ///
      /// Recording UI should use Obx
      /// for voiceRecordingTime.
    });
  }

  /// ============================================================
  /// SAFE AMPLITUDE POLLING
  /// ============================================================

  void _startAmplitudePolling(int sessionId) {
    _voiceAmplitudeTimer?.cancel();

    /// 400 ms = only 2.5 microphone-level
    /// reads per second.
    ///
    /// This is much lighter than continuously
    /// rebuilding the dashboard.
    _voiceAmplitudeTimer = Timer.periodic(const Duration(milliseconds: 400), (
      _,
    ) {
      if (sessionId != _voiceSessionId) {
        return;
      }

      if (!isVoiceRecording.value) {
        return;
      }

      unawaited(_pollVoiceAmplitude(sessionId));
    });
  }

  Future<void> _pollVoiceAmplitude(int sessionId) async {
    if (_amplitudePollInProgress) {
      return;
    }

    if (!isVoiceRecording.value) {
      return;
    }

    _amplitudePollInProgress = true;

    try {
      final amplitude = await _voiceRecorder.getAmplitude();

      /// Recording may have stopped while
      /// getAmplitude was waiting.
      if (sessionId != _voiceSessionId || !isVoiceRecording.value) {
        return;
      }

      /// Convert approximately -50dB..0dB
      /// to 0.0..1.0.
      final normalized = ((amplitude.current + 50.0) / 50.0).clamp(0.0, 1.0);

      voiceLevel.value = normalized.toDouble();

      /// IMPORTANT:
      ///
      /// NO update() here.
      ///
      /// Only a small Obx waveform widget
      /// should react to voiceLevel.
    } catch (error) {
      debugPrint('VOICE AMPLITUDE ERROR: $error');
    } finally {
      _amplitudePollInProgress = false;
    }
  }

  /// ============================================================
  /// PAUSE RECORDING
  /// ============================================================

  Future<void> pauseVoiceRecording() async {
    if (_voiceActionInProgress ||
        !isVoiceRecording.value ||
        isVoiceSending.value) {
      return;
    }

    _voiceActionInProgress = true;

    try {
      await _voiceRecorder.pause();

      _voiceStopwatch.stop();

      _voiceAmplitudeTimer?.cancel();
      _voiceAmplitudeTimer = null;

      isVoiceRecording.value = false;
      isVoicePaused.value = true;

      voiceLevel.value = 0.0;

      debugPrint('VOICE RECORDING PAUSED');

      update();
    } catch (error, stackTrace) {
      debugPrint('VOICE PAUSE ERROR: $error');

      debugPrintStack(stackTrace: stackTrace);

      Get.snackbar('Pause Error', error.toString());
    } finally {
      _voiceActionInProgress = false;
    }
  }

  /// ============================================================
  /// RESUME RECORDING
  /// ============================================================

  Future<void> resumeVoiceRecording() async {
    if (_voiceActionInProgress ||
        !isVoicePaused.value ||
        isVoiceSending.value) {
      return;
    }

    _voiceActionInProgress = true;

    try {
      await _voiceRecorder.resume();

      _voiceStopwatch.start();

      isVoiceRecording.value = true;
      isVoicePaused.value = false;

      final currentSessionId = _voiceSessionId;

      _startAmplitudePolling(currentSessionId);

      debugPrint('VOICE RECORDING RESUMED');

      update();
    } catch (error, stackTrace) {
      debugPrint('VOICE RESUME ERROR: $error');

      debugPrintStack(stackTrace: stackTrace);

      Get.snackbar('Resume Error', error.toString());
    } finally {
      _voiceActionInProgress = false;
    }
  }

  /// ============================================================
  /// TOGGLE PAUSE / RESUME
  /// ============================================================

  Future<void> togglePauseResumeVoiceRecording() async {
    if (_voiceActionInProgress || isVoiceSending.value) {
      return;
    }

    if (isVoiceRecording.value) {
      await pauseVoiceRecording();
      return;
    }

    if (isVoicePaused.value) {
      await resumeVoiceRecording();
    }
  }

  /// ============================================================
  /// CANCEL RECORDING
  /// ============================================================

  Future<void> cancelVoiceRecording() async {
    if (_voiceActionInProgress) {
      return;
    }

    if (!isVoiceRecording.value &&
        !isVoicePaused.value &&
        !isVoiceStarting.value) {
      return;
    }

    _voiceActionInProgress = true;

    try {
      _stopVoiceRuntimeTimers();

      _voiceStopwatch.stop();

      await _voiceRecorder.cancel();

      debugPrint('VOICE RECORDING CANCELLED');
    } catch (error, stackTrace) {
      debugPrint('VOICE RECORDING CANCEL ERROR: $error');

      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _resetVoiceState(clearConversation: true);

      _voiceActionInProgress = false;

      update();
    }
  }

  /// ============================================================
  /// STOP RECORDING AND SEND
  /// ============================================================

  Future<void> stopVoiceRecordingAndSend() async {
    if (_voiceActionInProgress || isVoiceSending.value) {
      return;
    }

    if (!isVoiceRecording.value && !isVoicePaused.value) {
      return;
    }

    _voiceActionInProgress = true;

    isVoiceSending.value = true;

    /// Stop all UI / amplitude activity
    /// BEFORE stopping recorder.
    _stopVoiceRuntimeTimers();

    _voiceStopwatch.stop();

    /// Calculate actual duration using
    /// Stopwatch instead of Timer count.
    final elapsedMilliseconds = _voiceStopwatch.elapsedMilliseconds;

    final duration = (elapsedMilliseconds / 1000).ceil();

    final recordingConversationId = _recordingConversationId;

    /// Change recording UI immediately.
    isVoiceRecording.value = false;
    isVoicePaused.value = false;

    voiceLevel.value = 0.0;

    update();

    try {
      debugPrint('STOPPING VOICE RECORDING...');

      final audioPath = await _voiceRecorder.stop();

      debugPrint('VOICE AUDIO PATH: $audioPath');

      debugPrint('VOICE DURATION: $duration seconds');

      if (audioPath == null || audioPath.trim().isEmpty) {
        Get.snackbar('Voice Note', 'Recording could not be saved.');

        return;
      }

      if (duration < 1) {
        Get.snackbar('Voice Note', 'Recording is too short.');

        return;
      }

      if (recordingConversationId == null) {
        Get.snackbar('Voice Note', 'Conversation not found.');

        return;
      }

      final conversation = conversations.firstWhereOrNull(
        (item) => item.id == recordingConversationId,
      );

      if (conversation == null) {
        Get.snackbar('Voice Note', 'Conversation not found.');

        return;
      }

      _sendVoiceMessageToConversation(
        conversation: conversation,
        audioPath: audioPath,
        duration: duration,
      );

      debugPrint('VOICE MESSAGE SENT');
    } catch (error, stackTrace) {
      debugPrint('VOICE NOTE SEND ERROR: $error');

      debugPrintStack(stackTrace: stackTrace);

      Get.snackbar('Voice Note Error', error.toString());
    } finally {
      _resetVoiceState(clearConversation: true);

      _voiceActionInProgress = false;

      update();
      scrollToBottom();
    }
  }

  /// ============================================================
  /// STOP RECORDING RUNTIME TIMERS
  /// ============================================================

  void _stopVoiceRuntimeTimers() {
    _voiceUiTimer?.cancel();
    _voiceUiTimer = null;

    _voiceAmplitudeTimer?.cancel();
    _voiceAmplitudeTimer = null;
  }

  /// ============================================================
  /// RESET RECORDING STATE
  /// ============================================================

  void _resetVoiceState({bool clearConversation = true}) {
    /// Invalidates any previous async
    /// amplitude result.
    _voiceSessionId++;

    _stopVoiceRuntimeTimers();

    _voiceStopwatch
      ..stop()
      ..reset();

    _amplitudePollInProgress = false;

    isVoiceStarting.value = false;
    isVoiceRecording.value = false;
    isVoicePaused.value = false;
    isVoiceSending.value = false;

    voiceRecordingSeconds.value = 0;
    voiceRecordingTime.value = '00:00';

    voiceLevel.value = 0.0;

    if (clearConversation) {
      _recordingConversationId = null;
    }
  }

  /// ============================================================
  /// FORMAT VOICE DURATION
  /// ============================================================

  String _formatVoiceDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;

    final seconds = totalSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// ============================================================
  /// ADD VOICE MESSAGE
  /// ============================================================

  void _sendVoiceMessageToConversation({
    required convo_data.ConversationModel conversation,
    required String audioPath,
    required int duration,
  }) {
    final now = DateTime.now();

    final newMessage = MessageModel(
      id: now.microsecondsSinceEpoch.toString(),
      text: '',
      isMe: true,
      time: formatTime(now),
      timestamp: now,
      type: MessageType.audio,
      status: MessageStatus.sent,
      audioPath: audioPath,
      audioDuration: duration,
    );

    final chatMessages = _messagesByConversation.putIfAbsent(
      conversation.id,
      () => _getDefaultMessagesByPlatform(conversation.platform),
    );

    chatMessages.add(newMessage);

    /// Only update visible messages if
    /// this conversation is still open.
    if (convoModel.value?.id == conversation.id) {
      messages = chatMessages;
    }

    _updateConversationPreview(
      conversationId: conversation.id,
      previewText: '🎙 Voice message',
      updatedAt: now,
    );
  }

  /// ============================================================
  /// VOICE MESSAGE PLAYBACK HELPERS
  /// ============================================================

  bool isVoiceMessagePlaying(String messageId) {
    return playingVoiceMessageId.value == messageId && isVoicePlaying.value;
  }

  bool isVoiceMessageSelected(String messageId) {
    return playingVoiceMessageId.value == messageId;
  }

  Duration getVoicePosition(String messageId) {
    if (playingVoiceMessageId.value == messageId) {
      return voicePosition.value;
    }

    return Duration.zero;
  }

  Duration getVoiceDuration(MessageModel message) {
    final isActiveMessage = playingVoiceMessageId.value == message.id;

    if (isActiveMessage && voiceDuration.value > Duration.zero) {
      return voiceDuration.value;
    }

    return Duration(seconds: message.audioDuration ?? 0);
  }

  /// ============================================================
  /// PLAY / PAUSE / RESUME VOICE MESSAGE
  /// ============================================================

  Future<void> toggleVoiceMessage(MessageModel message) async {
    final audioPath = message.audioPath;

    if (audioPath == null || audioPath.trim().isEmpty) {
      Get.snackbar('Voice Note', 'Audio file was not found.');

      return;
    }

    try {
      final isSameMessage = playingVoiceMessageId.value == message.id;

      if (isSameMessage) {
        if (isVoicePlaying.value) {
          await voicePlayer.pause();
        } else {
          await voicePlayer.resume();
        }

        return;
      }

      await voicePlayer.stop();

      playingVoiceMessageId.value = message.id;

      isVoicePlaying.value = false;

      voicePosition.value = Duration.zero;

      voiceDuration.value = Duration(seconds: message.audioDuration ?? 0);

      if (_isNetworkOrWebAudioPath(audioPath)) {
        await voicePlayer.play(UrlSource(audioPath));
      } else {
        await voicePlayer.play(DeviceFileSource(audioPath));
      }
    } catch (error, stackTrace) {
      debugPrint('VOICE PLAYBACK ERROR: $error');

      debugPrintStack(stackTrace: stackTrace);

      _resetVoicePlaybackState();

      Get.snackbar('Playback Error', error.toString());

      update();
    }
  }

  bool _isNetworkOrWebAudioPath(String audioPath) {
    return kIsWeb ||
        audioPath.startsWith('http://') ||
        audioPath.startsWith('https://') ||
        audioPath.startsWith('blob:');
  }

  /// ============================================================
  /// SEEK VOICE MESSAGE
  /// ============================================================

  Future<void> seekVoiceMessage({
    required String messageId,
    required double seconds,
  }) async {
    if (playingVoiceMessageId.value != messageId) {
      return;
    }

    if (seconds.isNaN || seconds.isInfinite || seconds < 0) {
      return;
    }

    try {
      await voicePlayer.seek(Duration(milliseconds: (seconds * 1000).round()));
    } catch (error) {
      debugPrint('VOICE SEEK ERROR: $error');
    }
  }

  /// ============================================================
  /// STOP VOICE MESSAGE PLAYBACK
  /// ============================================================

  Future<void> stopVoiceMessage() async {
    try {
      await voicePlayer.stop();
    } catch (error) {
      debugPrint('VOICE STOP ERROR: $error');
    }

    _resetVoicePlaybackState();

    update();
  }

  void _resetVoicePlaybackState() {
    playingVoiceMessageId.value = null;

    isVoicePlaying.value = false;

    voicePosition.value = Duration.zero;

    voiceDuration.value = Duration.zero;
  }

  /// ============================================================
  /// CONVERSATION PREVIEW UPDATE
  /// ============================================================

  void _updateConversationPreview({
    required String conversationId,
    required String previewText,
    required DateTime updatedAt,
  }) {
    final conversationIndex = conversations.indexWhere(
      (item) => item.id == conversationId,
    );

    if (conversationIndex == -1) {
      return;
    }

    conversations[conversationIndex] = conversations[conversationIndex]
        .copyWith(
          message: previewText,
          time: formatTime(updatedAt),
          updatedAt: updatedAt,
          unread: 0,
        );

    sortConversations();

    if (convoModel.value?.id == conversationId) {
      convoModel.value = conversations.firstWhereOrNull(
        (item) => item.id == conversationId,
      );
    }
  }

  /// ============================================================
  /// SORTING
  /// ============================================================

  void sortConversations() {
    conversations.sort((first, second) {
      return second.updatedAt.compareTo(first.updatedAt);
    });
  }

  /// ============================================================
  /// FILTERS
  /// ============================================================

  List<convo_data.ConversationModel> get filteredConversations {
    List<convo_data.ConversationModel> filteredList;

    if (selectedTab.value == 'Unread') {
      filteredList = conversations
          .where((conversation) => conversation.unread > 0)
          .toList();
    } else if (selectedTab.value == 'Assigned') {
      filteredList = conversations
          .where((conversation) => conversation.assigned)
          .toList();
    } else {
      filteredList = conversations.toList();
    }

    filteredList.sort((first, second) {
      return second.updatedAt.compareTo(first.updatedAt);
    });

    return filteredList;
  }

  List<convo_data.ConversationModel> getByPlatform(String platform) {
    final filteredList = filteredConversations
        .where(
          (conversation) =>
              conversation.platform.toLowerCase() == platform.toLowerCase(),
        )
        .toList();

    filteredList.sort((first, second) {
      return second.updatedAt.compareTo(first.updatedAt);
    });

    return filteredList;
  }

  int countByPlatform(String platform) {
    return getByPlatform(platform).length;
  }

  /// ============================================================
  /// DEFAULT PLATFORM MESSAGES
  /// ============================================================

  List<MessageModel> _getDefaultMessagesByPlatform(String platform) {
    final channel = platform.toLowerCase();

    if (channel == 'whatsapp') {
      return [
        MessageModel(
          id: 'w1',
          text: 'Assa lam o Alaikum 👋',
          isMe: false,
          time: '10:20 AM',
        ),
        MessageModel(
          id: 'w2',
          text: 'Wa Alaikum Salam! How can I help you?',
          isMe: true,
          time: '10:21 AM',
        ),
        MessageModel(
          id: 'w3',
          text: 'Mujhe pricing package ki details chahiye.',
          isMe: false,
          time: '10:22 AM',
        ),
        MessageModel(
          id: 'w4',
          text: 'Sure, humare paas Basic, Pro aur Enterprise plans hain.',
          isMe: true,
          time: '10:23 AM',
        ),
        MessageModel(
          id: 'w5',
          text: 'Pro plan me kya kya included hai?',
          isMe: false,
          time: '10:24 AM',
        ),
        MessageModel(
          id: 'w6',
          text:
              'Pro plan me WhatsApp inbox, team assignment, unread filter, analytics aur lead tracking included hai.',
          isMe: true,
          time: '10:25 AM',
        ),
        MessageModel(
          id: 'w7',
          text: 'Can you share package pictures too?',
          isMe: false,
          time: '10:26 AM',
        ),
        MessageModel(
          id: 'w8',
          text: 'Yes, main package screenshots abhi share kar deta hun.',
          isMe: true,
          time: '10:27 AM',
        ),
      ];
    }

    if (channel == 'facebook') {
      return [
        MessageModel(
          id: 'f1',
          text: 'Hi, I saw your CRM ad on Facebook.',
          isMe: false,
          time: '09:05 AM',
        ),
        MessageModel(
          id: 'f2',
          text: 'Hello! Thanks for reaching out. What would you like to know?',
          isMe: true,
          time: '09:06 AM',
        ),
        MessageModel(
          id: 'f3',
          text: 'Can this CRM connect with my Facebook page?',
          isMe: false,
          time: '09:07 AM',
        ),
        MessageModel(
          id: 'f4',
          text:
              'Yes, you can connect your Facebook page and manage page messages from one dashboard.',
          isMe: true,
          time: '09:08 AM',
        ),
        MessageModel(
          id: 'f5',
          text: 'Can my team reply to customers from the same dashboard?',
          isMe: false,
          time: '09:09 AM',
        ),
        MessageModel(
          id: 'f6',
          text:
              'Yes, you can add agents, assign conversations, and monitor replies.',
          isMe: true,
          time: '09:10 AM',
        ),
        MessageModel(
          id: 'f7',
          text: 'Is there any monthly package?',
          isMe: false,
          time: '09:11 AM',
        ),
        MessageModel(
          id: 'f8',
          text: 'Yes, monthly packages are available. I can share details.',
          isMe: true,
          time: '09:12 AM',
        ),
      ];
    }

    if (channel == 'instagram') {
      return [
        MessageModel(
          id: 'i1',
          text: 'Hey, I need help with my order.',
          isMe: false,
          time: '11:15 AM',
        ),
        MessageModel(
          id: 'i2',
          text: 'Sure! Please share your order number.',
          isMe: true,
          time: '11:16 AM',
        ),
        MessageModel(
          id: 'i3',
          text: 'Order number is #ELT-1029.',
          isMe: false,
          time: '11:17 AM',
        ),
        MessageModel(
          id: 'i4',
          text: 'Thanks. Let me check the order status for you.',
          isMe: true,
          time: '11:18 AM',
        ),
        MessageModel(
          id: 'i5',
          text: 'Also, do you provide support on Instagram DM?',
          isMe: false,
          time: '11:19 AM',
        ),
        MessageModel(
          id: 'i6',
          text:
              'Yes, Instagram DM support can be managed from this CRM dashboard.',
          isMe: true,
          time: '11:20 AM',
        ),
        MessageModel(
          id: 'i7',
          text: 'Can I assign DMs to my team members?',
          isMe: false,
          time: '11:21 AM',
        ),
        MessageModel(
          id: 'i8',
          text:
              'Yes, every Instagram conversation can be assigned to a specific agent.',
          isMe: true,
          time: '11:22 AM',
        ),
      ];
    }

    return [
      MessageModel(id: 'd1', text: 'Hello 👋', isMe: false, time: '10:20 AM'),
      MessageModel(
        id: 'd2',
        text: 'Hi! How can I help you?',
        isMe: true,
        time: '10:21 AM',
      ),
    ];
  }
}
