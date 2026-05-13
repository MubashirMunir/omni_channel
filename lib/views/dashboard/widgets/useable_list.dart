import 'package:elite_csr/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/convo_list.dart';

class UseableList extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final Color color;
  final int count;
  final List<ConversationModel> data;
  final Function(ConversationModel) onTap;

  const UseableList({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.count,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),

        child: ExpansionTile(
          childrenPadding: EdgeInsets.only(bottom: 12.h),

          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
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
                    TextWidget(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: Colors.black),
                    ),

                    SizedBox(height: 4.h),

                    TextWidget(
                      "$count active conversations",
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),

              Container(
                width: 26.w,
                height: 26.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),

                child: Text(
                  count.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),

          /// LIST
          children: List.generate(data.length, (index) {
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

                child: (item.profile.isNotEmpty)
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
                    child: TextWidget(
                      item.name,
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: Colors.black),
                    ),
                  ),

                  Text(
                    item.time,
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                  ),
                ],
              ),

              subtitle: Text(
                item.message,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey, fontSize: 11.sp),
              ),

              trailing: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            );
          }),
        ),
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
