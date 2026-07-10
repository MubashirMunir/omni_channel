import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/message_model.dart';
import '../../../theme/theme.dart';
import '../../../widgets/text_widget.dart';

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
  bool isHover = false;
  bool isMenuOpen = false;

  final AudioPlayer _audioPlayer = AudioPlayer();

  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<void>? _completeSub;

  bool get isPlaying => _playerState == PlayerState.playing;

  @override
  void initState() {
    super.initState();

    if (widget.message.type == MessageType.audio) {
      _duration = Duration(seconds: widget.message.audioDuration ?? 0);
      _listenAudioPlayer();
    }
  }

  void _listenAudioPlayer() {
    _stateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _playerState = state;
      });
    });

    _positionSub = _audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() {
        _position = position;
      });
    });

    _durationSub = _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() {
        _duration = duration;
      });
    });

    _completeSub = _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() {
        _position = Duration.zero;
        _playerState = PlayerState.stopped;
      });
    });
  }

  Future<void> _toggleAudio() async {
    final audioPath = widget.message.audioPath;

    if (audioPath == null || audioPath.trim().isEmpty) {
      debugPrint("Audio path empty");
      return;
    }

    try {
      if (isPlaying) {
        await _audioPlayer.pause();
        return;
      }

      if (_position > Duration.zero && _position < _duration) {
        await _audioPlayer.resume();
        return;
      }

      if (kIsWeb ||
          audioPath.startsWith("http") ||
          audioPath.startsWith("blob:")) {
        await _audioPlayer.play(UrlSource(audioPath));
      } else {
        await _audioPlayer.play(DeviceFileSource(audioPath));
      }
    } catch (e) {
      debugPrint("Audio play error: $e");
    }
  }

  Future<void> _seekAudio(double value) async {
    await _audioPlayer.seek(Duration(seconds: value.toInt()));
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  bool get _isAudioMessage {
    return widget.message.type == MessageType.audio &&
        widget.message.audioPath != null &&
        widget.message.audioPath!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    final platform = widget.platform;
    final bool isWhatsApp = platform.toLowerCase() == "whatsapp";

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: _isAudioMessage ? 330 : 380,
                minWidth: _isAudioMessage ? 260 : 0,
              ),
              decoration: BoxDecoration(
                color: message.isMe
                    ? AppTheme.primaryColor
                    : const Color(0xffF3F6FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusSM(context)),
                  topRight: Radius.circular(AppTheme.radiusSM(context)),
                  bottomLeft: Radius.circular(
                    message.isMe ? AppTheme.radiusSM(context) : 0,
                  ),
                  bottomRight: Radius.circular(
                    message.isMe ? 0 : AppTheme.radiusSM(context),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: message.isMe ? 10 : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_isAudioMessage)
                      _voiceNotePlayer(context, message)
                    else
                      TextWidget(
                        message.text,
                        color: message.isMe ? Colors.white : Colors.black,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                    const SizedBox(height: 4),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextWidget(
                          message.time,
                          style: Theme.of(context).textTheme.bodySmall,
                          color: message.isMe
                              ? Colors.white70
                              : AppTheme.textColor,
                        ),

                        if (message.isMe && isWhatsApp) ...[
                          const SizedBox(width: 4),
                          _messageStatusIcon(message.status),
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
                  tooltip: "",
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
                    color: message.isMe ? Colors.white : Colors.black,
                  ),
                  onSelected: (value) async {
                    setState(() {
                      isMenuOpen = false;
                      isHover = false;
                    });

                    if (value == "copy") {
                      await Clipboard.setData(
                        ClipboardData(
                          text: _isAudioMessage
                              ? message.audioPath ?? "Voice message"
                              : message.text,
                        ),
                      );
                    }

                    if (value == "reply") {
                      // reply logic
                    }

                    if (value == "delete") {
                      // delete logic
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: "reply",
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back, size: 15),
                          SizedBox(width: 6),
                          Text("Reply"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "copy",
                      child: Row(
                        children: [
                          Icon(Icons.copy_rounded, size: 15),
                          SizedBox(width: 6),
                          Text("Copy"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 15),
                          SizedBox(width: 6),
                          Text("Delete"),
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

  Widget _voiceNotePlayer(BuildContext context, MessageModel message) {
    final totalSeconds = _duration.inSeconds <= 0
        ? (message.audioDuration ?? 1)
        : _duration.inSeconds;

    final safeTotalSeconds = totalSeconds <= 0 ? 1 : totalSeconds;
    final currentSeconds = _position.inSeconds.clamp(0, safeTotalSeconds);

    final iconColor = message.isMe ? AppTheme.primaryColor : Colors.white;
    final iconBgColor = message.isMe ? Colors.white : AppTheme.primaryColor;
    final sliderActiveColor = message.isMe ? Colors.white : AppTheme.primaryColor;
    final sliderInactiveColor =
    message.isMe ? Colors.white24 : Colors.black12;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: _toggleAudio,
          borderRadius: BorderRadius.circular(100),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: iconBgColor,
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: iconColor,
              size: 24,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 10,
                  ),
                ),
                child: Slider(
                  min: 0,
                  max: safeTotalSeconds.toDouble(),
                  value: currentSeconds.toDouble(),
                  activeColor: sliderActiveColor,
                  inactiveColor: sliderInactiveColor,
                  onChanged: _seekAudio,
                ),
              ),

              Text(
                "${_formatDuration(_position)} / ${_formatDuration(Duration(seconds: safeTotalSeconds))}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: message.isMe ? Colors.white70 : AppTheme.textColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _completeSub?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}

Widget _messageStatusIcon(MessageStatus status) {
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