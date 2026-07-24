// import 'dart:developer';
// import 'dart:io';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get_it/get_it.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../configuration/api_exceptions.dart';
// import '../configuration/api_http_requests.dart';
// import '../configuration/api_urls.dart';
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   log("onMessage: ${message.notification?.title}/${message.notification?.body}/${message.data}}");
// }
//
// class PushNotificationService {
//   Future intialize(context) async {
//     // await updateToken();
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     FirebaseMessaging.onMessage.listen((message) {
//       log("messageOn1:  ${message.notification?.title}/${message.notification?.body}/${message.data}}");
//       showNotification(
//         title: message.notification!.title.toString(),
//         body: message.notification!.body.toString(),
//         data: message.data,
//         notificationLayout: NotificationLayout.Default,
//       );
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       log("messageOn2:  ${message.notification?.title}/${message.notification?.body}/${message.data}}");
//     });
//   }
// }
//
// // Future<void> updateToken([String? token]) async {
// //   if (GetIt.instance.get<SharedPreferences>().getInt('id') != null) {
// //     try {
// //       String deviceToken = await getDeviceToken();
// //
// //       Response response = await GetIt.instance<DioClient>().put(
// //         ApiUrls.getLeavesByUserId,
// //         data: {
// //           "notificationToken": token ??  deviceToken,
// //         },
// //       );
// //       final data = response.data;
// //       log(data.toString());
// //     } on DioException catch (e) {
// //       ApiException.getMessage(e.error, false, false,);
// //     }
// //   }
// // }
//
// Future<String> getDeviceToken() async {
//   String? deviceToken;
//   if (Platform.isIOS) {
//     deviceToken = await FirebaseMessaging.instance.getAPNSToken();
//   } else {
//     deviceToken = await FirebaseMessaging.instance.getToken();
//   }
//
//   log('--------Device Token---------- $deviceToken');
//   return deviceToken.toString();
// }
//
// Future<void> showNotification({
//   required String title,
//   required String body,
//   required Map<String, dynamic> data,
//   required NotificationLayout notificationLayout,
// }) async {
//   await AwesomeNotifications().createNotification(
//     content: NotificationContent(
//       id: DateTime.now().second,
//       actionType: ActionType.Default,
//       body: body,
//       channelKey: 'rpattendance_channel',
//       title: title,
//       // largeIcon: ApiUrls.baseUrl + data['imageUrl'],
//       notificationLayout: notificationLayout,
//       // bigPicture: imageUrl,
//       payload: {
//         'type': data['type'],
//         'senderId': data['senderId'],
//         'receiverId': data['receiverId'],
//       },
//     ),
//   );
// }