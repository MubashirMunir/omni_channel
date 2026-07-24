import 'package:flutter/material.dart';

import '../constants/AppResource.dart';


class SuspendedUserDialog extends StatelessWidget {
  const SuspendedUserDialog({Key? key, this.onPressed, this.message,this.buttonText})
      : super(key: key);
  final Function()? onPressed;
  final String? message,buttonText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 200, child: const Icon(Icons.block)),
          const SizedBox(height: 32),
          Text(
            AppStrings.whoops,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            message ?? AppStrings.this_account_has_suspended,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 16),
          ElevatedButton(
            child: Text( buttonText?? AppStrings.logout),
            onPressed: onPressed,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}