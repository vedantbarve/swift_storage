import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../model/file_model.dart';
import '../room_controller.dart';

final _roomCtr = Get.put(RoomController());
final _firebaseStorage = FirebaseStorage.instance;
final _firestore = FirebaseFirestore.instance;

class FilesController extends GetxController {
  Stream<QuerySnapshot<FileModel>> getFilesAsStream() {
    return _firestore
        .collection("files")
        .where("roomId", isEqualTo: _roomCtr.getRoomId)
        .withConverter(
            fromFirestore: (data, __) => FileModel.fromMap(data.data()!),
            toFirestore: (doc, __) => doc.toMap())
        .snapshots();
  }

  Future<dynamic> selectAndUploadFiles() async {
    final roomSize = await getRoomSize();
    int filesSize = 0;
    if (roomSize > 20971520) {
      return "roomSize";
    }
    final data = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    for (var element in data!.files) {
      filesSize += element.size;
    }

    if (filesSize > 20971520) {
      return "filesSize";
    }

    for (var element in data.files) {
      final fileId = const Uuid().v4();
      final uploadTask = await _firebaseStorage
          .ref("rooms/${_roomCtr.getRoomId}/${element.name}")
          .putData(element.bytes!);
      final fileUrl = await _firebaseStorage
          .ref("rooms/${_roomCtr.getRoomId}/${element.name}")
          .getDownloadURL();
      final fileData = FileModel(
        roomId: _roomCtr.getRoomId,
        name: element.name,
        fullPath: uploadTask.metadata!.fullPath,
        fileUrl: fileUrl,
        size: uploadTask.totalBytes,
        fileId: fileId,
      ).toMap();
      await _firestore.doc("files/$fileId").set(fileData);
    }

    update();
  }

  Future deleteFile(String filePath, String fileId) async {
    await _firestore.doc("files/$fileId").delete();
    await FirebaseStorage.instance.ref(filePath).delete();
  }

  Future<int> getRoomSize() async {
    int totalSize = 0;
    final data = await _firestore
        .collection("files")
        .where("roomId", isEqualTo: _roomCtr.getRoomId)
        .get();

    for (var element in data.docs) {
      final file = FileModel.fromMap(element.data());
      totalSize += file.size;
    }
    return totalSize;
  }
}
