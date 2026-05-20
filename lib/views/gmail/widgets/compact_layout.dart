import 'package:flutter/material.dart';

import '../controller.dart';
import 'gmail_detail_panel.dart';
import 'gmail_mail_list.dart';
import 'mobile_header.dart';

class CompactGmailLayout extends StatelessWidget {
  final GmailController ctrl;
  final String accountName;
  final String accountEmail;

  const CompactGmailLayout({
    required this.ctrl,
    required this.accountName,
    required this.accountEmail,
  });

  @override
  Widget build(BuildContext context) {
    final selectedMail = ctrl.selectedEmail.value;

    if (selectedMail != null) {
      return GmailDetailPanel(
        ctrl: ctrl,
        showBackButton: true,
        onBack: () {
          ctrl.selectedEmail.value = null;
          ctrl.update();
        },
      );
    }

    return Column(
      children: [
        MobileGmailHeader(
          ctrl: ctrl,
          accountName: accountName,
          accountEmail: accountEmail,
        ),
        Expanded(
          child: GmailMailList(ctrl: ctrl),
        ),
      ],
    );
  }
}
