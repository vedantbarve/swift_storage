import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:get/get.dart';
import 'package:swift_storage/api/model/room_model.dart';
import 'package:swift_storage/api/room_controller.dart';

class DataBaseController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  final _roomCtr = Get.put(RoomController());

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

  Future<bool> hasAccess(String roomId) async {
    final data = await _firestore.doc("rooms/$roomId").get();
    final roomData = RoomModel.fromMap(data.data()!);
    final hasAccess = roomData.accessList.contains(
      _firebaseAuth.currentUser!.uid,
    );
    if (hasAccess) {
      _roomCtr.setRoomData(roomData);
      return true;
    } else {
      return false;
    }
  }

  Future<dynamic> joinRoom(String roomId, String password) async {
    final room = await _firestore.doc("rooms/$roomId").get();
    final roomData = RoomModel.fromMap(room.data()!);
    if (room.exists) {
      bool isValid = (roomData.password == password);
      if (isValid) {
        roomData.accessList.add(_firebaseAuth.currentUser!.uid);
        await _firestore.doc("rooms/$roomId").set(roomData.toMap());
      }
      return isValid;
    } else {
      return "No room found";
    }
  }
}
