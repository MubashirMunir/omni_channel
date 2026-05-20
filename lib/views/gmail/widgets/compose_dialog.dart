import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:elite_csr/views/gmail/widgets/reply_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../theme/theme.dart';
import '../controller.dart';

void showComposeDialog(GmailController ctrl) {
  Get.dialog(
    Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Dialog(
          backgroundColor: theme.cardColor,
          insetPadding: const EdgeInsets.all(22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppTheme.radiusLG(context),
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
              maxHeight: 650,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                        AppTheme.radiusLG(context),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'New Message',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ctrl.clearComposeFields();
                          Get.back();
                        },
                        icon: Icon(
                          Icons.close,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),

                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                    child: Column(
                      children: [
                        DialogTextFields(
                          controller: ctrl.composeToController,
                          label: 'To',
                          hint: 'recipient@email.com',
                          icon: Icons.person_outline,
                        ),

                        const SizedBox(height: 12),

                        DialogTextFields(
                          controller: ctrl.composeCcController,
                          label: 'CC',
                          hint: 'optional',
                          icon: Icons.alternate_email,
                        ),

                        const SizedBox(height: 12),

                        DialogTextFields(
                          controller: ctrl.composeSubjectController,
                          label: 'Subject',
                          hint: 'Email subject',
                          icon: Icons.subject,
                        ),

                        const SizedBox(height: 14),

                        TextField(
                          controller: ctrl.composeBodyController,
                          minLines: 8,
                          maxLines: 12,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Write your email...',
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.hintColor,
                            ),
                            filled: true,
                            fillColor: theme.scaffoldBackgroundColor,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: theme.colorScheme.primary
                                    .withOpacity(0.45),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            FilledButton.icon(
                              onPressed: ctrl.sendNewEmail,
                              icon: const Icon(Icons.send, size: 18),
                              label: const Text('Send'),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.attach_file,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.75),
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () {
                                ctrl.clearComposeFields();
                                Get.back();
                              },
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Discard'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}