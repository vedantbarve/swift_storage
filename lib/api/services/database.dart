import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:swift_storage/api/model/room_model.dart';
import 'package:swift_storage/api/room_controller.dart';

class DataBaseController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _roomCtr = Get.put(RoomController());

  Future<void> setRoomData(String roomId) async {
    final data = await _firestore.doc("rooms/$roomId").get();
    _roomCtr.setRoomData(RoomModel.fromMap(data.data()!));
    update();
  }

  Future<void> createRoom(String roomId, String password) async {
    final roomData = RoomModel(
      roomId: roomId,
      password: password,
      timeStamp: DateTime.now().toIso8601String(),
    );
    await _firestore.doc("rooms/$roomId").set(roomData.toMap());
    _roomCtr.setRoomData(roomData);
    update();
  }

  Future<dynamic> joinRoom(String roomId, String password) async {
    final room = await _firestore.doc("rooms/$roomId").get();
    if (room.exists) {
      bool isValid = (room.data()!["password"] == password);
      if (isValid) {
        _roomCtr.setRoomData(RoomModel.fromMap(room.data()!));
      }
      return isValid;
    } else {
      return "No room found";
    }
  }
}
