import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:swift_storage/api/model/room_model.dart';
import 'package:swift_storage/api/room_controller.dart';
import 'package:swift_storage/global/const.dart';
import 'encryption.dart';

class DataBaseController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  final _roomCtr = Get.put(RoomController());
  final _encryptCtr = Get.put(EncryptionController());
  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> createRoom(String roomId, String password) async {
    final roomData = RoomModel(
      roomId: roomId,
      password: password,
      timeStamp: DateTime.now().toIso8601String(),
      accessList: [
        _firebaseAuth.currentUser!.uid,
      ],
    );
    await _firestore.doc("rooms/$roomId").set(roomData.toMap());
  }

  Future<Status> joinRoom(String roomId, String password) async {
    final room = await _firestore.doc("rooms/$roomId").get();
    final roomData = RoomModel.fromMap(room.data()!);
    if (room.exists) {
      bool isValid = (roomData.password == password);
      if (isValid) {
        roomData.accessList.add(_firebaseAuth.currentUser!.uid);
        await _firestore.doc("rooms/$roomId").set(roomData.toMap());
        return Status.approved;
      } else if (!isValid) {
        return Status.denied;
      }
    } else {
      return Status.noRoom;
    }
    return Status.unknown;
  }

  Future<Status> validateUser() async {
    final roomId = Get.parameters["roomId"];
    final pass = Get.parameters["pass"];

    final data = await _firestore.doc("rooms/$roomId").get();
    if (!data.exists) {
      return Status.noRoom;
    }
    final roomData = RoomModel.fromMap(data.data()!);

    if (roomId != null && pass != null) {
      final password = _encryptCtr.decryptData(roomId, pass);
      if (roomData.password == password) {
        roomData.accessList.add(_uid);
        await _firestore.doc("rooms/$roomId").set(roomData.toMap());
        _roomCtr.setRoomData(roomData);
        return Status.approved;
      } else if (roomData.password != password) {
        return Status.denied;
      }
    } else {
      final hasAccess = roomData.accessList.contains(_uid);
      if (hasAccess) {
        _roomCtr.setRoomData(roomData);
        return Status.approved;
      } else {
        return Status.denied;
      }
    }
    return Status.unknown;
  }
}
