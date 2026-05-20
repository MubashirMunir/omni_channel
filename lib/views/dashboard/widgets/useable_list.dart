import 'package:elite_csr/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/convo_list.dart';

class UseableList<T> extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  final int count;
  final List<T> data;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;

  const UseableList({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
    required this.data,
    required this.itemBuilder,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
        child: ExpansionTile(
          key: ValueKey('$title-$isExpanded'),
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,

          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),

          collapsedBackgroundColor:
              Theme.of(context).brightness == Brightness.dark
              ? AppTheme.textColor
              : AppTheme.white,

          title: Row(
            children: [
              Container(
                width: 35.w,
                height: 35.w,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Image.asset(icon),
              ),

              SizedBox(width: 14.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.bodyLarge),
                    SizedBox(height: 4.h),
                    Text(
                      "$count active conversations",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Text(
                  count.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.black),
                ),
              ),
            ],
          ),

          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return itemBuilder(context, item);
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
