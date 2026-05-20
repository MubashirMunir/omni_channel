import 'package:elite_csr/views/gmail/widgets/compact_layout.dart';
import 'package:elite_csr/views/gmail/widgets/gmail_detail_panel.dart';
import 'package:elite_csr/views/gmail/widgets/gmail_mail_list.dart';
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
          isCompact?
            CompactGmailLayout(
            ctrl: gmailCtrl,
            accountName: accountName,
            accountEmail: accountEmail,
          ):SizedBox();


        // return Container(
        //   color: Theme.of(context).scaffoldBackgroundColor,
        //   child: Row(
        //     children: [
        //       SizedBox(
        //         width: 360,
        //         child: GmailMailList(ctrl: gmailCtrl),
        //       ),
        //       VerticalDivider(
        //         width: 1,
        //         color: Theme.of(context).dividerColor.withOpacity(0.25),
        //       ),
        //       Expanded(
        //         child: GmailDetailPanel(ctrl: gmailCtrl),
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }
}











