import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swift_storage/api/services/database.dart';
import 'package:swift_storage/global/snackbar.dart';

final _dbCtr = Get.put(DataBaseController());

class RoomOnError extends StatelessWidget {
  final Object? error;
  const RoomOnError({Key? key, this.error}) : super(key: key);

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
            children: [
              const Icon(
                Icons.warning,
                color: Colors.redAccent,
                size: 64,
              ),
              const SizedBox(height: 14),
              const Text(
                "Oops! Something went wrong.\nPlease try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: () async {
                  await _dbCtr.logError(error).then(
                        (value) => showSnackBar(
                          context,
                          "Thank you for logging this error.\nPlease try again or access the room by password.",
                        ),
                      );
                },
                icon: const Icon(Icons.error),
                label: const Text("Report error"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
