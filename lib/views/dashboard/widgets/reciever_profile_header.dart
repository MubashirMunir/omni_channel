import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OmniChannelProfileHeader extends StatelessWidget {
  final String name;
  final String? profileUrl;
  final String statusText;

  final bool isOnline;
  final bool isCompact;

  final double horizontalPadding;
  final Color primaryColor;

  final VoidCallback? onAudioCall;
  final VoidCallback? onVideoCall;
  final VoidCallback? onViewProfile;
  final VoidCallback? onMuteConversation;
  final VoidCallback? onCloseConversation;

  const OmniChannelProfileHeader({
    super.key,
    required this.name,
    this.profileUrl,
    this.statusText = 'Online • Available',
    this.isOnline = true,
    this.isCompact = false,
    this.horizontalPadding = 16,
    required this.primaryColor,
    this.onAudioCall,
    this.onVideoCall,
    this.onViewProfile,
    this.onMuteConversation,
    this.onCloseConversation,
  });

  @override
  Widget build(BuildContext context) {
    final String displayName =
    name.trim().isNotEmpty ? name.trim() : 'Unknown User';

    final String imageUrl = profileUrl?.trim() ?? '';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isCompact ? 11 : 15,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.12),
            Colors.white,
            primaryColor.withOpacity(0.04),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: primaryColor.withOpacity(0.12),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _ProfileAvatar(
            name: displayName,
            profileUrl: imageUrl,
            isOnline: isOnline,
            isCompact: isCompact,
            primaryColor: primaryColor,
          ),

          SizedBox(width: isCompact ? 10 : 13),

          Expanded(
            child: _ProfileInformation(
              name: displayName,
              statusText: statusText,
              isOnline: isOnline,
              isCompact: isCompact,
            ),
          ),

          SizedBox(width: isCompact ? 6 : 10),

          if (onAudioCall != null) ...[
            _HeaderActionButton(
              icon: Icons.call_rounded,
              tooltip: 'Audio Call',
              isCompact: isCompact,
              primaryColor: primaryColor,
              onPressed: onAudioCall!,
            ),
            SizedBox(width: isCompact ? 5 : 8),
          ],

          if (onVideoCall != null) ...[
            _HeaderActionButton(
              icon: Icons.videocam_rounded,
              tooltip: 'Video Call',
              isCompact: isCompact,
              primaryColor: primaryColor,
              onPressed: onVideoCall!,
            ),
            SizedBox(width: isCompact ? 4 : 7),
          ],

          _MoreOptionsButton(
            isCompact: isCompact,
            onViewProfile: onViewProfile,
            onMuteConversation: onMuteConversation,
            onCloseConversation: onCloseConversation,
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String name;
  final String profileUrl;
  final bool isOnline;
  final bool isCompact;
  final Color primaryColor;

  const _ProfileAvatar({
    required this.name,
    required this.profileUrl,
    required this.isOnline,
    required this.isCompact,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final double radius = isCompact ? 21.r : 24.r;
    final double imageSize = radius * 2;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryColor.withOpacity(0.28),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: primaryColor.withOpacity(0.12),
            child: profileUrl.isNotEmpty
                ? ClipOval(
              child: Image.network(
                profileUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _FallbackAvatar(
                    name: name,
                    primaryColor: primaryColor,
                  );
                },
              ),
            )
                : _FallbackAvatar(
              name: name,
              primaryColor: primaryColor,
            ),
          ),
        ),

        Positioned(
          right: 1,
          bottom: 1,
          child: Container(
            width: isCompact ? 11 : 13,
            height: isCompact ? 11 : 13,
            decoration: BoxDecoration(
              color: isOnline
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF9CA3AF),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FallbackAvatar extends StatelessWidget {
  final String name;
  final Color primaryColor;

  const _FallbackAvatar({
    required this.name,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: primaryColor.withOpacity(0.10),
      child: Text(
        _getInitials(name),
        style: TextStyle(
          color: primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _getInitials(String value) {
    final words = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) {
      return '?';
    }

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

class _ProfileInformation extends StatelessWidget {
  final String name;
  final String statusText;
  final bool isOnline;
  final bool isCompact;

  const _ProfileInformation({
    required this.name,
    required this.statusText,
    required this.isOnline,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isOnline
        ? const Color(0xFF22C55E)
        : const Color(0xFF9CA3AF);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: isCompact ? 13 : 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF172033),
            letterSpacing: 0.1,
          ),
        ),
        SizedBox(height: isCompact ? 2 : 4),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                statusText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: isCompact ? 10.5 : 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isCompact;
  final Color primaryColor;
  final VoidCallback onPressed;

  const _HeaderActionButton({
    required this.icon,
    required this.tooltip,
    required this.isCompact,
    required this.primaryColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double size = isCompact ? 35 : 40;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColor.withOpacity(0.15),
              ),
            ),
            child: Icon(
              icon,
              size: isCompact ? 18 : 20,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _MoreOptionsButton extends StatelessWidget {
  final bool isCompact;
  final VoidCallback? onViewProfile;
  final VoidCallback? onMuteConversation;
  final VoidCallback? onCloseConversation;

  const _MoreOptionsButton({
    required this.isCompact,
    this.onViewProfile,
    this.onMuteConversation,
    this.onCloseConversation,
  });

  @override
  Widget build(BuildContext context) {
    final double size = isCompact ? 35 : 40;

    return PopupMenuButton<_HeaderMenuAction>(
      tooltip: 'More Options',
      color: Colors.white,
      elevation: 8,
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      onSelected: (action) {
        switch (action) {
          case _HeaderMenuAction.viewProfile:
            onViewProfile?.call();
            break;

          case _HeaderMenuAction.muteConversation:
            onMuteConversation?.call();
            break;

          case _HeaderMenuAction.closeConversation:
            onCloseConversation?.call();
            break;
        }
      },
      itemBuilder: (context) {
        return [
          if (onViewProfile != null)
            const PopupMenuItem(
              value: _HeaderMenuAction.viewProfile,
              child: _MenuItemContent(
                icon: Icons.person_outline_rounded,
                title: 'View Profile',
              ),
            ),

          if (onMuteConversation != null)
            const PopupMenuItem(
              value: _HeaderMenuAction.muteConversation,
              child: _MenuItemContent(
                icon: Icons.notifications_off_outlined,
                title: 'Mute Conversation',
              ),
            ),

          if (onCloseConversation != null)
            const PopupMenuItem(
              value: _HeaderMenuAction.closeConversation,
              child: _MenuItemContent(
                icon: Icons.check_circle_outline_rounded,
                title: 'Close Conversation',
              ),
            ),
        ];
      },
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.16),
          ),
        ),
        child: Icon(
          Icons.more_vert_rounded,
          size: isCompact ? 19 : 21,
          color: const Color(0xFF536078),
        ),
      ),
    );
  }
}

class _MenuItemContent extends StatelessWidget {
  final IconData icon;
  final String title;

  const _MenuItemContent({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF536078),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

enum _HeaderMenuAction {
  viewProfile,
  muteConversation,
  closeConversation,
}