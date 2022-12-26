import 'dart:convert';

class RoomModel {
  final String roomId;
  final String password;
  final String timeStamp;
  final List accessList;
  final String authorId;
  final String firstDate;
  final String lastdate;
  String deleteDate;

  RoomModel({
    required this.roomId,
    required this.password,
    required this.timeStamp,
    required this.accessList,
    required this.authorId,
    required this.firstDate,
    required this.lastdate,
    required this.deleteDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'password': password,
      'timeStamp': timeStamp,
      'accessList': accessList,
      'authorId': authorId,
      'firstDate': firstDate,
      'lastdate': lastdate,
      'deleteDate': deleteDate,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomId: map['roomId'] ?? '',
      password: map['password'] ?? '',
      timeStamp: map['timeStamp'] ?? '',
      accessList: List.from(map['accessList']),
      authorId: map['authorId'] ?? '',
      firstDate: map['firstDate'] ?? '',
      lastdate: map['lastdate'] ?? '',
      deleteDate: map['deleteDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomModel.fromJson(String source) =>
      RoomModel.fromMap(json.decode(source));
}
