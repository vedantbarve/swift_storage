import 'package:flutter/material.dart';

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
