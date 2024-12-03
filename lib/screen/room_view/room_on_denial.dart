import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomOnDenial extends StatelessWidget {
  const RoomOnDenial({super.key});

  @override
  Widget build(BuildContext context) {
    final roomId = Get.parameters["roomId"];
    return Title(
      title: "Room : $roomId",
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Get.back(),
          ),
          title: Text("Room ID : $roomId"),
        ),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning,
                color: Colors.redAccent,
                size: 64,
              ),
              SizedBox(height: 14),
              Text(
                "Looks like you don't have access to this room",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
