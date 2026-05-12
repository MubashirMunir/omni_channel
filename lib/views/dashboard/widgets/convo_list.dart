import 'package:elite_csr/views/dashboard/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../theme/theme.dart';
import '../../../widgets/text_widget.dart';

class ConvoPanel extends StatelessWidget {
  final DashboardController ctrl;

  const ConvoPanel({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF5F7FB),

      child: Column(
        children: [
          /// HEADER
          Container(
            padding: EdgeInsets.all(18.w),

            child: Column(
              children: [
                /// LOGO
                Row(
                  children: [
                    Image.asset('assets/images/e.png', height: 40),

                    SizedBox(width: 10.w),

                    TextWidget("Elite CRM", labelLarge: true,color: Colors.black,),

                    const Spacer(),

                    Icon(Icons.menu, color: Colors.grey.shade700),
                  ],
                ),

                SizedBox(height: 18.h),

                /// SEARCH
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search conversations...",

                    prefixIcon: const Icon(Icons.search),

                    filled: true,

                    fillColor: const Color(0xffF5F7FA),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),

                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// FILTER TABS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),

            child: Row(
              children: [
                _topTab(text: "All"),

                SizedBox(width: 10.w),

                _topTab(text: "Unread"),

                SizedBox(width: 10.w),

                _topTab(text: "Assigned"),
              ],
            ),
          ),

          SizedBox(height: 18.h),

          /// CHANNELS
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 14.w),

              children: [
                _buildChannelTile(
                  title: "WhatsApp",
                  color: Colors.green,
                  icon: 'assets/images/social.png',
                  count: 19,
                ),

                SizedBox(height: 14.h),

                _buildChannelTile(
                  title: "Instagram",
                  color: Colors.pink,
                  icon: 'assets/images/instagram.png',
                  count: 8,
                ),

                SizedBox(height: 14.h),

                _buildChannelTile(
                  title: "Messenger",
                  color: Colors.blue,
                  icon: 'assets/images/facebook.png',
                  count: 4,
                ),

                SizedBox(height: 14.h),

                _buildChannelTile(
                  title: "Email",
                  color: Colors.orange,
                  icon: 'assets/images/gmail.png',
                  count: 11,
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ===================================
  /// TOP FILTER TAB
  /// ===================================

  Widget _topTab({required String text}) {
    return Obx(() {
      bool active = ctrl.selectedTab.value == text;

      return GestureDetector(
        onTap: () {
          ctrl.selectedTab.value = text;
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),

          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),

          decoration: BoxDecoration(
            color: active ? AppTheme.primaryColor : Colors.white,

            borderRadius: BorderRadius.circular(30.r),

            border: Border.all(
              color: active
                  ? AppTheme.primaryColor
                  : Colors.grey.withOpacity(0.1),
            ),
          ),

          child: TextWidget(
            text,

            color: active ? Colors.white : Colors.black87,

            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      );
    });
  }

  /// ===================================
  /// CHANNEL TILE
  /// ===================================

  Widget _buildChannelTile({
    required String title,
    required Color color,
    required String icon,
    required int count,
  }) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(22.r),

          border: Border.all(color: Colors.grey.withOpacity(0.08)),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),

          childrenPadding: EdgeInsets.only(bottom: 12.h),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
          ),

          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22.r),
          ),

          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,

          title: Row(
            children: [
              /// CHANNEL ICON
              Container(
                width: 46.w,
                height: 46.w,

                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),

                  borderRadius: BorderRadius.circular(14.r),
                ),

                child: Image.asset(icon, color: color, height: 22.sp),
              ),

              SizedBox(width: 14.w),

              /// TITLE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: TextStyle(
                        fontWeight: FontWeight.w700,

                        fontSize: 14.sp,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    Text(
                      "$count active conversations",

                      style: TextStyle(
                        color: Colors.grey.shade600,

                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),

              /// COUNT
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),

                decoration: BoxDecoration(
                  color: color,

                  borderRadius: BorderRadius.circular(30.r),
                ),

                child: Text(
                  count.toString(),

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          /// CONVERSATIONS
          children: List.generate(4, (index) {
            return ListTile(
              onTap: () {
                ctrl.selectConversation(ctrl.conversations[index]);
              },
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              /// PROFILE
              leading: CircleAvatar(
                radius: 24.r,
                backgroundColor: color.withOpacity(0.15),
                child: Text(
                  "A",
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),

              /// NAME + MESSAGE
              title: Row(
                children: [
                  Expanded(
                    child: TextWidget(
                      "Aisha Ali",

                      overflow: TextOverflow.ellipsis,

                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),

                  Text(
                    "10:30",

                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                  ),
                ],
              ),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  SizedBox(height: 5.h),

                  Text(
                    "Need pricing details...",

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),

                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),

                          borderRadius: BorderRadius.circular(30.r),
                        ),

                        child: TextWidget(
                          title,

                          color: color,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// UNREAD DOT
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
