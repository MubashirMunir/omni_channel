import 'package:elite_csr/models/convo_list.dart';
import 'package:elite_csr/views/dashboard/controller.dart';
import 'package:elite_csr/views/dashboard/widgets/useable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../main.dart';
import '../../../models/convo_list.dart';
import '../../../responsive/sizes.dart';
import '../../../theme/theme.dart';
import '../../../widgets/input_fileds.dart';
import '../../../widgets/text_widget.dart';

class ConvoPanel extends StatelessWidget {
  final DashboardController ctrl;

  const ConvoPanel({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
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
                  ),

                  const Spacer(),

                  IconButton(icon: Icon(Icons.menu), onPressed: () {}),
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
          SizedBox(height: 20.h),

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
                  count: ctrl.countByPlatform("WhatsApp"),
                  data: ctrl.getByPlatform("WhatsApp"),
                  onTap: (model) {
                    ctrl.selectConversation(model);
                  },
                  isExpanded: ctrl.expandedList == "WhatsApp",
                  onExpansionChanged: (value) {
                    ctrl.toggleExpandedList("WhatsApp", value);
                  },
                ),

                SizedBox(height: 14.h),

                UseableList(
                  title: "Facebook",
                  color: Colors.green,
                  icon: 'assets/images/facebook.png',
                  count: ctrl.countByPlatform("Facebook"),
                  data: ctrl.getByPlatform("Facebook"),
                  onTap: (model) {
                    ctrl.selectConversation(model);
                  },
                  isExpanded: ctrl.expandedList == "Facebook",
                  onExpansionChanged: (value) {
                    ctrl.toggleExpandedList("Facebook", value);
                  },
                ),

                SizedBox(height: 14.h),

                UseableList(
                  title: "Instagram",
                  color: Colors.green,
                  icon: 'assets/images/instagram.png',
                  count: ctrl.countByPlatform("Instagram"),
                  data: ctrl.getByPlatform("Instagram"),
                  onTap: (model) {
                    ctrl.selectConversation(model);
                  },
                  isExpanded: ctrl.expandedList == "Instagram",
                  onExpansionChanged: (value) {
                    ctrl.toggleExpandedList("Instagram", value);
                  },
                ),

                SizedBox(height: 14.h),

                UseableList(
                  title: "Gmail",
                  color: Colors.green,
                  icon: 'assets/images/gmail.png',
                  count: ctrl.countByPlatform("Gmail"),
                  data: ctrl.getByPlatform("Gmail"),
                  onTap: (model) {
                    ctrl.selectConversation(model);
                  },
                  isExpanded: ctrl.expandedList == "Gmail",
                  onExpansionChanged: (value) {
                    ctrl.toggleExpandedList("Gmail", value);
                  },
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

      final bool active = ctrl.selectedTab.value == text;

      return GestureDetector(
        onTap: () {
          ctrl.selectedTab.value = text;
          ctrl.update(); // important for GetBuilder list rebuild
        },
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
            color: active ? AppTheme.primaryColor : Colors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active
                  ? AppTheme.primaryColor
                  : Colors.grey.withOpacity(0.25),
            ),
          ),
          child: TextWidget(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: active ? Colors.white : Colors.grey,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
            fontSize: isMobile
                ? 11
                : isTablet
                ? 12
                : 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      );
    });
  }
  /// ===================================
  /// CHANNEL TILE
  /// ===================================
}
