import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../api/model/file_model.dart';
import '../../api/room_controller.dart';
import '../../api/services/encryption.dart';
import '../../api/services/files.dart';
import '../../global/snackbar.dart';

final _filesCtr = Get.put(FilesController());
final _roomCtr = Get.put(RoomController());
final _encryptCtr = Get.put(EncryptionController());

class RoomOnAccess extends StatelessWidget {
  const RoomOnAccess({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomId = Get.parameters["roomId"];
    return Title(
      title: 'Room : $roomId',
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Room ID : ${_roomCtr.getRoomData.roomId}"),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          10,
                        ),
                      ),
                    ),
                    actionsPadding: const EdgeInsets.all(14.0),
                    title: const Text(
                      "Are you sure you want to leave this room?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Back",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Get.offAllNamed('/'),
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Confirm",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          actions: const [
            QrCodeButton(),
            CopyToClipBoardButton(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _filesCtr.selectAndUploadFiles().then(
              (value) {
                if (value == "roomSize") {
                  showSnackBar(
                    context,
                    "Size of the room is greater than 50MB\nDelete some files",
                  );
                } else if (value == "filesSize") {
                  showSnackBar(
                    context,
                    "Size of the room will greater than 50MB",
                  );
                }
              },
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: GetBuilder(
          init: _filesCtr,
          builder: (ctr) {
            if (_filesCtr.loadingStatus == true) {
              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) {
                  showUploadingData(context);
                },
              );
            }
            if (_filesCtr.loadingStatus == false) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }

            return StreamBuilder(
              stream: _filesCtr.getFilesAsStream(),
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
                      return CustomListTile(item: item);
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
      ),
    );
  }
}

class QrCodeButton extends StatelessWidget {
  const QrCodeButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final encryptedData = _encryptCtr.encryptData(
          _roomCtr.getRoomData.roomId,
          _roomCtr.getRoomData.password,
        );
        const baseUrl = "https://swift-storage.web.app/";
        final roomId = _roomCtr.getRoomData.roomId;
        final url = "$baseUrl/room/$roomId?pass=$encryptedData";
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Scan QR code to join"),
            content: SizedBox(
              height: 200,
              width: 200,
              child: Center(
                child: QrImageView(
                  data: url,
                  size: 200,
                ),
              ),
            ),
          ),
        );
      },
      icon: const Icon(
        Icons.qr_code,
        color: Colors.white,
      ),
    );
  }
}

class CopyToClipBoardButton extends StatelessWidget {
  const CopyToClipBoardButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await FlutterClipboard.copy(_roomCtr.getRoomData.roomId).then(
          (value) => showSnackBar(
            context,
            "Room ID copied to clipboard",
          ),
        );
      },
      icon: const Icon(
        Icons.copy,
        color: Colors.white,
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  final FileModel item;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (value) async {
        await _filesCtr.deleteFile(
          item.fullPath,
          item.fileId,
        );
      },
      background: Container(
        color: Colors.redAccent,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
  }
}
