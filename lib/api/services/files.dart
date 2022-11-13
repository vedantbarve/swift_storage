import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:swift_storage/global/const.dart';
import 'package:uuid/uuid.dart';

import '../model/file_model.dart';
import '../room_controller.dart';

final _roomCtr = Get.put(RoomController());
final _firebaseStorage = FirebaseStorage.instance;
final _firestore = FirebaseFirestore.instance;

class FilesController extends GetxController {
  bool _isLoading = false;

  bool get loadingStatus => _isLoading;

  setIsLoading(bool value) {
    _isLoading = value;
    update();
  }

  Stream<QuerySnapshot<FileModel>> getFilesAsStream() {
    return _firestore
        .collection("files")
        .where("roomId", isEqualTo: _roomCtr.getRoomData.roomId)
        .withConverter(
          fromFirestore: (data, __) => FileModel.fromMap(data.data()!),
          toFirestore: (doc, __) => doc.toMap(),
        )
        .snapshots();
  }

  Future<dynamic> selectAndUploadFiles() async {
    final _roomSize = await getRoomSize();
    int _filesSize = 0;
    if (_roomSize > roomSizeLimit) {
      return "roomSize";
    }
    final data = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowCompression: true,
    );

    for (var element in data!.files) {
      _filesSize += element.size;
    }

    if (_filesSize > roomSizeLimit) {
      return "filesSize";
    }
    setIsLoading(true);
    for (var element in data.files) {
      final fileId = const Uuid().v4();
      await _firebaseStorage
          .ref("rooms/${_roomCtr.getRoomData.roomId}/${element.name}")
          .putData(element.bytes!);

      final fullPath = _firebaseStorage
          .ref("rooms/${_roomCtr.getRoomData.roomId}/${element.name}")
          .fullPath;
      final fileUrl = await _firebaseStorage
          .ref("rooms/${_roomCtr.getRoomData.roomId}/${element.name}")
          .getDownloadURL();
      final fileData = FileModel(
        roomId: _roomCtr.getRoomData.roomId,
        name: element.name,
        fullPath: fullPath,
        fileUrl: fileUrl,
        size: element.size,
        fileId: fileId,
      ).toMap();
      await _firestore.doc("files/$fileId").set(fileData);
    }
    setIsLoading(false);
  }

  Future deleteFile(String filePath, String fileId) async {
    await _firestore.doc("files/$fileId").delete();
    await FirebaseStorage.instance.ref(filePath).delete();
  }

  Future<int> getRoomSize() async {
    int totalSize = 0;
    final data = await _firestore
        .collection("files")
        .where("roomId", isEqualTo: _roomCtr.getRoomData.roomId)
        .get();

    for (var element in data.docs) {
      final file = FileModel.fromMap(element.data());
      totalSize += file.size;
    }
    return totalSize;
  }
}
