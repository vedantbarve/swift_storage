import 'package:flutter/material.dart';

pushReplacement(BuildContext context, Widget widget) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => widget),
  );
}

pushRoute(BuildContext context, Widget widget) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => widget),
  );
}
