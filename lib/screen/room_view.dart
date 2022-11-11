import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swift_storage/api/room_controller.dart';
import 'package:swift_storage/api/services/files.dart';
import 'package:swift_storage/global/colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../api/model/file_model.dart';

final _roomCtr = Get.put(RoomController());
final _files = Get.put(FilesController());

class RoomView extends StatelessWidget {
  const RoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RoomId : ${_roomCtr.getRoomId}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _files.selectAndUploadFiles().then(
            (value) {
              if (value == "roomSize") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: primary,
                    content: Text(
                      "Size of the room is greater than 20MB\nDelete some files",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else if (value == "filesSize") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: primary,
                    content: Text(
                      "Size of the room will greater than 20MB",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
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
                    final item = files[index];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (value) async {
                        await _files.deleteFile(
                          item.data().fullPath,
                          item.data().fileId,
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
                        onTap: () {
                          print(item.data().toMap());
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
                          item.data().name,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.download),
                          onPressed: () async {
                            await launchUrlString(item.data().fileUrl);
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
