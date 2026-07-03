import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../theme/theme.dart';
import '../../widgets/btn.dart';
import '../../widgets/input_fileds.dart';
import 'ctrl.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      init: SettingsController(),

      builder: (ctrl) {
        return Container(
          color: const Color(0xffF3F6FB),

          child: Row(
            children: [
              /// =========================================================
              /// LEFT SIDEBAR
              /// =========================================================
              Container(
                width: 290.w,

                padding: EdgeInsets.all(24.w),

                decoration: BoxDecoration(
                  color: Colors.white,

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),

                      blurRadius: 14,

                      offset: const Offset(4, 0),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    SizedBox(height: 20.h),

                    /// LOGO
                    Row(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.w,

                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,

                            borderRadius: BorderRadius.circular(16.r),
                          ),

                          child: Icon(
                            Icons.settings,
                            color: AppTheme.textColor,
                          ),
                        ),

                        SizedBox(width: 14.w),

                        const Text(
                          "Elite CRM",

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,

                            color: Color(0xff111827),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40.h),

                    /// MENUS
                    _menuTile(
                      ctrl,
                      index: 0,
                      title: "General",
                      icon: Icons.settings_outlined,
                    ),

                    _menuTile(
                      ctrl,
                      index: 1,
                      title: "Appearance",
                      icon: Icons.palette_outlined,
                    ),

                    _menuTile(
                      ctrl,
                      index: 2,
                      title: "Notifications",
                      icon: Icons.notifications_none,
                    ),

                    _menuTile(
                      ctrl,
                      index: 3,
                      title: "Channels",
                      icon: Icons.link,
                    ),

                    _menuTile(
                      ctrl,
                      index: 4,
                      title: "Automation",
                      icon: Icons.smart_toy_outlined,
                    ),

                    _menuTile(
                      ctrl,
                      index: 5,
                      title: "Security",
                      icon: Icons.lock_outline,
                    ),

                    _menuTile(
                      ctrl,
                      index: 6,
                      title: "Billing",
                      icon: Icons.credit_card_outlined,
                    ),

                    const Spacer(),

                    /// PREMIUM CARD
                    Container(
                      padding: EdgeInsets.all(18.w),

                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff4F46E5), Color(0xff7C3AED)],
                        ),

                        borderRadius: BorderRadius.circular(24.r),
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Container(
                            width: 52.w,
                            height: 52.w,

                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),

                              borderRadius: BorderRadius.circular(16.r),
                            ),

                            child: const Icon(
                              Icons.workspace_premium,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 18.h),

                          const Text(
                            "Upgrade To Pro",

                            style: TextStyle(
                              color: Colors.white,

                              fontSize: 18,

                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          Text(
                            "Unlock advanced automations, AI replies and unlimited inbox integrations.",

                            style: TextStyle(
                              color: Colors.white.withOpacity(0.82),

                              fontSize: 12,
                            ),
                          ),

                          SizedBox(height: 18.h),

                          SizedBox(
                            width: double.infinity,

                            child: ElevatedButton(
                              onPressed: () {},

                              style: ElevatedButton.styleFrom(
                                elevation: 0,

                                backgroundColor: Colors.white,

                                foregroundColor: const Color(0xff4F46E5),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),

                              child: const Text("Upgrade Now"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// =========================================================
              /// RIGHT CONTENT
              /// =========================================================
              Expanded(
                child: IndexedStack(
                  index: ctrl.selectedMenu,

                  children: [
                    /// =====================================================
                    /// GENERAL
                    /// =====================================================
                    ListView(
                      padding: EdgeInsets.all(30.w),

                      children: [
                        _topBanner(),

                        SizedBox(height: 30.h),

                        Row(
                          children: [
                            Expanded(
                              child: _statCard(
                                context: context,

                                title: "Connected Channels",
                                value: "12",
                                icon: Icons.link,
                              ),
                            ),

                            SizedBox(width: 20.w),

                            Expanded(
                              child: _statCard(
                                context: context,
                                title: "Messages Today",
                                value: "8.4k",
                                icon: Icons.message,
                              ),
                            ),

                            SizedBox(width: 20.w),

                            Expanded(
                              child: _statCard(
                                context: context,

                                title: "AI Replies",
                                value: "1.2k",
                                icon: Icons.smart_toy,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 30.h),

                        _sectionCard(
                          context,
                          title: "Workspace Information",

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _inputField(
                                      "Workspace Name",
                                      "Elite CRM",
                                      ctrl.workSpace,
                                      context,
                                      Icons.workspace_premium,
                                    ),
                                  ),

                                  SizedBox(width: 20.w),

                                  Expanded(
                                    child: _inputField(
                                      "Business Email",
                                      "support@elitecrm.ai",
                                      ctrl.emailController,
                                      context,
                                      Icons.email,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 18.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: _inputField(
                                      "Timezone",
                                      "Asia/Karachi",
                                      ctrl.timeZone,
                                      context,
                                      Icons.watch_later_outlined,
                                    ),
                                  ),

                                  SizedBox(width: 20.w),

                                  Expanded(
                                    child: _inputField(
                                      "Language",
                                      "English",
                                      ctrl.lang,
                                      context,
                                      Icons.language,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        _sectionCard(
                          context,
                          title: "Automation & AI",

                          child: Column(
                            children: [
                              _switchTile(
                                title: "Enable AI Assistant",

                                value: ctrl.aiAssistant,

                                onChanged: ctrl.toggleAI,
                              ),

                              SizedBox(height: 14.h),

                              _switchTile(
                                title: "Enable Auto Reply",

                                value: ctrl.autoReply,

                                onChanged: ctrl.toggleAutoReply,
                              ),

                              SizedBox(height: 14.h),

                              _switchTile(
                                title: "Push Notifications",

                                value: ctrl.notifications,

                                onChanged: ctrl.toggleNotifications,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /// =====================================================
                    /// APPEARANCE
                    /// =====================================================
                    _simplePage(
                      title: "Appearance Settings",
                      subtitle: "Customize dashboard theme, colors and layout.",
                    ),

                    /// =====================================================
                    /// NOTIFICATIONS
                    /// =====================================================
                    _simplePage(
                      title: "Notification Settings",
                      subtitle:
                          "Manage alerts, sounds and message notifications.",
                    ),

                    /// =====================================================
                    /// CHANNELS
                    /// =====================================================
                    ListView(
                      padding: EdgeInsets.all(30.w),

                      children: [
                        _sectionCard(
                          context,
                          title: "Connected Channels",

                          child: Column(
                            children: [
                              _channelTile(
                                "WhatsApp Business",
                                const Color(0xff22C55E),
                              ),

                              _channelTile(
                                "Instagram Messaging",
                                const Color(0xffA855F7),
                              ),

                              _channelTile(
                                "Facebook Messenger",
                                const Color(0xff3B82F6),
                              ),

                              _channelTile(
                                "TikTok Inbox",
                                const Color(0xff111827),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /// =====================================================
                    /// AUTOMATION
                    /// =====================================================
                    _simplePage(
                      title: "Automation Center",
                      subtitle:
                          "Manage workflows, AI automations and triggers.",
                    ),

                    /// =====================================================
                    /// SECURITY
                    /// =====================================================
                    ListView(
                      padding: EdgeInsets.all(30.w),

                      children: [
                        _sectionCard(
                          context,
                          title: "Security",

                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'Change Password',
                                  onPressed: () {},
                                ),
                              ),

                              SizedBox(width: 18.w),

                              Expanded(
                                child: CustomButton(
                                  text: 'Enable 2FA',
                                  onPressed: () {},
                                ),
                              ),

                              SizedBox(width: 18.w),

                              Expanded(
                                child: CustomButton(
                                  text: 'View Sessions',
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /// =====================================================
                    /// BILLING
                    /// =====================================================
                    _simplePage(
                      title: "Billing & Subscription",
                      subtitle:
                          "Manage invoices, payments and subscription plans.",
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _topBanner() {
    return Container(
      padding: EdgeInsets.all(30.w),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff4F46E5), Color(0xff7C3AED)],
        ),

        borderRadius: BorderRadius.circular(28.r),
      ),

      child: Row(
        children: [
          Container(
            width: 72.w,
            height: 72.w,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),

              shape: BoxShape.circle,
            ),

            child: const Icon(Icons.settings, color: Colors.white, size: 34),
          ),

          SizedBox(width: 20.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  "Workspace Settings",

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 30,

                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  "Manage your CRM workspace, channels and automations",

                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),

                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _simplePage({required String title, required String subtitle}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            width: 100.w,
            height: 100.w,

            decoration: BoxDecoration(
              color: const Color(0xffEEF2FF),

              borderRadius: BorderRadius.circular(30.r),
            ),

            child: const Icon(
              Icons.settings,
              size: 44,
              color: AppTheme.primaryColor,
            ),
          ),

          SizedBox(height: 24.h),

          Text(
            title,

            style: const TextStyle(
              fontSize: 30,

              fontWeight: FontWeight.w700,

              color: Color(0xff111827),
            ),
          ),

          SizedBox(height: 10.h),

          Text(
            subtitle,

            style: const TextStyle(color: Color(0xff6B7280), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(
    SettingsController ctrl, {
    required int index,
    required String title,
    required IconData icon,
  }) {
    bool active = ctrl.selectedMenu == index;

    return GestureDetector(
      onTap: () {
        ctrl.changeMenu(index);
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),

        margin: EdgeInsets.only(bottom: 10.h),

        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),

        decoration: BoxDecoration(
          color: active ? const Color(0xffEEF2FF) : Colors.transparent,

          borderRadius: BorderRadius.circular(16.r),
        ),

        child: Row(
          children: [
            Icon(
              icon,

              color: active ? AppTheme.primaryColor : AppTheme.iconColor,
            ),

            SizedBox(width: 12.w),

            Text(
              title,

              style: TextStyle(
                fontWeight: FontWeight.w600,

                fontSize: 14,

                color: active ? AppTheme.primaryColor : AppTheme.hintTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(context, {required String title, required Widget child}) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(24.w),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: Colors.black),
          ),

          SizedBox(height: 24.h),

          child,
        ],
      ),
    );
  }

  Widget _inputField(String label, String hint, ctrl, context, icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,

          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppTheme.textColor),
        ),

        SizedBox(height: 8.h),

        InputFields(

            controller: ctrl, hint: hint, icon: icon),
      ],
    );
  }

  Widget _switchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),

      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),

        borderRadius: BorderRadius.circular(16.r),
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                fontWeight: FontWeight.w600,

                fontSize: 14,

                color: Color(0xff111827),
              ),
            ),
          ),

          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _channelTile(String title, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),

      padding: EdgeInsets.all(16.w),

      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),

        borderRadius: BorderRadius.circular(18.r),
      ),

      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.12),

            child: Icon(Icons.link, color: color),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Text(
              title,

              style: const TextStyle(
                fontWeight: FontWeight.w600,

                fontSize: 14,

                color: Color(0xff111827),
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),

            decoration: BoxDecoration(
              color: const Color(0xffDCFCE7),

              borderRadius: BorderRadius.circular(30.r),
            ),

            child: const Text(
              "Connected",

              style: TextStyle(
                color: Color(0xff059669),

                fontWeight: FontWeight.w600,

                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(22.w),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22.r),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, color: AppTheme.primaryColor),

          SizedBox(height: 18.h),

          Text(
            value,

            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppTheme.textColor),
          ),

          SizedBox(height: 6.h),

          Text(
            title,

            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppTheme.textColor),
          ),
        ],
      ),
    );
  }
}
