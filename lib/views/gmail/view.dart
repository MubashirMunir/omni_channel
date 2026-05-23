import 'package:elite_csr/views/gmail/widgets/mobile_header.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../responsive/sizes.dart';
import 'controller.dart';

class GmailCenterView extends StatelessWidget {
  final String accountName;
  final String accountEmail;

  const GmailCenterView({
    super.key,
    required this.accountName,
    required this.accountEmail,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GmailController>(
      init: GmailController(),
      builder: (gmailCtrl) {
        /// Apni responsive class ka exact name yahan use kar lena.
        /// Example:
        final bool isCompact =
            Responsive.isMobile(context) || Responsive.isTablet(context);

        return
          isCompact
            ?
        MobileGmailHeader(
                accountName: accountName,
                accountEmail: accountEmail,
                ctrl: gmailCtrl,
              )
            :
        SizedBox();
      },
    );
  }
}
