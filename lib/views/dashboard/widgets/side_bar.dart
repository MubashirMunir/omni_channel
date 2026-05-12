import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideBar extends StatelessWidget {
  const SideBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.w,
      child: Column(
        children: [
          SizedBox(height: 18.h),

          _sideIcon(Icons.call),

          _sideIcon(Icons.person_outline),

          _sideIcon(Icons.lightbulb_outline),

          _sideIcon(Icons.bar_chart),

          const Spacer(),

          Container(
            margin: EdgeInsets.only(bottom: 20.h),
            height: 42.h,
            width: 42.w,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideIcon(IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      height: 50.h,
      width: 50.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(
        icon,

      ),
    );
  }
}
