import 'package:elite_csr/theme/theme.dart';
import 'package:elite_csr/views/gmail/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/convo_list.dart';
import '../../gmail/widgets/compose_dialog.dart';

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
      child: ExpansionTile(
        leading: icon == 'assets/images/gmail.png'
            ? SizedBox(width: 20,height: 25,
              child: IconButton(
                        onPressed: () {    showComposeDialog(GmailController()); },
                        icon: Icon(Icons.add, ), // 👈 icon ka size

                        style: ButtonStyle(
              // backgroundColor: MaterialStateProperty.all(Colors.blue),

              fixedSize: MaterialStateProperty.all(Size(20, 20)), // 👈 button ka size

              padding: MaterialStateProperty.all(EdgeInsets.zero), // 👈 extra space hatao

              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
                        ),
                      ),
            )
            : SizedBox(),
        key: ValueKey('$title-$isExpanded'),
        initiallyExpanded: isExpanded,
        onExpansionChanged: onExpansionChanged,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        internalAddSemanticForOnTap: true,
        collapsedBackgroundColor:
            Theme.of(context).brightness == Brightness.dark
            ? AppTheme.textColor
            : AppTheme.white,

        title: Row(
          children: [
            Image.asset(icon, height: 30),

            SizedBox(width: 15.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge),
                  Text(
                    "$count conversations",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(8),
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
