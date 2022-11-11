import 'dart:convert';

class RoomModel {
  final String roomId;
  final String password;
  final String timeStamp;
  RoomModel({
    required this.roomId,
    required this.password,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'password': password,
      'timeStamp': timeStamp,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomId: map['roomId'] ?? '',
      password: map['password'] ?? '',
      timeStamp: map['timeStamp'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source));
}
