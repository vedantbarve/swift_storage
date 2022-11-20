import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomOnError extends StatelessWidget {
  const RoomOnError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomId = Get.parameters["roomId"];
    return Title(
      color: Colors.black,
      title: "Room : $roomId",
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Get.back(),
          ),
          title: Text("Room ID : $roomId"),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.warning,
                color: Colors.redAccent,
                size: 64,
              ),
              SizedBox(height: 14),
              Text(
                "Oops! Something went wrong.\nPlease try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
