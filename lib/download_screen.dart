import 'package:flutter/material.dart';
import 'file_download.dart';


class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  String percent = '0.0';
  double progressive = 0.0;

  Future _startDownload() async{
    await FileDownload().startDownloading(context, (receivedBytes, totalBytes) {
      setState(() {
        progressive = receivedBytes / totalBytes;
      });
    });
  }

  @override
  void initState() {
    _startDownload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String downloadingProgress = (progressive * 100).toInt().toString();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('($downloadingProgress %)'),
                  const Text('در حال دانلود'),
                ],
              ),),
              LinearProgressIndicator(
                value: progressive,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 10.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
