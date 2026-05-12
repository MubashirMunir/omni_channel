import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomWidget extends StatelessWidget {
  const BottomWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 55.h,

      padding: EdgeInsets.symmetric(
        horizontal: 18.w,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.08),
          ),
        ),
      ),

      child: Row(
        children: [

          /// PROFILE
          CircleAvatar(
            radius: 18.r,

            backgroundColor:
            Colors.blue.withOpacity(0.1),

            child: Icon(
              Icons.person_outline_rounded,
              color: Colors.blue,
              size: 20.sp,
            ),
          ),

          SizedBox(width: 10.w),

          /// USER INFO
          Column(
            mainAxisAlignment:
            MainAxisAlignment.center,

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(
                "Mubashir",

                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),

              Text(
                "Administrator",

                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),

          const Spacer(),

          /// DATE & TIME
          Column(
            mainAxisAlignment:
            MainAxisAlignment.center,

            crossAxisAlignment:
            CrossAxisAlignment.end,

            children: [

              Text(
                "12 May 2026",

                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                ),
              ),

              Text(
                "09:42 AM",

                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),

          SizedBox(width: 18.w),

          /// LOGOUT
          Container(
            width: 38.w,
            height: 38.w,

            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),

              borderRadius:
              BorderRadius.circular(12.r),
            ),

            child: Icon(
              Icons.logout_rounded,
              color: Colors.red,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}