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
  State<MessageBubble> createState() =>
      _MessageBubbleState();
}

class _MessageBubbleState
    extends State<MessageBubble> {
  final DashboardController controller =
  Get.find<DashboardController>();

  bool isHover = false;
  bool isMenuOpen = false;

  // ============================================================
  // AUDIO CHECK
  // ============================================================

  bool get _isAudioMessage {
    final audioPath =
        widget.message.audioPath;

    final audioMediaId =
        widget.message.audioMediaId;

    return widget.message.type ==
        MessageType.audio &&
        (
            (audioPath != null &&
                audioPath.trim().isNotEmpty) ||
                (audioMediaId != null &&
                    audioMediaId.trim().isNotEmpty)
        );
  }

  // ============================================================
  // IMAGE CHECK
  // ============================================================

  bool get _isImageMessage {
    final message =
        widget.message;

    return message.type ==
        MessageType.image &&
        (
            (message.imageBytes != null &&
                message.imageBytes!.isNotEmpty) ||
                (message.imageUrl != null &&
                    message.imageUrl!
                        .trim()
                        .isNotEmpty) ||
                (message.imageMediaId != null &&
                    message.imageMediaId!
                        .trim()
                        .isNotEmpty)
        );
  }

  // ============================================================
  // FORMAT AUDIO DURATION
  // ============================================================

  String _formatDuration(
      Duration duration,
      ) {
    final minutes =
        duration.inMinutes;

    final seconds =
        duration.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    final message =
        widget.message;

    final platform =
        widget.platform;

    final bool isWhatsApp =
        platform.toLowerCase() ==
            'whatsapp';

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
            // ==================================================
            // MESSAGE CONTAINER
            // ==================================================

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),

              constraints:
              BoxConstraints(
                maxWidth:
                _isAudioMessage
                    ? 330
                    : _isImageMessage
                    ? 290
                    : 380,

                minWidth:
                _isAudioMessage
                    ? 260
                    : 0,
              ),

              decoration:
              BoxDecoration(
                color: message.isMe
                    ? AppTheme.primaryColor
                    : const Color(
                  0xffF3F6FA,
                ),

                borderRadius:
                BorderRadius.only(
                  topLeft:
                  Radius.circular(
                    AppTheme.radiusSM(
                      context,
                    ),
                  ),

                  topRight:
                  Radius.circular(
                    AppTheme.radiusSM(
                      context,
                    ),
                  ),

                  bottomLeft:
                  Radius.circular(
                    message.isMe
                        ? AppTheme
                        .radiusSM(
                      context,
                    )
                        : 0,
                  ),

                  bottomRight:
                  Radius.circular(
                    message.isMe
                        ? 0
                        : AppTheme
                        .radiusSM(
                      context,
                    ),
                  ),
                ),
              ),

              child: Padding(
                padding:
                EdgeInsets.only(
                  right:
                  message.isMe
                      ? 10
                      : 0,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .end,

                  mainAxisSize:
                  MainAxisSize.min,

                  children: [
                    // ==========================================
                    // AUDIO MESSAGE
                    // ==========================================

                    if (_isAudioMessage)
                      _voiceNotePlayer(
                        context: context,
                        message: message,
                      )

                    // ==========================================
                    // IMAGE MESSAGE
                    // ==========================================

                    else if (_isImageMessage)
                      _imageMessage(
                        context: context,
                        message: message,
                      )

                    // ==========================================
                    // TEXT MESSAGE
                    // ==========================================

                    else
                      TextWidget(
                        message.text,

                        color:
                        message.isMe
                            ? Colors
                            .white
                            : Colors
                            .black,

                        style:
                        Theme.of(
                          context,
                        )
                            .textTheme
                            .bodyMedium,
                      ),

                    const SizedBox(
                      height: 4,
                    ),

                    // ==========================================
                    // TIME + STATUS
                    // ==========================================

                    Row(
                      mainAxisSize:
                      MainAxisSize
                          .min,

                      children: [
                        TextWidget(
                          message.time,

                          style:
                          Theme.of(
                            context,
                          )
                              .textTheme
                              .bodySmall,

                          color:
                          message.isMe
                              ? Colors
                              .white70
                              : AppTheme
                              .textColor,
                        ),

                        if (message
                            .isMe &&
                            isWhatsApp) ...[
                          const SizedBox(
                            width: 4,
                          ),

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

            // ==================================================
            // MESSAGE MENU
            // ==================================================

            if (isHover)
              Positioned(
                top: -8,
                right: -7,

                child:
                PopupMenuButton<
                    String>(
                  padding:
                  EdgeInsets.zero,

                  menuPadding:
                  EdgeInsets.zero,

                  tooltip: '',

                  position:
                  PopupMenuPosition
                      .under,

                  onOpened: () {
                    setState(() {
                      isMenuOpen =
                      true;

                      isHover =
                      true;
                    });
                  },

                  onCanceled: () {
                    setState(() {
                      isMenuOpen =
                      false;

                      isHover =
                      false;
                    });
                  },

                  icon: Icon(
                    Icons
                        .keyboard_arrow_down,

                    size: 25,

                    color:
                    message.isMe
                        ? Colors
                        .white
                        : Colors
                        .black,
                  ),

                  onSelected:
                      (
                      value,
                      ) async {
                    setState(() {
                      isMenuOpen =
                      false;

                      isHover =
                      false;
                    });

                    // =========================================
                    // COPY
                    // =========================================

                    if (value ==
                        'copy') {
                      String copyText;

                      if (_isAudioMessage) {
                        copyText =
                            message
                                .audioPath ??
                                'Voice message';
                      } else if (_isImageMessage) {
                        copyText =
                        message
                            .text
                            .trim()
                            .isNotEmpty
                            ? message
                            .text
                            : 'Photo';
                      } else {
                        copyText =
                            message
                                .text;
                      }

                      await Clipboard
                          .setData(
                        ClipboardData(
                          text:
                          copyText,
                        ),
                      );
                    }

                    // =========================================
                    // REPLY
                    // =========================================

                    if (value ==
                        'reply') {
                      // Reply logic here
                    }

                    // =========================================
                    // DELETE
                    // =========================================

                    if (value ==
                        'delete') {
                      // Delete logic here
                    }
                  },

                  itemBuilder:
                      (
                      context,
                      ) =>
                  const [
                    PopupMenuItem(
                      value:
                      'reply',
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .arrow_back,
                            size: 15,
                          ),

                          SizedBox(
                            width: 6,
                          ),

                          Text(
                            'Reply',
                          ),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value:
                      'copy',
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .copy_rounded,
                            size: 15,
                          ),

                          SizedBox(
                            width: 6,
                          ),

                          Text(
                            'Copy',
                          ),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value:
                      'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons
                                .delete,
                            size: 15,
                          ),

                          SizedBox(
                            width: 6,
                          ),

                          Text(
                            'Delete',
                          ),
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

  // ============================================================
  // IMAGE MESSAGE
  // ============================================================

  Widget _imageMessage({
    required BuildContext context,
    required MessageModel message,
  }) {
    return Column(
      mainAxisSize:
      MainAxisSize.min,

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [
        // ======================================================
        // LOCAL IMAGE
        // ======================================================

        if (message.imageBytes != null &&
            message.imageBytes!.isNotEmpty)
          GestureDetector(
            onTap: () {
              _openImagePreview(
                bytes:
                message.imageBytes,
              );
            },

            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(
                10,
              ),

              child: Image.memory(
                message.imageBytes!,

                width: 260,

                height: 220,

                fit: BoxFit.cover,

                gaplessPlayback:
                true,

                errorBuilder:
                    (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return _imageErrorWidget();
                },
              ),
            ),
          )

        // ======================================================
        // SERVER IMAGE
        // ======================================================

        else if (message.imageUrl !=
            null &&
            message.imageUrl!
                .trim()
                .isNotEmpty)
          GestureDetector(
            onTap: () {
              _openImagePreview(
                imageUrl:
                message.imageUrl,
              );
            },

            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(
                10,
              ),

              child: Image.network(
                message.imageUrl!,

                width: 260,

                height: 220,

                fit: BoxFit.cover,

                loadingBuilder:
                    (
                    context,
                    child,
                    loadingProgress,
                    ) {
                  if (loadingProgress ==
                      null) {
                    return child;
                  }

                  return Container(
                    width: 260,
                    height: 220,

                    alignment:
                    Alignment
                        .center,

                    child:
                    const SizedBox(
                      width: 25,
                      height: 25,

                      child:
                      CircularProgressIndicator(
                        strokeWidth:
                        2,
                      ),
                    ),
                  );
                },

                errorBuilder:
                    (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return _imageErrorWidget();
                },
              ),
            ),
          )

        // ======================================================
        // ONLY MEDIA ID AVAILABLE
        // ======================================================

        else
          _imageErrorWidget(),

        // ======================================================
        // IMAGE CAPTION
        // ======================================================

        if (message.text
            .trim()
            .isNotEmpty) ...[
          const SizedBox(
            height: 7,
          ),

          Padding(
            padding:
            const EdgeInsets
                .symmetric(
              horizontal: 2,
            ),

            child: TextWidget(
              message.text,

              color:
              message.isMe
                  ? Colors.white
                  : Colors.black,

              style:
              Theme.of(
                context,
              )
                  .textTheme
                  .bodyMedium,
            ),
          ),
        ],
      ],
    );
  }

  // ============================================================
  // IMAGE ERROR
  // ============================================================

  Widget _imageErrorWidget() {
    return Container(
      width: 260,
      height: 180,

      alignment:
      Alignment.center,

      decoration:
      BoxDecoration(
        color:
        Colors.black.withOpacity(
          0.08,
        ),

        borderRadius:
        BorderRadius.circular(
          10,
        ),
      ),

      child: const Column(
        mainAxisSize:
        MainAxisSize.min,

        children: [
          Icon(
            Icons
                .broken_image_outlined,

            size: 35,

            color:
            Colors.grey,
          ),

          SizedBox(
            height: 5,
          ),

          Text(
            'Image unavailable',

            style:
            TextStyle(
              fontSize: 11,

              color:
              Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FULL SCREEN IMAGE PREVIEW
  // ============================================================

  void _openImagePreview({
    Uint8List? bytes,
    String? imageUrl,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor:
        Colors.transparent,

        insetPadding:
        const EdgeInsets.all(
          20,
        ),

        child: Stack(
          children: [
            Container(
              constraints:
              const BoxConstraints(
                maxWidth: 900,
                maxHeight: 700,
              ),

              decoration:
              BoxDecoration(
                color:
                Colors.black,

                borderRadius:
                BorderRadius
                    .circular(
                  12,
                ),
              ),

              child: Center(
                child:
                InteractiveViewer(
                  minScale:
                  0.5,

                  maxScale:
                  5,

                  child:
                  bytes != null
                      ? Image
                      .memory(
                    bytes,

                    fit:
                    BoxFit
                        .contain,
                  )
                      : imageUrl !=
                      null &&
                      imageUrl
                          .trim()
                          .isNotEmpty
                      ? Image
                      .network(
                    imageUrl,

                    fit:
                    BoxFit
                        .contain,
                  )
                      : const SizedBox
                      .shrink(),
                ),
              ),
            ),

            Positioned(
              top: 10,
              right: 10,

              child:
              IconButton(
                onPressed:
                    () {
                  Get.back();
                },

                style:
                IconButton
                    .styleFrom(
                  backgroundColor:
                  Colors.black54,
                ),

                icon:
                const Icon(
                  Icons
                      .close_rounded,

                  color:
                  Colors.white,

                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),

      barrierColor:
      Colors.black87,
    );
  }

  // ============================================================
  // VOICE NOTE PLAYER
  // ============================================================

  Widget _voiceNotePlayer({
    required BuildContext context,
    required MessageModel message,
  }) {
    return Obx(() {
      final String?
      activeMessageId =
          controller
              .playingVoiceMessageId
              .value;

      final bool
      isCurrentMessage =
          activeMessageId ==
              message.id;

      final bool
      isPlaying =
          isCurrentMessage &&
              controller
                  .isVoicePlaying
                  .value;

      final Duration position =
      isCurrentMessage
          ? controller
          .voicePosition
          .value
          : Duration.zero;

      final Duration
      playerDuration =
      isCurrentMessage
          ? controller
          .voiceDuration
          .value
          : Duration.zero;

      final int
      savedDurationMilliseconds =
          (message.audioDuration ??
              0) *
              1000;

      final int
      totalMilliseconds =
      playerDuration
          .inMilliseconds >
          0
          ? playerDuration
          .inMilliseconds
          : savedDurationMilliseconds;

      final int
      safeTotalMilliseconds =
      totalMilliseconds > 0
          ? totalMilliseconds
          : 1000;

      final double
      currentValue =
      position
          .inMilliseconds
          .clamp(
        0,
        safeTotalMilliseconds,
      )
          .toDouble();

      final Color
      iconColor =
      message.isMe
          ? AppTheme
          .primaryColor
          : Colors.white;

      final Color
      iconBgColor =
      message.isMe
          ? Colors.white
          : AppTheme
          .primaryColor;

      final Color
      sliderActiveColor =
      message.isMe
          ? Colors.white
          : AppTheme
          .primaryColor;

      final Color
      sliderInactiveColor =
      message.isMe
          ? Colors.white24
          : Colors.black12;

      return Row(
        mainAxisSize:
        MainAxisSize.min,

        children: [
          // ====================================================
          // PLAY / PAUSE
          // ====================================================

          InkWell(
            onTap:
                () async {
              await controller
                  .toggleVoiceMessage(
                message,
              );
            },

            borderRadius:
            BorderRadius.circular(
              100,
            ),

            child:
            CircleAvatar(
              radius: 18,

              backgroundColor:
              iconBgColor,

              child: Icon(
                isPlaying
                    ? Icons
                    .pause_rounded
                    : Icons
                    .play_arrow_rounded,

                color:
                iconColor,

                size: 24,
              ),
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          // ====================================================
          // SLIDER + TIME
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,

              children: [
                SliderTheme(
                  data:
                  SliderTheme.of(
                    context,
                  ).copyWith(
                    trackHeight: 3,

                    thumbShape:
                    const RoundSliderThumbShape(
                      enabledThumbRadius:
                      5,
                    ),

                    overlayShape:
                    const RoundSliderOverlayShape(
                      overlayRadius:
                      10,
                    ),
                  ),

                  child: Slider(
                    min: 0,

                    max:
                    safeTotalMilliseconds
                        .toDouble(),

                    value:
                    currentValue,

                    activeColor:
                    sliderActiveColor,

                    inactiveColor:
                    sliderInactiveColor,

                    onChanged:
                    isCurrentMessage
                        ? (
                        value,
                        ) {
                      controller
                          .seekVoiceMessage(
                        messageId:
                        message
                            .id,

                        seconds:
                        value /
                            1000,
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

                  style:
                  Theme.of(
                    context,
                  )
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                    message.isMe
                        ? Colors
                        .white70
                        : AppTheme
                        .textColor,

                    fontSize:
                    11,
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

// ============================================================
// MESSAGE STATUS ICON
// ============================================================

Widget _messageStatusIcon(
    MessageStatus status,
    ) {
  switch (status) {
    case MessageStatus.sending:
      return const Icon(
        Icons
            .access_time_rounded,

        size: 14,

        color:
        Colors.white70,
      );

    case MessageStatus.sent:
      return const Icon(
        Icons.done,

        size: 15,

        color:
        Colors.white70,
      );

    case MessageStatus.delivered:
      return const Icon(
        Icons.done_all,

        size: 15,

        color:
        Colors.white70,
      );

    case MessageStatus.read:
      return const Icon(
        Icons.done_all,

        size: 15,

        color:
        Colors.lightBlueAccent,
      );

    case MessageStatus.failed:
      return const Icon(
        Icons
            .error_outline,

        size: 15,

        color:
        Colors.redAccent,
      );
  }
}