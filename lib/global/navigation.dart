import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

pushReplacement(BuildContext context, String roomId) {
  Beamer.of(context).beamToReplacementNamed('/room/$roomId');
}

pushRoute(BuildContext context, Widget widget) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => widget),
  );
}
