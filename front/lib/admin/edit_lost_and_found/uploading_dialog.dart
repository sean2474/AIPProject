import 'dart:async';

import 'package:flutter/material.dart';

class UploadingDialog extends StatefulWidget {
  const UploadingDialog({super.key});

  @override
  _UploadingDialogState createState() => _UploadingDialogState();
}

class _UploadingDialogState extends State<UploadingDialog> {
  String uploadingText = "uploading";
  Timer? uploadingTimer;

  @override
  void initState() {
    super.initState();
    startUploadingAnimation();
  }

  @override
  void dispose() {
    stopUploadingAnimation();
    super.dispose();
  }

  void startUploadingAnimation() {
    int counter = 0;
    uploadingTimer = Timer.periodic(Duration(milliseconds: 300), (Timer t) {
      setState(() {
        if (counter % 6 == 0) {
          uploadingText = "Uploading";
        } else if (counter % 6 == 1) {
          uploadingText = "Uploading.";
        } else if (counter % 6 == 2) {
          uploadingText = "Uploading..";
        } else if (counter % 6 == 3) {
          uploadingText = "Uploading...";
        } else if (counter % 6 == 4) {
          uploadingText = "Uploading..";
        } else if (counter % 6 == 5) {
          uploadingText = "Uploading.";
        }
        counter++;
      });
    });
  }

  void stopUploadingAnimation() {
    if (uploadingTimer != null) {
      uploadingTimer!.cancel();
      uploadingTimer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            uploadingText,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
