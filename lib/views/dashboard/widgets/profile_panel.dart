import 'package:elite_csr/widgets/btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/theme.dart';
import '../../../widgets/text_widget.dart';

class ProfilePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      child: Column(
        children: [
          Container(
            height: 70.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.08)),
              ),
            ),
            child: Row(
              children: [
                TextWidget(
                  "Profile",
                  style: Theme.of(context).textTheme.labelLarge,
                ),

                SizedBox(width: 24.w),

                Text(
                  "Calling List",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10.w),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Profile...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xffF5F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const Spacer(),

          Icon(
            Icons.account_circle_outlined,
            size: 120.sp,
            color: AppTheme.primaryColor.withOpacity(0.2),
          ),

          SizedBox(height: 20.h),

          Text(
            "View your contacts here",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
          ),

          SizedBox(height: 10.h),

          Text(
            "Start by searching or creating a new contact",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp),
          ),

          SizedBox(height: 24.h),

          CustomButton(width: 150.w, onPressed: () {}, text: "Create Contact"),

          const Spacer(),
        ],
      ),
    );
  }
}
