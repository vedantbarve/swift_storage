import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:swift_storage/api/model/room_model.dart';

import 'services/database.dart';

class RoomController extends GetxController {
  late RoomModel _roomData;

  RoomModel get getRoomData => _roomData;

  void setRoomData(RoomModel roomData) {
    _roomData = roomData;
    update();
  }

  Future updateDeleteDate(DateTime value) async {
    _roomData.deleteDate = DateTime(
      value.year,
      value.month,
      value.day,
      23,
      59,
      59,
    ).toIso8601String();
    await DataBaseController().updateRoom(_roomData);
    update();
  }
}
