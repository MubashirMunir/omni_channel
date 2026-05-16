import 'dart:ui';

import 'package:elite_csr/theme/theme.dart';
import 'package:elite_csr/views/login/controller.dart';
import 'package:elite_csr/widgets/btn.dart';
import 'package:elite_csr/widgets/input_fileds.dart';
import 'package:elite_csr/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../responsive/sizes.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    var isMobile = Responsive.isMobile(context);
    var isTab = Responsive.isTablet(context);
    var isWeb = Responsive.isDesktop(context);
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (ctrl) {
        return Scaffold(
          body: Stack(
            children: [
              /// Background Image
              Positioned.fill(
                child: Image.asset('assets/images/bg1.jpeg', fit: BoxFit.cover),
              ),

              /// Dark Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.75),
                        Colors.black.withOpacity(0.55),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

              /// Blur Circles
              Positioned(
                top: -100,
                left: -80,
                child: _blurCircle(
                  size: 220,
                  color: AppTheme.primaryColor.withOpacity(0.18),
                ),
              ),

              Positioned(
                bottom: -120,
                right: -100,
                child: _blurCircle(
                  size: 260,
                  color: Colors.blue.withOpacity(0.12),
                ),
              ),

              /// Content
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: (isWeb || isTab) ? 200 : 0,
                      ),
                      child: Row(
                        mainAxisAlignment: (isWeb || isTab)
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/e.png', height: 36),
                          const SizedBox(width: 12),
                          Text(
                            "Elite CRM",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: isWeb || isTab ? 80 : 0),
                        child: Align(
                          alignment: isMobile
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: SingleChildScrollView(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMD(context),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 14,
                                ),
                                child: Container(
                                  width: isMobile
                                      ? 350
                                      : isTab
                                      ? 360
                                      : isWeb
                                      ? 400
                                      : 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 30,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(
                                      AppTheme.radiusSM(context),
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.091),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        blurRadius: 10,
                                        offset: const Offset(0, 15),
                                      ),
                                    ],
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Welcome Back",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),

                                      const SizedBox(height: 5),

                                      Text(
                                        "Login to continue managing your customer conversations.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey),
                                      ),

                                      const SizedBox(height: 35),

                                      InputFields(
                                        controller: ctrl.emailController,
                                        hint: "Email",
                                        icon: Icons.email_outlined,
                                      ),

                                      const SizedBox(height: 18),

                                      InputFields(
                                        controller: ctrl.passwordController,
                                        hint: "Password",
                                        icon: Icons.lock_outline,
                                        obscure: true,
                                      ),

                                      const SizedBox(height: 14),

                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Forgot Password?",
                                            style: TextStyle(
                                              color: AppTheme.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 10),
                                      CustomButton(
                                        text: 'Login',
                                        onPressed: () {
                                          if (ctrl
                                                  .passwordController
                                                  .text
                                                  .isNotEmpty &&
                                              ctrl
                                                  .emailController
                                                  .text
                                                  .isNotEmpty) {
                                            ctrl.login();
                                          } else {
                                            Get.snackbar(
                                              "Login Failed",
                                              "Invalid username or password",

                                              snackPosition: SnackPosition.TOP,

                                              backgroundColor:
                                                  Colors.red.shade400,
                                              colorText: Colors.white,

                                              margin: const EdgeInsets.all(20),
                                              borderRadius: 12,

                                              maxWidth: 400,

                                              icon: const Icon(
                                                Icons.error_outline,
                                                color: Colors.white,
                                              ),

                                              duration: const Duration(
                                                seconds: 3,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Footer
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 10,
                        left: (isWeb || isTab) ? 200 : 0,
                      ),
                      child: Row(
                        mainAxisAlignment: (isWeb || isTab)
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          TextWidget("Powered by ", color: Colors.grey),
                          Image.asset('assets/images/e.png', height: 25),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _blurCircle({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
