import 'package:elite_csr/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomWidget extends StatelessWidget {
  const BottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,

      padding: EdgeInsets.symmetric(horizontal: 18.w),

      decoration: BoxDecoration(
        // color: Colors.white,

        // border: Border(
        //   top: BorderSide(
        //     color: Colors.grey.withOpacity(0.08),
        //   ),
        // ),
      ),

      child: Row(
        children: [
          /// PROFILE
          CircleAvatar(
            radius: 18.r,

            backgroundColor: Colors.blue.withOpacity(0.1),

            child: Icon(
              Icons.person_outline_rounded,
              color: Colors.blue,
              size: 20.sp,
            ),
          ),

          SizedBox(width: 10.w),

          /// USER INFO
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget("Mubashir", ),
              TextWidget(
                "Administrator",

              ),
            ],
          ),

          const Spacer(),

          /// DATE & TIME
          Column(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              TextWidget(
                "12 May 2026",

              ),

              TextWidget(
                "09:42 AM",

              ),
            ],
          ),

          SizedBox(width: 18.w),

          /// LOGOUT
          Container(
            width: 30.w,
            height: 30.h,

            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),

              borderRadius: BorderRadius.circular(12.r),
            ),

            child: Icon(Icons.logout_rounded, color: Colors.red, size: 18.sp),
          ),
        ],
      ),
    );
  }
}
