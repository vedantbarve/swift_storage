import 'package:flutter/material.dart';

import 'const.dart';

showSnackBar(
  BuildContext context,
  String data, {
  Duration? duration,
  Color? color,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      duration: duration ?? const Duration(seconds: 2),
      content: Text(
        data,
        style: const TextStyle(
          fontFamily: "Poppins",
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

showUploadingData(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: primary,
      duration: const Duration(days: 365),
      content: Row(
        children: const [
          SizedBox(
            height: 26,
            width: 26,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 14),
          Text(
            "Uploading data to cloud",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
