import 'dart:convert';

class FileModel {
  final String name;
  final String roomId;
  final String fileId;
  final String fullPath;
  final String fileUrl;
  final int size;
  FileModel({
    required this.name,
    required this.roomId,
    required this.fileId,
    required this.fullPath,
    required this.fileUrl,
    required this.size,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'roomId': roomId,
      'fileId': fileId,
      'fullPath': fullPath,
      'fileUrl': fileUrl,
      'size': size,
    };
  }

  factory FileModel.fromMap(Map<String, dynamic> map) {
    return FileModel(
      name: map['name'] ?? '',
      roomId: map['roomId'] ?? '',
      fileId: map['fileId'] ?? '',
      fullPath: map['fullPath'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      size: map['size']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory FileModel.fromJson(String source) =>
      FileModel.fromMap(json.decode(source));
}
