import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart';

class FileDownload {
  Dio dio = Dio();
  bool isSuccess = false;
  Future startDownloading(BuildContext context, final Function okCallback) async {
    String fileName = "vosk-model-small-fa-0.4.zip";

    String baseUrl =  "https://alphacephei.com/vosk/models/vosk-model-small-fa-0.4.zip";

    String path = await _getFilePath(fileName);
    try {
      await dio.download(
        baseUrl,
        path,
        onReceiveProgress: (receivedBytes, totalBytes) {
          okCallback(receivedBytes, totalBytes);
        },
        deleteOnError: true,
      ).then((_) {
        isSuccess = true;
      });
    } catch (e) {
      print("Exception$e");
    }

    if (isSuccess) {
      if(context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SpeechToText()));
      }
    }
  }

  Future<String> _getFilePath(String filename) async {
    Directory? dir;

    try {
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory(); // for iOS
      } else {
        dir = Directory('/storage/emulated/0/Download/');  // for android
        if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
      }
    } catch (err) {
      print("Cannot get download folder path $err");
    }
    return "${dir?.path}$filename";
  }
}