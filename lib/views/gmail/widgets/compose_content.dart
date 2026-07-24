// import 'package:flutter/material.dart';
//
// import '../controller.dart';
//
// class ComposeContent extends StatelessWidget {
//   final GmailController controller;
//   final bool fullscreen;
//
//   ComposeContent({
//     required this.controller,
//     required this.fullscreen,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: context.gmailSurface,
//       child: Column(
//         children: <Widget>[
//           Container(
//             height: 40,
//             padding: EdgeInsets.only(left: 14),
//             color: context.gmailComposeHeader,
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Text(
//                     'New Message',
//                     style: TextStyle(
//                       color: context.gmailComposeHeaderText,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 if (!fullscreen)
//                   IconButton(
//                     tooltip: 'Minimize',
//                     onPressed: () {},
//                     color: context.gmailComposeHeaderText,
//                     iconSize: 18,
//                     icon: Icon(Icons.remove),
//                   ),
//                 if (!fullscreen)
//                   IconButton(
//                     tooltip: 'Full screen',
//                     onPressed: controller.toggleComposeMaximized,
//                     color: context.gmailComposeHeaderText,
//                     iconSize: 16,
//                     icon: Icon(Icons.open_in_full),
//                   ),
//                 IconButton(
//                   tooltip: 'Save & close',
//                   onPressed: () => controller.closeCompose(saveDraft: true),
//                   color: context.gmailComposeHeaderText,
//                   iconSize: 18,
//                   icon: Icon(Icons.close),
//                 ),
//               ],
//             ),
//           ),
//           TextField(
//             controller: controller.toController,
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: 'Recipients',
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 14,
//                 vertical: 13,
//               ),
//               suffixText: 'Cc  Bcc',
//               border: UnderlineInputBorder(
//                 borderSide: BorderSide(color: context.gmailBorder),
//               ),
//               enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(color: context.gmailBorder),
//               ),
//             ),
//           ),
//           TextField(
//             controller: controller.subjectController,
//             decoration: InputDecoration(
//               hintText: 'Subject',
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 14,
//                 vertical: 13,
//               ),
//               border: UnderlineInputBorder(
//                 borderSide: BorderSide(color: context.gmailBorder),
//               ),
//               enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(color: context.gmailBorder),
//               ),
//             ),
//           ),
//           Expanded(
//             child: TextField(
//               controller: controller.bodyController,
//               expands: true,
//               maxLines: null,
//               minLines: null,
//               textAlignVertical: TextAlignVertical.top,
//               decoration: InputDecoration(
//                 hintText: '',
//                 contentPadding: EdgeInsets.all(14),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           Container(
//             height: 54,
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Row(
//               children: <Widget>[
//                 FilledButton.icon(
//                   onPressed: controller.sendEmail,
//                   icon: Icon(Icons.arrow_drop_down, size: 18),
//                   label: Text('Send'),
//                   style: FilledButton.styleFrom(
//                     backgroundColor: context.gmailPrimary,
//                     foregroundColor: context.gmailOnPrimary,
//                     minimumSize: Size(92, 38),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(19),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 4),
//                 IconButton(
//                   tooltip: 'Formatting options',
//                   onPressed: () {},
//                   icon: Icon(Icons.format_underlined),
//                 ),
//                 IconButton(
//                   tooltip: 'Attach files',
//                   onPressed: () {},
//                   icon: Icon(Icons.attach_file),
//                 ),
//                 IconButton(
//                   tooltip: 'Insert link',
//                   onPressed: () {},
//                   icon: Icon(Icons.link),
//                 ),
//                 if (!compactWidth(context))
//                   IconButton(
//                     tooltip: 'Insert emoji',
//                     onPressed: () {},
//                     icon: Icon(Icons.sentiment_satisfied_alt_outlined),
//                   ),
//                 if (!compactWidth(context))
//                   IconButton(
//                     tooltip: 'Insert files using Drive',
//                     onPressed: () {},
//                     icon: Icon(Icons.add_to_drive_outlined),
//                   ),
//                 Spacer(),
//                 IconButton(
//                   tooltip: 'More options',
//                   onPressed: () {},
//                   icon: Icon(Icons.more_vert),
//                 ),
//                 IconButton(
//                   tooltip: 'Discard draft',
//                   onPressed: () => controller.closeCompose(saveDraft: false),
//                   icon: Icon(Icons.delete_outline),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
