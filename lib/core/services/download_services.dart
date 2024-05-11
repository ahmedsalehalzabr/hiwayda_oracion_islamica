import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart';
import 'package:hiwayda_oracion_islamica/core/widgets/dialogs/download_dialogs.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';

class DownloadServices extends GetxService {
  /// state
  final RxBool isDownloading = false.obs;

  /// file size
  final RxDouble total = 0.0.obs;

  /// file downloaded data size
  final RxDouble received = 0.0.obs;

  final CancelToken _cancelToken = CancelToken();

  Future<String> _getDownloadDirectory() async {
    Directory? directory = Directory('/storage/emulated/0/Download');
    if (!await directory.exists()) {
      directory = await path_provider.getExternalStorageDirectory();
    }
    return directory?.path ?? '';
  }

  Dio _createDio({required String baseUrl}) {
    // initialize dio
    final dio = Dio()..options.baseUrl = baseUrl;

    // allow self-signed certificate
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();

      /// set function return  false if you want to allow ssl check
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };
    return dio;
  }

  download(
      {required String url,
      required String fileName,
      bool showProgressDialog = true,
      bool showSuccessDialog = true,
      bool showFailDialog = true}) async {
    try {
      if (!isDownloading.value &&
          await DownloadDialog.showConfirmDownloadDialog(fileName)) {
        isDownloading.toggle();

        if ((await Permission.storage.request()).isGranted) {
          final splited = url.split('/');
          String baseUrl = '';
          String urlFileName = '';
          for (var i = 0; i < splited.length; i++) {
            if (i == splited.length - 1) {
              urlFileName = "/${splited[i]}";
            } else {
              if (i != 0) {
                baseUrl += '/';
              }
              baseUrl += splited[i];
            }
          }

          final path = await _getDownloadDirectory();

          final Dio dio = _createDio(baseUrl: baseUrl);

          dio.download(urlFileName, "$path/$fileName",
              onReceiveProgress: (rec, tot) {
            received.value = rec / 1000;
            total.value = tot / 1000;
          }, cancelToken: _cancelToken).then((value) {
            isDownloading.toggle();
            if (Get.isDialogOpen == true) {
              Get.back();
            }
            DownloadDialog.showSuccessDialog(fileName, "$path/$fileName");
            isDownloading.toggle();
          }).onError((error, stackTrace) {
            DownloadDialog.showErrorDialog(
                fileName, () => download(url: url, fileName: fileName));
            isDownloading.toggle();
          });
          DownloadDialog.showDownloadProgress(fileName, () {
            Get.back();
            _cancelToken.cancel();
            total.value = 0;
            received.value = 0;
            isDownloading.value = false;
          });
        }
      } else {
        if (isDownloading.value) {
          DownloadDialog.showNotCompeletedDownloadSnakbar(fileName);
        }
      }
    } catch (e) {
      isDownloading.value = false;
    }
  }
}