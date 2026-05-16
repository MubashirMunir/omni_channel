import 'package:elite_csr/models/convo_list.dart';
import 'package:elite_csr/views/dashboard/controller.dart';
import 'package:elite_csr/views/dashboard/widgets/useable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../main.dart';
import '../../../responsive/sizes.dart';
import '../../../theme/theme.dart';
import '../../../widgets/input_fileds.dart';
import '../../../widgets/text_widget.dart';

class ConvoPanel extends StatelessWidget {
  final DashboardController ctrl;

  const ConvoPanel({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    return Container(
      padding: EdgeInsets.all(10),
      color: AppTheme.white,
      child: Column(
        children: [
          /// HEADER
          Column(
            children: [
              /// LOGO
              Row(
                children: [
                  Image.asset('assets/images/e.png', height: 35.h),

                  SizedBox(width: 5.w),

                  TextWidget(
                    "Elite CRM",
                    style: Theme.of(context).textTheme.bodyLarge,
                    color: Colors.black,
                  ),

                  const Spacer(),

                  IconButton(
                    icon: Icon(Icons.menu),
                    color: Colors.grey.shade700,
                    onPressed: () {},
                  ),
                ],
              ),

              SizedBox(height: 15.h),

              /// SEARCH
              InputFields(
                controller: TextEditingController(),

                hint: "Search conversations...",
                icon: Icons.search,
              ),
            ],
          ),
          SizedBox(height: 18.h),

          Row(
                  children: [
                    _topTab(text: "All", context),

                    SizedBox(width: 10.w),

                    _topTab(text: "Unread", context),

                    SizedBox(width: 10.w),

                    _topTab(text: "Assigned", context),
                  ],
                ),

          SizedBox(height: 15.h),

          /// CHANNELS
          Expanded(
            child: ListView(
              children: [
                UseableList(
                  title: "WhatsApp",
                  color: Colors.green,
                  icon: 'assets/images/w.png',
                  count: 19,
                  data: ctrl.conversations,
                  onTap: (model) {
                    ctrl.selectConversation(model);
                  },
                ),

                SizedBox(height: 14.h),

                UseableList(
                  title: "Facebook",
                  color: Colors.green,
                  icon: 'assets/images/facebook.png',
                  count: 19,
                  data: [],
                  onTap: (model) {},
                ),

                SizedBox(height: 14.h),

                UseableList(
                  title: "Instagram",
                  color: Colors.green,
                  icon: 'assets/images/instagram.png',
                  count: 19,
                  data: [],
                  onTap: (model) {},
                ),

                SizedBox(height: 14.h),

                UseableList(
                  title: "Gmail",
                  color: Colors.green,
                  icon: 'assets/images/gmail.png',
                  count: 19,
                  data: [],
                  onTap: (model) {},
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

  Widget _topTab(BuildContext context, {required String text}) {
    return Obx(() {
      final isMobile = Responsive.isMobile(context);
      final isTablet = Responsive.isTablet(context);

      bool active = ctrl.selectedTab.value == text;

      return GestureDetector(
        onTap: () => ctrl.selectedTab.value = text,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),

          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 10
                : isTablet
                ? 14
                : 16,
            vertical: isMobile ? 6 : 8,
          ),

          decoration: BoxDecoration(
            color: active ? AppTheme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: TextWidget(
            text,

            style: Theme.of(context).textTheme.labelMedium,

            fontSize: isMobile
                ? 11
                : isTablet
                ? 12
                : 13,

            fontWeight: FontWeight.w600,

            color: active ? Colors.white : Colors.black87,
          ),
        ),
      );
    });
  }

  /// ===================================
  /// CHANNEL TILE
  /// ===================================
}
