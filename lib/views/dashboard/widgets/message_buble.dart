import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../models/message_model.dart';
import '../../../theme/theme.dart';
import '../../../widgets/text_widget.dart';
import '../controller.dart';

class MessageBubble extends StatefulWidget {
  final MessageModel message;
  final String platform;

  const MessageBubble({
    super.key,
    required this.message,
    required this.platform,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  final DashboardController controller =
  Get.find<DashboardController>();

  bool isHover = false;
  bool isMenuOpen = false;

  bool get _isAudioMessage {
    final audioPath = widget.message.audioPath;

    return widget.message.type == MessageType.audio &&
        audioPath != null &&
        audioPath.trim().isNotEmpty;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    final platform = widget.platform;

    final bool isWhatsApp =
        platform.toLowerCase() == 'whatsapp';

    return Align(
      alignment: message.isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (_) {
          if (!isMenuOpen) {
            setState(() {
              isHover = false;
            });
          }
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              constraints: BoxConstraints(
                maxWidth: _isAudioMessage ? 330 : 380,
                minWidth: _isAudioMessage ? 260 : 0,
              ),
              decoration: BoxDecoration(
                color: message.isMe
                    ? AppTheme.primaryColor
                    : const Color(0xffF3F6FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    AppTheme.radiusSM(context),
                  ),
                  topRight: Radius.circular(
                    AppTheme.radiusSM(context),
                  ),
                  bottomLeft: Radius.circular(
                    message.isMe
                        ? AppTheme.radiusSM(context)
                        : 0,
                  ),
                  bottomRight: Radius.circular(
                    message.isMe
                        ? 0
                        : AppTheme.radiusSM(context),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  right: message.isMe ? 10 : 0,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    if (_isAudioMessage)
                      _voiceNotePlayer(
                        context: context,
                        message: message,
                      )
                    else
                      TextWidget(
                        message.text,
                        color: message.isMe
                            ? Colors.white
                            : Colors.black,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium,
                      ),

                    const SizedBox(height: 4),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidget(
                          message.time,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall,
                          color: message.isMe
                              ? Colors.white70
                              : AppTheme.textColor,
                        ),

                        if (message.isMe &&
                            isWhatsApp) ...[
                          const SizedBox(width: 4),
                          _messageStatusIcon(
                            message.status,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (isHover)
              Positioned(
                top: -8,
                right: -7,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  menuPadding: EdgeInsets.zero,
                  tooltip: '',
                  position: PopupMenuPosition.under,
                  onOpened: () {
                    setState(() {
                      isMenuOpen = true;
                      isHover = true;
                    });
                  },
                  onCanceled: () {
                    setState(() {
                      isMenuOpen = false;
                      isHover = false;
                    });
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    size: 25,
                    color: message.isMe
                        ? Colors.white
                        : Colors.black,
                  ),
                  onSelected: (value) async {
                    setState(() {
                      isMenuOpen = false;
                      isHover = false;
                    });

                    if (value == 'copy') {
                      await Clipboard.setData(
                        ClipboardData(
                          text: _isAudioMessage
                              ? message.audioPath ??
                              'Voice message'
                              : message.text,
                        ),
                      );
                    }

                    if (value == 'reply') {
                      // Reply logic
                    }

                    if (value == 'delete') {
                      // Delete logic
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'reply',
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 15,
                          ),
                          SizedBox(width: 6),
                          Text('Reply'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'copy',
                      child: Row(
                        children: [
                          Icon(
                            Icons.copy_rounded,
                            size: 15,
                          ),
                          SizedBox(width: 6),
                          Text('Copy'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            size: 15,
                          ),
                          SizedBox(width: 6),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _voiceNotePlayer({
    required BuildContext context,
    required MessageModel message,
  }) {
    return Obx(() {
      /*
       * These reactive values are read directly inside Obx.
       * Whenever any of them changes, this voice-note UI rebuilds.
       */
      final String? activeMessageId =
          controller.playingVoiceMessageId.value;

      final bool isCurrentMessage =
          activeMessageId == message.id;

      final bool isPlaying =
          isCurrentMessage &&
              controller.isVoicePlaying.value;

      final Duration position = isCurrentMessage
          ? controller.voicePosition.value
          : Duration.zero;

      final Duration playerDuration = isCurrentMessage
          ? controller.voiceDuration.value
          : Duration.zero;

      /*
       * Use the duration received from AudioPlayer.
       * Before AudioPlayer loads it, use message.audioDuration.
       */
      final int savedDurationMilliseconds =
          (message.audioDuration ?? 0) * 1000;

      final int totalMilliseconds =
      playerDuration.inMilliseconds > 0
          ? playerDuration.inMilliseconds
          : savedDurationMilliseconds;

      final int safeTotalMilliseconds =
      totalMilliseconds > 0
          ? totalMilliseconds
          : 1000;

      final double currentValue =
      position.inMilliseconds
          .clamp(
        0,
        safeTotalMilliseconds,
      )
          .toDouble();

      final Color iconColor = message.isMe
          ? AppTheme.primaryColor
          : Colors.white;

      final Color iconBgColor = message.isMe
          ? Colors.white
          : AppTheme.primaryColor;

      final Color sliderActiveColor = message.isMe
          ? Colors.white
          : AppTheme.primaryColor;

      final Color sliderInactiveColor = message.isMe
          ? Colors.white24
          : Colors.black12;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              await controller.toggleVoiceMessage(
                message,
              );
            },
            borderRadius: BorderRadius.circular(100),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: iconBgColor,
              child: Icon(
                isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                color: iconColor,
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape:
                    const RoundSliderThumbShape(
                      enabledThumbRadius: 5,
                    ),
                    overlayShape:
                    const RoundSliderOverlayShape(
                      overlayRadius: 10,
                    ),
                  ),
                  child: Slider(
                    min: 0,
                    max:
                    safeTotalMilliseconds.toDouble(),
                    value: currentValue,
                    activeColor: sliderActiveColor,
                    inactiveColor:
                    sliderInactiveColor,
                    onChanged: isCurrentMessage
                        ? (value) {
                      controller.seekVoiceMessage(
                        messageId: message.id,
                        seconds: value / 1000,
                      );
                    }
                        : null,
                  ),
                ),

                Text(
                  '${_formatDuration(position)} / '
                      '${_formatDuration(
                    Duration(
                      milliseconds:
                      safeTotalMilliseconds,
                    ),
                  )}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: message.isMe
                        ? Colors.white70
                        : AppTheme.textColor,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

Widget _messageStatusIcon(
    MessageStatus status,
    ) {
  switch (status) {
    case MessageStatus.sending:
      return const Icon(
        Icons.access_time_rounded,
        size: 14,
        color: Colors.white70,
      );

    case MessageStatus.sent:
      return const Icon(
        Icons.done,
        size: 15,
        color: Colors.white70,
      );

    case MessageStatus.delivered:
      return const Icon(
        Icons.done_all,
        size: 15,
        color: Colors.white70,
      );

    case MessageStatus.read:
      return const Icon(
        Icons.done_all,
        size: 15,
        color: Colors.lightBlueAccent,
      );

    case MessageStatus.failed:
      return const Icon(
        Icons.error_outline,
        size: 15,
        color: Colors.redAccent,
      );
  }
}