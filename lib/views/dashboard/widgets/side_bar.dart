import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int selectedIndex = 0;

  final List<IconData> icons = [
    Icons.call,
    Icons.person_outline,
    Icons.lightbulb_outline,
    Icons.bar_chart,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      child: Column(
        children: [
          SizedBox(height: 18.h),

          /// ICONS
          ...List.generate(icons.length, (index) {
            return _sideIcon(
              icon: icons[index],
              isActive: selectedIndex == index,
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
            );
          }),

          const Spacer(),

          /// PROFILE
          Container(
            margin: EdgeInsets.only(bottom: 20.h),
            height: 42.h,
            width: 42.w,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _sideIcon({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),

      child: GestureDetector(
        onTap: onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),

          height: 44.h,
          width: 44.w,

          decoration: BoxDecoration(
            color: isActive
                ? Colors.blue.withOpacity(0.15)
                : Colors.transparent,

            borderRadius: BorderRadius.circular(12.r),
          ),

          child: Icon(
            icon,
            color: isActive ? Colors.blue : Colors.grey,
          ),
        ),
      ),
    );
  }
}