import 'package:elite_csr/theme/theme.dart';
import 'package:elite_csr/views/gmail/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/convo_list.dart';


Widget conversationTile({
  required BuildContext context,
  required ConversationModel item,
  required Color color,
  required VoidCallback onTap,
}) {
  return ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 6.h),
    leading: CircleAvatar(
      radius: 20,
      backgroundColor: color.withOpacity(0.15),
      child: item.profile.isNotEmpty
          ? ClipOval(
              child: Image.network(
                item.profile,
                width: 48.r,
                height: 48.r,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return fallbackConversationAvatar(item, context);
                },
              ),
            )
          : fallbackConversationAvatar(item, context),
    ),
    title: Row(
      children: [
        Expanded(
          child: Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(width: 8.w),
        Text(item.time, style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
    subtitle: Text(
      item.message,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall,
    ),
    trailing: Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ),
  );
}

Widget fallbackConversationAvatar(
  ConversationModel item,
  BuildContext context,
) {
  return Center(
    child: Text(
      item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
      style: Theme.of(context).textTheme.bodyMedium,
    ),
  );
}

///     social btn he bhai he
class SocialChannelButton extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  final int count;
  final bool isSelected;
  final VoidCallback onPressed;
  final VoidCallback? onAddPressed;

  const SocialChannelButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
    required this.isSelected,
    required this.onPressed,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: title,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: IconButton(
              onPressed: onPressed,
              padding: const EdgeInsets.all(12),
              icon: Image.asset(
                icon,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Conversation count
          if (count > 0)
            Positioned(
              top: -7,
              right: -7,
              child: Container(
                constraints: const BoxConstraints(minWidth: 21, minHeight: 21),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
                child: Text(
                  count > 99 ? "99+" : count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Optional plus button, Gmail compose ke liye
          if (onAddPressed != null)
            Positioned(
              bottom: -5,
              right: -5,
              child: InkWell(
                onTap: onAddPressed,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 21,
                  height: 21,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: const Icon(Icons.add, size: 14, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
