import 'dart:convert';

class RoomModel {
  final String roomId;
  final String password;
  final String timeStamp;
  final List accessList;

  RoomModel({
    required this.roomId,
    required this.password,
    required this.timeStamp,
    required this.accessList,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'password': password,
      'timeStamp': timeStamp,
      'accessList': accessList,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomId: map['roomId'] ?? '',
      password: map['password'] ?? '',
      timeStamp: map['timeStamp'] ?? '',
      accessList: map['accessList'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source));
}
