import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/theme.dart';
import '../../../widgets/text_widget.dart';

Widget _topBar() {
  return Container(
    height: 70.h,
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.withOpacity(0.08),
        ),
      ),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 22.r,
          backgroundColor:
          AppTheme.primaryColor.withOpacity(0.1),
          child: Icon(
            Icons.person,
            color: AppTheme.primaryColor,
          ),
        ),

        SizedBox(width: 14.w),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              "No Chat Selected",
              labelLarge: true,
            ),

            SizedBox(height: 4.h),

            Text(
              "Select conversation to start messaging",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
