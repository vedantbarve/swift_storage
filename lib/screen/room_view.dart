import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:swift_storage/api/room_controller.dart';
import 'package:swift_storage/api/services/database.dart';
import 'package:swift_storage/api/services/encryption.dart';
import 'package:swift_storage/api/services/files.dart';
import 'package:swift_storage/global/snackbar.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../api/model/file_model.dart';
import '../global/const.dart';

final _roomCtr = Get.put(RoomController());
final _files = Get.put(FilesController());
final _database = Get.put(DataBaseController());
final _encryptCtr = Get.put(EncryptionController());

class RoomView extends StatelessWidget {
  const RoomView({super.key});

  @override
  Widget build(BuildContext context) {
    final roomId = Get.parameters["roomId"]!;
    final pass = Get.parameters["pass"];
    return LayoutBuilder(
      builder: (_, constraints) {
        return FutureBuilder(
          future: (pass == null)
              ? _database.hasAccess()
              : _database.onDynamicUrl(roomId, pass),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(
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
              );
            }
            if (snapshot.hasData) {
              final data = snapshot.data!;
              if (data) {
                return const RoomOnAccess();
              } else {
                return Scaffold(
                  appBar: AppBar(
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
                          "Looks like you dont have access to this room",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }
}

class RoomOnAccess extends StatelessWidget {
  const RoomOnAccess({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Room ID : ${_roomCtr.getRoomData.roomId}"),
        actions: [
          IconButton(
            onPressed: () async {
              final encryptedData = _encryptCtr.encryptData(
                _roomCtr.getRoomData.roomId,
                _roomCtr.getRoomData.password,
              );

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Scan QR code to join"),
                  content: SizedBox(
                    height: 200,
                    width: 200,
                    child: Center(
                      child: QrImage(
                        size: 200,
                        data:
                            "https://swift-storage.web.app/room/${_roomCtr.getRoomData.roomId}?pass=$encryptedData",
                      ),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.qr_code),
          ),
          IconButton(
            onPressed: () async {
              await FlutterClipboard.copy(_roomCtr.getRoomData.roomId).then(
                (value) => showSnackBar(
                  context,
                  "Room ID copied to clipboard",
                ),
              );
            },
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _files.selectAndUploadFiles().then(
            (value) {
              if (value == "roomSize") {
                showSnackBar(
                  context,
                  "Size of the room is greater than 20MB\nDelete some files",
                );
              } else if (value == "filesSize") {
                showSnackBar(
                  context,
                  "Size of the room will greater than 20MB",
                );
              }
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: GetBuilder(
        init: _files,
        builder: (ctr) {
          if (_files.loadingStatus == true) {
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: primary,
                    duration: const Duration(seconds: 100),
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
              },
            );
          }
          if (_files.loadingStatus == false) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }

          return StreamBuilder(
            stream: _files.getFilesAsStream(),
            builder: (
              context,
              AsyncSnapshot<QuerySnapshot<FileModel>> snapshot,
            ) {
              if (snapshot.hasData) {
                final files = snapshot.data!.docs;

                if (files.isEmpty) {
                  return const Center(
                    child: Text(
                      "No items yet",
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final item = files[index].data();
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (value) async {
                        await _files.deleteFile(
                          item.fullPath,
                          item.fileId,
                        );
                      },
                      background: Container(
                        color: Colors.redAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              "Delete",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      child: ListTile(
                        onTap: () async {
                          await launchUrlString(item.fileUrl);
                        },
                        leading: const Icon(Icons.folder),
                        title: const Text(
                          "Name : ",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          item.name,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () async {
                            await launchUrlString(item.fileUrl);
                          },
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }
}
