// import 'dart:async';
// import 'package:get_it/get_it.dart';
// import 'package:erpattendance/configuration/api_urls.dart';
//   import 'package:shared_preferences/shared_preferences.dart';
//
// class SocketService {
//   late io.Socket socket;
//   Timer? timer;
//   final GetIt locator = GetIt.instance;
//
//   SocketService() {
//     // Initialize the socket connection
//     socket = io.io(ApiUrls.socketUrl, <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': true,
//     });
//
//     // Listen for WebSocket connection
//     socket.on('connect', (_) {
//       // print('Connected to WebSocket');
//       emitUserId();
//     });
//
//     // Listen for the 'logout' event sent by the server
//     socket.on('logout', (_) {
//       // print('Logging out user due to null serial number!');
//       // Perform the logout action, e.g., navigate to login screen
//       // Navigator.pushReplacementNamed(context, '/login');
//
//       // navigatorKey.currentState?.context
//       //     .read<AuthenticationController>()
//       //     .logoutUser();
//     });
//
//     // Listen for WebSocket disconnection
//     socket.on('disconnect', (_) {
//       // print('Disconnected from WebSocket');
//     });
//   }
//
//   // Emit user ID continuously (e.g., every 5 seconds)
//   void emitUserId() {
//     int? userId = locator.get<SharedPreferences>().getInt('id');
//     int? branchId = locator.get<SharedPreferences>().getInt('branchId');
//
//     // Ensure user ID is not null before emitting
//     if (userId != null) {
//       // Emit the user ID to the server
//       // socket.emit('user_id', userId);
//       socket.emit('user_data', {'user_id': userId, 'branch_id': branchId});
//
//       // If a valid user ID exists, set a periodic timer to keep emitting the user ID every minute
//       // if (timer == null || !timer!.isActive) {
//       //   timer = Timer.periodic(Duration(minutes: 1), (timer) {
//       //     print('Emitting user ID');
//       //     emitUserId(); // Recursively call to keep sending user ID
//       //   });
//       // }
//     }
//   }
//
//   // Disconnect from the WebSocket server
//   void disconnect() {
//     // print('Disconnecting from WebSocket and canceling timer');
//
//     // Cancel the timer if it's active
//     timer?.cancel();
//     timer =
//         null; // Clear the reference to the timer to avoid any unwanted behavior
//
//     // Dispose of the socket connection
//     socket.dispose();
//   }
// }
