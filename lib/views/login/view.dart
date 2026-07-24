import 'dart:ui';

import 'package:elite_csr/theme/theme.dart';
import 'package:elite_csr/views/login/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: const Color(0xff07111f),
          body: Stack(
            children: [
              /// Background
              Positioned.fill(
                child: Image.asset(
                  'assets/images/bg1.jpeg',
                  fit: BoxFit.cover,
                ),
              ),

              /// Professional dark overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xff07111f).withOpacity(.96),
                        const Color(0xff0d2340).withOpacity(.88),
                        Colors.black.withOpacity(.78),
                      ],
                    ),
                  ),
                ),
              ),

              /// Decorative glow
              Positioned(
                top: -170,
                left: -120,
                child: _glowCircle(
                  420,
                  AppTheme.primaryColor.withOpacity(.20),
                ),
              ),

              Positioned(
                bottom: -220,
                right: -140,
                child: _glowCircle(
                  480,
                  const Color(0xff2563eb).withOpacity(.16),
                ),
              ),

              /// Main content
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth >= 950;
                    final isSmallMobile = constraints.maxWidth < 390;

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 48 : 18,
                        vertical: isDesktop ? 24 : 16,
                      ),
                      child: Column(
                        children: [
                          _buildHeader(context),

                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 1220,
                                ),
                                child: isDesktop
                                    ? Row(
                                  children: [
                                    Expanded(
                                      child: _buildHeroContent(context),
                                    ),
                                    const SizedBox(width: 70),
                                    _buildLoginCard(
                                      context,
                                      ctrl,
                                      width: 455,
                                    ),
                                  ],
                                )
                                    : SingleChildScrollView(
                                  physics:
                                  const BouncingScrollPhysics(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 28,
                                    ),
                                    child: _buildLoginCard(
                                      context,
                                      ctrl,
                                      width: isSmallMobile
                                          ? constraints.maxWidth
                                          : 430,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          _buildFooter(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(.13),
            ),
          ),
          child: Image.asset(
            'assets/images/e.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Elite CRM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                letterSpacing: .2,
              ),
            ),
            Text(
              'Customer relationship platform',
              style: TextStyle(
                color: Colors.white.withOpacity(.55),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(.13),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(.30),
              ),
            ),
            child: const Text(
              'OMNI-CHANNEL CRM PLATFORM',
              style: TextStyle(
                color: Color(0xff8fb8ff),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 28),
          const SizedBox(
            width: 600,
            child: Text(
              'Manage every customer conversation from one place.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 46,
                height: 1.12,
                fontWeight: FontWeight.w700,
                letterSpacing: -.8,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 540,
            child: Text(
              'Connect your teams, organize customer interactions and deliver faster support with a unified CRM workspace.',
              style: TextStyle(
                color: Colors.white.withOpacity(.65),
                fontSize: 16,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 34),
          Wrap(
            spacing: 28,
            runSpacing: 18,
            children: const [
              _FeatureItem(
                icon: Icons.forum_outlined,
                text: 'Unified conversations',
              ),
              _FeatureItem(
                icon: Icons.query_stats_rounded,
                text: 'Real-time insights',
              ),
              _FeatureItem(
                icon: Icons.security_outlined,
                text: 'Secure access',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(
      BuildContext context,
      LoginController ctrl, {
        required double width,
      }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),
        child: Container(
          width: width,
          padding: const EdgeInsets.fromLTRB(34, 36, 34, 30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.96),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(.75),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.30),
                blurRadius: 55,
                offset: const Offset(0, 24),
              ),
            ],
          ),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Color(0xff101828),
                    fontSize: 29,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -.4,
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'Enter your credentials to access your workspace.',
                  style: TextStyle(
                    color: Color(0xff667085),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),

                _PremiumTextField(
                  controller: ctrl.emailController,
                  label: 'Email address',
                  hint: 'name@company.com',
                  icon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                ),

                const SizedBox(height: 20),

                _PremiumTextField(
                  controller: ctrl.passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  autofillHints: const [AutofillHints.password],
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: const Color(0xff667085),
                    ),
                  ),
                  onSubmitted: (_) => _login(ctrl),
                ),

                const SizedBox(height: 13),

                Row(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: AppTheme.primaryColor,
                        side: const BorderSide(
                          color: Color(0xffD0D5DD),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 9),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        color: Color(0xff475467),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                _PremiumLoginButton(
                  onPressed: () => _login(ctrl),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Color(0xffEAECF0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'SECURE LOGIN',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Color(0xffEAECF0),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 16,
                      color: Color(0xff667085),
                    ),
                    SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        'Your account is protected with secure authentication.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff667085),
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Powered by',
            style: TextStyle(
              color: Colors.white.withOpacity(.45),
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Image.asset(
            'assets/images/e.png',
            height: 22,
          ),
          const SizedBox(width: 6),
          Text(
            'Elite CRM',
            style: TextStyle(
              color: Colors.white.withOpacity(.78),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _login(LoginController ctrl) {
    FocusManager.instance.primaryFocus?.unfocus();

    final email = ctrl.emailController.text.trim();
    final password = ctrl.passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      ctrl.login();
      return;
    }

    Get.snackbar(
      'Login failed',
      'Please enter your email and password.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xffD92D20),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 14,
      maxWidth: 420,
      icon: const Icon(
        Icons.error_outline_rounded,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 3),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 75,
        sigmaY: 75,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class _PremiumTextField extends StatelessWidget {
  const _PremiumTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.autofillHints,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff344054),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          autofillHints: autofillHints,
          onSubmitted: onSubmitted,
          cursorColor: AppTheme.primaryColor,
          style: const TextStyle(
            color: Color(0xff101828),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xff98A2B3),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: const Color(0xff667085),
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xffF9FAFB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(
                color: Color(0xffD0D5DD),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: AppTheme.primaryColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PremiumLoginButton extends StatefulWidget {
  const _PremiumLoginButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  State<_PremiumLoginButton> createState() =>
      _PremiumLoginButtonState();
}

class _PremiumLoginButtonState extends State<_PremiumLoginButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(
          0,
          _isHovered ? -2 : 0,
          0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(
                _isHovered ? .35 : .22,
              ),
              blurRadius: _isHovered ? 22 : 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(13),
          child: Ink(
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor,
                  const Color(0xff2563EB),
                ],
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(13),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign in to workspace',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(.10),
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xff9DBDFF),
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(.75),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}