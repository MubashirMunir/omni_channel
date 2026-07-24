import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio_instance;
import 'package:elite_csr/services/set_headers.dart';
import 'package:get/get.dart';
import '../constants/AppResource.dart';
import '../constants/keys.dart';
import '../general_controller/GeneralController.dart';
import '../widgets/dialog.dart';

deleteMethod(String apiUrl, dynamic postData, Function executionMethod,
    {bool authHeader = false, dynamic queryParameters}
    // for performing functionalities
    ) async {
  dio_instance.Response response;
  dio_instance.Dio dio = dio_instance.Dio();

  dio.options.connectTimeout = const Duration(minutes: 1);
  dio.options.receiveTimeout = const Duration(seconds: 30);

  setAcceptHeader(dio);
  setContentHeader(dio);
  setBasicAuthHeader(dio);
  if (authHeader) {
    setCustomHeader(dio, 'Authorization',
        'Bearer ${Get.find<GeneralController>().box.read(AppKeys.authToken)}');
  }

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      log('Internet Connected');
      Get.find<GeneralController>().changeLoaderCheck(true);
      try {
        log('postData--->> $postData');
        response = await dio.delete(apiUrl,
            data: postData, queryParameters: queryParameters);

        log('StatusCode------>> ${response.statusCode}');
        log('Delete Response $apiUrl------>> $response');
        Get.find<GeneralController>().changeLoaderCheck(false);
        if (response.statusCode! >= 200 && response.statusCode! <= 299) {
          print(response.data);
          executionMethod(true, response.data);
          return;
        }
        executionMethod(false, {'status': null});
      } on dio_instance.DioError catch (e) {
        Get.find<GeneralController>().changeLoaderCheck(false);
        if (e.response?.statusCode == 401) {
          suspendedUserHandle(e.response?.data);
        }
        if ((e.response?.statusCode ?? 500) >= 500) {
          ResponseDialog.showError(AppStrings.server_error);
          // showSnackBar('Error', 'Server Error!.Please Try again later');
          log('Dio Error From -->> $e');
          return;
        }
//JobStitching|18|2|11|3|1|8|3|100|250.00|23-Feb-2026

        executionMethod(false, e.response?.data);
        log('Dio Error From Delete $apiUrl -->> ${e.message}');
      }
    }
  } on SocketException catch (e) {
    Get.find<GeneralController>().changeLoaderCheck(false);
    log('Internet Not Connected');
    ResponseDialog.showError(AppStrings.internet_not_connected);
  }
}
