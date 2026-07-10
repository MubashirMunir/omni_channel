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

  Timer? _voiceTimer;
  StreamSubscription<Amplitude>? _amplitudeSub;

  final RxBool isVoiceRecording = false.obs;
  final RxBool isVoicePaused = false.obs;
  final RxBool isVoiceSending = false.obs;

  final RxInt voiceRecordingSeconds = 0.obs;
  final RxString voiceRecordingTime = '00:00'.obs;
  final RxDouble voiceLevel = 0.0.obs;

  String? _recordingConversationId;

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

    _voicePositionSub = voicePlayer.onPositionChanged.listen((position) {
      voicePosition.value = position;
    });

    _voiceDurationSub = voicePlayer.onDurationChanged.listen((duration) {
      voiceDuration.value = duration;
    });

    _voiceCompleteSub = voicePlayer.onPlayerComplete.listen((_) {
      playingVoiceMessageId.value = null;
      isVoicePlaying.value = false;
      voicePosition.value = Duration.zero;
      voiceDuration.value = Duration.zero;

      update();
    });

    _voicePlayerStateSub = voicePlayer.onPlayerStateChanged.listen((state) {
      isVoicePlaying.value = state == PlayerState.playing;

      update();
    });
  }

  @override
  void onClose() {
    _voiceTimer?.cancel();
    _amplitudeSub?.cancel();

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

      if (isVoiceRecording.value || isVoicePaused.value) {
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

  /// Gmail method intentionally kept without Gmail voice functionality.
  void openGmail() {
    if (isVoiceRecording.value || isVoicePaused.value) {
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
    // Pause the currently playing voice note
    // and keep its current playback position.
    if (isVoicePlaying.value) {
      await voicePlayer.pause();
    }
    final selectedConversation = convoModel.value;

    if (selectedConversation == null) {
      Get.snackbar(
        'No Chat Selected',
        'Please select a conversation before recording voice note.',
      );
      return;
    }

    if (isVoiceRecording.value || isVoicePaused.value || isVoiceSending.value) {
      return;
    }

    try {
      final hasPermission = await _voiceRecorder.hasPermission();

      debugPrint('MIC PERMISSION RESULT: $hasPermission');
      debugPrint('IS WEB: $kIsWeb');

      /*
       * On mobile or desktop, permission is required.
       *
       * On web, some browsers can return false even after permission
       * has been granted, so recording start is attempted directly.
       */
      if (!hasPermission && !kIsWeb) {
        Get.snackbar(
          'Microphone Permission',
          'Please allow microphone permission to record voice note.',
        );
        return;
      }

      const config = RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 44100,
        bitRate: 128000,
        numChannels: 1,
      );

      final isSupported = await _voiceRecorder.isEncoderSupported(
        config.encoder,
      );

      debugPrint('WAV SUPPORTED: $isSupported');

      if (!isSupported) {
        Get.snackbar(
          'Unsupported Audio',
          'Your device or browser does not support WAV recording.',
        );
        return;
      }

      hideEmojiBoard();
      _resetVoiceState();

      _recordingConversationId = selectedConversation.id;

      final fileName =
          'voice_note_${DateTime.now().millisecondsSinceEpoch}.wav';

      await _voiceRecorder.start(config, path: fileName);

      isVoiceRecording.value = true;
      isVoicePaused.value = false;

      _startVoiceTimer();
      _listenVoiceAmplitude();

      update();
    } catch (error) {
      debugPrint('VOICE RECORDING ERROR: $error');

      Get.snackbar('Recording Error', error.toString());

      _resetVoiceState();
      update();
    }
  }

  /// ============================================================
  /// PAUSE VOICE RECORDING
  /// ============================================================

  Future<void> pauseVoiceRecording() async {
    if (!isVoiceRecording.value) {
      return;
    }

    try {
      await _voiceRecorder.pause();

      isVoiceRecording.value = false;
      isVoicePaused.value = true;

      _voiceTimer?.cancel();
      _voiceTimer = null;

      update();
    } catch (error) {
      Get.snackbar('Pause Error', error.toString());
    }
  }

  /// ============================================================
  /// RESUME VOICE RECORDING
  /// ============================================================

  Future<void> resumeVoiceRecording() async {
    if (!isVoicePaused.value) {
      return;
    }

    try {
      await _voiceRecorder.resume();

      isVoiceRecording.value = true;
      isVoicePaused.value = false;

      _startVoiceTimer();

      update();
    } catch (error) {
      Get.snackbar('Resume Error', error.toString());
    }
  }

  Future<void> togglePauseResumeVoiceRecording() async {
    if (isVoiceRecording.value) {
      await pauseVoiceRecording();
      return;
    }

    if (isVoicePaused.value) {
      await resumeVoiceRecording();
    }
  }

  /// ============================================================
  /// CANCEL VOICE RECORDING
  /// ============================================================

  Future<void> cancelVoiceRecording() async {
    if (!isVoiceRecording.value && !isVoicePaused.value) {
      return;
    }

    try {
      await _voiceRecorder.cancel();
    } catch (error) {
      debugPrint('VOICE RECORDING CANCEL ERROR: $error');
    }

    _resetVoiceState();
    update();
  }

  /// ============================================================
  /// STOP RECORDING AND SEND
  /// ============================================================

  Future<void> stopVoiceRecordingAndSend() async {
    if (!isVoiceRecording.value && !isVoicePaused.value) {
      return;
    }

    if (isVoiceSending.value) {
      return;
    }

    isVoiceSending.value = true;

    final duration = voiceRecordingSeconds.value;
    final recordingConversationId = _recordingConversationId;

    _voiceTimer?.cancel();
    _voiceTimer = null;

    try {
      final audioPath = await _voiceRecorder.stop();

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
    } catch (error) {
      debugPrint('VOICE NOTE SEND ERROR: $error');

      Get.snackbar('Voice Note Error', error.toString());
    } finally {
      _resetVoiceState();

      update();
      scrollToBottom();
    }
  }

  /// ============================================================
  /// ADD VOICE MESSAGE TO A CONVERSATION
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
  /// VOICE RECORDING TIMER
  /// ============================================================

  void _startVoiceTimer() {
    _voiceTimer?.cancel();

    _voiceTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!isVoiceRecording.value) {
        return;
      }

      voiceRecordingSeconds.value++;

      voiceRecordingTime.value = _formatVoiceDuration(
        voiceRecordingSeconds.value,
      );

      if (voiceRecordingSeconds.value >= maxVoiceNoteSeconds) {
        await stopVoiceRecordingAndSend();
        return;
      }

      update();
    });
  }

  /// ============================================================
  /// VOICE AMPLITUDE / WAVEFORM
  /// ============================================================

  void _listenVoiceAmplitude() {
    _amplitudeSub?.cancel();

    _amplitudeSub = _voiceRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 200))
        .listen(
          (amplitude) {
            final normalizedLevel = ((amplitude.current + 45) / 45).clamp(
              0.0,
              1.0,
            );

            voiceLevel.value = normalizedLevel.toDouble();

            update();
          },
          onError: (Object error) {
            debugPrint('VOICE AMPLITUDE ERROR: $error');
          },
        );
  }

  /// ============================================================
  /// RESET VOICE RECORDING STATE
  /// ============================================================

  void _resetVoiceState() {
    _voiceTimer?.cancel();
    _amplitudeSub?.cancel();

    _voiceTimer = null;
    _amplitudeSub = null;

    isVoiceRecording.value = false;
    isVoicePaused.value = false;
    isVoiceSending.value = false;

    voiceRecordingSeconds.value = 0;
    voiceRecordingTime.value = '00:00';
    voiceLevel.value = 0.0;

    _recordingConversationId = null;
  }

  String _formatVoiceDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
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

        update();
        return;
      }

      await voicePlayer.stop();

      playingVoiceMessageId.value = message.id;
      isVoicePlaying.value = false;
      voicePosition.value = Duration.zero;
      voiceDuration.value = Duration(seconds: message.audioDuration ?? 0);

      update();

      if (_isNetworkOrWebAudioPath(audioPath)) {
        await voicePlayer.play(UrlSource(audioPath));
      } else {
        await voicePlayer.play(DeviceFileSource(audioPath));
      }
    } catch (error) {
      debugPrint('VOICE PLAYBACK ERROR: $error');

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
  /// STOP VOICE MESSAGE
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
