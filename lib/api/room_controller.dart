import 'package:get/get.dart';
import 'package:swift_storage/api/model/room_model.dart';

class RoomController extends GetxController {
  late RoomModel _roomData;

  RoomModel get getRoomData => _roomData;

  void setRoomData(RoomModel roomData) {
    _roomData = roomData;
    update();
  }
}
