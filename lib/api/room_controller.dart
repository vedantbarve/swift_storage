import 'package:get/get.dart';

class RoomController extends GetxController {
  String _roomId = "";
  bool _isAuthenticated = false;

  String get getRoomId => _roomId;
  bool get getAuthStatus => _isAuthenticated;

  void setAuthStatus(bool value) {
    _isAuthenticated = value;
    update();
  }

  void setRoomId(String value) {
    _roomId = value;
    update();
  }
}
