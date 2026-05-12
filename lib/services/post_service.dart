import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio_instance;
import 'package:dio/dio.dart';
import 'package:elite_csr/services/set_headers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/AppResource.dart';
import '../constants/keys.dart';
import '../general_controller/GeneralController.dart';
import '../widgets/dialog.dart';

enum MethodsTypes { post, put }

postMethod(String apiUrl, dynamic postData, Function executionMethod,
    {bool authHeader = false,
    dynamic queryParameters,
    String methodType = 'post'}) async {
  dio_instance.Response response;
  dio_instance.Dio dio = dio_instance.Dio();

  dio.options.connectTimeout = const Duration(minutes: 1);
  dio.options.receiveTimeout = const Duration(seconds: 30);

  setAcceptHeader(dio);
  setContentHeader(dio);
  setBasicAuthHeader(dio);
  if (authHeader) {
    final box = GetStorage();

    setCustomHeader(
        dio, 'Authorization', 'Bearer ${box.read(AppKeys.authToken)}');
  }
  Get.find<GeneralController>().errorBoxShow = false;
  try {
    // final result = await InternetAddress.lookup('google.com');
    // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    log('Internet Connected');
    Get.find<GeneralController>().changeLoaderCheck(true);
    try {
      log('postData--->> ${postData}');
      log('Url--->> ${apiUrl}');
      response = methodType == MethodsTypes.put.name
          ? await dio.put(apiUrl,
              data: postData,
              queryParameters: queryParameters,
              options: Options(method: methodType))
          : await dio.post(apiUrl,
              data: postData,
              queryParameters: queryParameters,
              options: Options(method: methodType));
      log('StatusCode------>> ${response.statusCode}');
      log('Post Response $apiUrl------>> $response');
      Get.find<GeneralController>().changeLoaderCheck(false);
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        executionMethod(true, response.data);
        return;
      }
      executionMethod(false, {'status': null});
    } on dio_instance.DioError catch (e) {
      print("exception:e:${e}");
      Get.find<GeneralController>().changeLoaderCheck(false);
      if (e.response?.statusCode == null) {
        ResponseDialog.showError(AppStrings.slow_internet);
        return;
      }
      if (e.response?.statusCode == 401) {
        suspendedUserHandle(e.response?.data);

        executionMethod(false, (e.response?.data));

        return;
      }
      // if (e.response?.statusCode == 401) {
      //   suspendedUserHandle(e.response?.data);
      //   // executionMethod(false, {'status': null});
      //   executionMethod(false, {e.response});
      //   return;
      // }
      if ((e.response?.statusCode ?? 500) > 500) {
        ResponseDialog.showError(AppStrings.server_error);
        log('Dio Error From -->> $e');
        return;
      }
      executionMethod(false, e.response?.data);
      log('Dio Error From Post $apiUrl -->> ${e.message}');
      log('Dio Error From Post data $apiUrl -->> ${e.response?.data}');
    }
    // }
  } on SocketException catch (e) {
    Get.find<GeneralController>().changeLoaderCheck(false);
    log('Internet Not Connected :${e.message}');
    if (!Get.find<GeneralController>().errorBoxShow)
      ResponseDialog.showError(e.message);
    // ResponseDialog.showError(AppStrings.internet_not_connected);
    Get.find<GeneralController>().errorBoxShow = true;
    // showSnackBar('Message', 'Internet Not Connected');
  }
}

///-----------Dio Function to Upload Image to server
Future<dio_instance.FormData> uploadFileFormData(String? file) async {
  dio_instance.FormData? formData;
  formData = dio_instance.FormData.fromMap(<String, dynamic>{
    'file': await dio_instance.MultipartFile.fromFile(
      File(file!).path,
    ),
  });
  return formData;
  // update();
}
