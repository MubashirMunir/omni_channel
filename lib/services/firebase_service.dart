// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:SJA_Impact/src/services/urls.dart';
// import 'dart:developer';
// import 'dart:io';
//
// import '../general_controller/GeneralController.dart';
// import '../utils/AppResource.dart';
// import '../widgets/dialog.dart';
//
// class FirebaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   /// 🔹 Listen for Auth Changes
//   void listenAuthChanges(Function(User?) callback) {
//     _auth.authStateChanges().listen(callback);
//   }
//
//   /// 🔹 Check if user exists in Firestore
//   Future<bool> checkUserInFirestore(String uid) async {
//     try {
//       DocumentSnapshot userDoc = await _firestore.collection(users).doc(uid).get();
//       return userDoc.exists;
//     } catch (e) {
//       print("⚠️ Error checking Firestore: $e");
//       return false;
//     }
//   }
//
//
//   /// 🔹 Login with Email & Password
//   Future<UserCredential?> login(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email.trim(),
//         password: password.trim(),
//       );
//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       print("🔥 Firebase Auth Error: ${e.message}");
//       Get.snackbar(ErrorStrings.login_failed, e.message ?? ErrorStrings.something_went_wrong);
//       return null;
//     }
//   }
//
//   /// 🔹 Logout
//   Future<void> logout() async {
//     await _auth.signOut();
//   }
//
//
//
//   Future<void> getFirestoreData({
//     required String collectionName,
//     String? docId,
//     Map<String, dynamic>? queryData,
//     required Function executionMethod,
//   }) async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isEmpty || result[0].rawAddress.isEmpty) {
//         throw SocketException(AppStrings.internet_not_connected);
//       }
//
//       log('Internet Connected');
//
//       Get.find<GeneralController>().changeLoaderCheck(true);
//
//       dynamic response;
//
//       if (docId != null) {
//         // Get single document
//         DocumentSnapshot document = await _firestore.collection(collectionName).doc(docId).get();
//         response = document.exists ? document.data() : null;
//       } else {
//         // Get all documents in a collection
//         QuerySnapshot querySnapshot = await _firestore.collection(collectionName).get();
//         response = querySnapshot.docs.map((doc) => doc.data()).toList();
//       }
//
//       Get.find<GeneralController>().changeLoaderCheck(false);
//
//       if (response != null) {
//         executionMethod(true, response);
//       } else {
//         executionMethod(false, {'errors': ErrorStrings.no_data_found});
//       }
//     } on SocketException {
//       Get.find<GeneralController>().changeLoaderCheck(false);
//       if (!Get.find<GeneralController>().errorBoxShow) {
//         ResponseDialog.showError(ErrorStrings.no_internet_connected_try_again_later);
//       }
//       Get.find<GeneralController>().errorBoxShow = true;
//       log('Internet Not Connected');
//     } catch (e) {
//       Get.find<GeneralController>().changeLoaderCheck(false);
//       log('Firebase Firestore Error: $e');
//       executionMethod(false, {'errors': e.toString()});
//     }
//   }
//
//   // fetch a collection
// /*  FirebaseService().getFirestoreData(
//   collectionName: 'users',
//   executionMethod: (success, data) {
//   if (success) {
//   print("Users Data: $data");
//   } else {
//   print("Error: ${data['errors']}");
//   }
//   }
//   );*/
//
//
// // fetch a specific document
// /*  FirebaseService().getFirestoreData(
//   collectionName: 'users',
//   docId: 'user123',
//   executionMethod: (success, data) {
//     if (success) {
//       print("User Data: $data");
//     } else {
//       print("Error: ${data['errors']}");
//     }
//   }
// );
// */
// }
//
//
//
