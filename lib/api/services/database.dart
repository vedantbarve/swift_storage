import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseController {
  final _firestore = FirebaseFirestore.instance;
  Future createRoom(String roomId, String password) async {
    await _firestore.doc("rooms/$roomId").set(
      {
        "roomId": roomId,
        "password": password,
        "timeStamp": DateTime.now().toIso8601String(),
      },
    );
  }

  Future<dynamic> authenticate(String roomId, String password) async {
    final room = await _firestore.doc("rooms/$roomId").get();
    if (room.exists) {
      return (room.data()!["password"] == password);
    } else {
      return "No room found";
    }
  }
}
