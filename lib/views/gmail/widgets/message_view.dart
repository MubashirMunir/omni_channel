// import 'package:flutter/material.dart';
//
// import '../../../models/gmail_model.dart';
// import '../controller.dart';
//
// class MessageView extends StatelessWidget {
//   final GmailController controller;
//   final bool showBackButton;
//   final bool mobile;
//
//   MessageView({
//     required this.controller,
//     required this.showBackButton,
//     this.mobile = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final GmailMessage? message = controller.selectedMessage;
//
//     if (message == null) {
//       return _EmptyMailbox();
//     }
//
//     return Column(
//       children: <Widget>[
//         Container(
//           height: 48,
//           padding: EdgeInsets.symmetric(horizontal: 8),
//           decoration: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(color: context.gmailBorder),
//             ),
//           ),
//           child: Row(
//             children: <Widget>[
//               if (showBackButton)
//                 IconButton(
//                   tooltip: 'Back to inbox',
//                   onPressed: controller.closeMessage,
//                   icon: Icon(Icons.arrow_back),
//                 ),
//               IconButton(
//                 tooltip: 'Archive',
//                 onPressed: controller.archiveOpenMessage,
//                 icon: Icon(Icons.archive_outlined),
//               ),
//               IconButton(
//                 tooltip: 'Report spam',
//                 onPressed: controller.reportOpenMessageAsSpam,
//                 icon: Icon(Icons.report_gmailerrorred_outlined),
//               ),
//               IconButton(
//                 tooltip: 'Delete',
//                 onPressed: controller.deleteOpenMessage,
//                 icon: Icon(Icons.delete_outline),
//               ),
//               VerticalDivider(
//                 width: 14,
//                 indent: 10,
//                 endIndent: 10,
//               ),
//               IconButton(
//                 tooltip: 'Mark unread',
//                 onPressed: controller.markOpenMessageAsUnread,
//                 icon: Icon(Icons.mark_email_unread_outlined),
//               ),
//               IconButton(
//                 tooltip: 'Snooze',
//                 onPressed: controller.snoozeOpenMessage,
//                 icon: Icon(Icons.schedule_outlined),
//               ),
//               Spacer(),
//               if (!mobile)
//                 Text(
//                   '1 of ${controller.visibleMessages.isEmpty ? 1 : controller.visibleMessages.length}',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: context.gmailMuted,
//                   ),
//                 ),
//               IconButton(
//                 tooltip: 'More',
//                 onPressed: () {},
//                 icon: Icon(Icons.more_vert),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.fromLTRB(
//               mobile ? 16 : 72,
//               24,
//               mobile ? 16 : 56,
//               40,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Expanded(
//                       child: Wrap(
//                         crossAxisAlignment: WrapCrossAlignment.center,
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: <Widget>[
//                           Text(
//                             message.subject,
//                             style: TextStyle(
//                               fontSize: mobile ? 22 : 24,
//                               height: 1.25,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           if (message.label != null)
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 7,
//                                 vertical: 3,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: context.gmailLabelSurface,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 message.label!,
//                                 style: TextStyle(fontSize: 11),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     IconButton(
//                       tooltip: 'Print',
//                       onPressed: () {},
//                       icon: Icon(Icons.print_outlined, size: 20),
//                     ),
//                     if (!mobile)
//                       IconButton(
//                         tooltip: 'Open in new window',
//                         onPressed: () {},
//                         icon: Icon(Icons.open_in_new, size: 20),
//                       ),
//                   ],
//                 ),
//                 SizedBox(height: 28),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     CircleAvatar(
//                       radius: 20,
//                       backgroundColor: context.gmailSearchSurface,
//                       foregroundColor: context.gmailPrimary,
//                       child: Text(
//                         _initials(message.senderName),
//                         style: TextStyle(fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                     SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Row(
//                             children: <Widget>[
//                               Flexible(
//                                 child: Text(
//                                   message.senderName,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 6),
//                               Flexible(
//                                 child: Text(
//                                   '<${message.senderEmail}>',
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                     color: context.gmailMuted,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 3),
//                           Text(
//                             'to ${message.recipients.isEmpty ? 'me' : message.recipients.join(', ')}',
//                             style: TextStyle(
//                               color: context.gmailMuted,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     if (!mobile)
//                       Text(
//                         _formatFullDate(message.receivedAt),
//                         style: TextStyle(
//                           color: context.gmailMuted,
//                           fontSize: 12,
//                         ),
//                       ),
//                     IconButton(
//                       tooltip: message.isStarred ? 'Unstar' : 'Star',
//                       onPressed: () => controller.toggleStar(message.id),
//                       icon: Icon(
//                         message.isStarred ? Icons.star : Icons.star_border,
//                         size: 20,
//                         color: message.isStarred
//                             ? context.gmailAccent
//                             : context.gmailMuted,
//                       ),
//                     ),
//                     IconButton(
//                       tooltip: 'Reply',
//                       onPressed: () {},
//                       icon: Icon(Icons.reply, size: 20),
//                     ),
//                     IconButton(
//                       tooltip: 'More',
//                       onPressed: () {},
//                       icon: Icon(Icons.more_vert, size: 20),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 28),
//                 SelectableText(
//                   message.body,
//                   style: TextStyle(
//                     fontSize: 14,
//                     height: 1.65,
//                     color: context.gmailText,
//                   ),
//                 ),
//                 if (message.hasAttachment) ...<Widget>[
//                   SizedBox(height: 28),
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: <Widget>[
//                       Container(
//                         width: 220,
//                         height: 56,
//                         padding: EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           color: context.gmailSubtleSurface,
//                           border: Border.all(
//                             color: context.gmailBorder,
//                           ),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: <Widget>[
//                             Icon(
//                               Icons.picture_as_pdf_outlined,
//                               color: context.gmailError,
//                             ),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: Text(
//                                 message.attachmentName ?? 'Attachment.pdf',
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                             ),
//                             IconButton(
//                               tooltip: 'Download',
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.download_outlined,
//                                 size: 19,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//                 SizedBox(height: 36),
//                 Wrap(
//                   spacing: 10,
//                   runSpacing: 10,
//                   children: <Widget>[
//                     OutlinedButton.icon(
//                       onPressed: () {},
//                       icon: Icon(Icons.reply),
//                       label: Text('Reply'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: context.gmailPrimary,
//                         side: BorderSide(
//                           color: context.gmailOutline,
//                         ),
//                         minimumSize: Size(110, 40),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                     OutlinedButton.icon(
//                       onPressed: () {},
//                       icon: Icon(Icons.forward),
//                       label: Text('Forward'),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: context.gmailPrimary,
//                         side: BorderSide(
//                           color: context.gmailOutline,
//                         ),
//                         minimumSize: Size(120, 40),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
