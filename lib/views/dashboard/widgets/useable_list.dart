import 'package:elite_csr/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/convo_list.dart';

class UseableList extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  final int count;
  final List<ConversationModel> data;
  final Function(ConversationModel) onTap;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;


  const UseableList({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
    required this.data,
    required this.onTap,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),

        child: ExpansionTile(
          key: ValueKey('$title-$isExpanded'),
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          childrenPadding: EdgeInsets.only(bottom: 12.h),

          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),

          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,

          /// HEADER
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
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: AppTheme.textColor),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      "$count active conversations",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppTheme.textColor),
                    ),
                  ],
                ),
              ),

              Container(
                width: 26.w,
                height: 26.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),

                child: Text(
                  count.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall,
                ),
              ),
            ],
          ),

          /// LIST
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];

                return ListTile(
                  onTap: () => onTap(item),

                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 6.h,
                  ),

                  leading: CircleAvatar(
                    radius: 24.r,
                    backgroundColor: color.withOpacity(0.15),
                    child: item.profile.isNotEmpty
                        ? ClipOval(
                      child: Image.network(
                        item.profile,
                        width: 48.r,
                        height: 48.r,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _fallbackAvatar(item);
                        },
                      ),
                    )
                        : _fallbackAvatar(item),
                  ),

                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ),

                      SizedBox(width: 8.w),

                      Text(
                        item.time,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textColor,
                        ),
                      ),
                    ],
                  ),

                  subtitle: Text(
                    item.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textColor,
                    ),
                  ),

                  trailing: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ],        ),
      ),
    );
  }
}

Widget _fallbackAvatar(ConversationModel item) {
  return Center(
    child: Text(
      item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
  );
}
