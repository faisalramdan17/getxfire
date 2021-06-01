part of '../getxfire.dart';

class FileModel {
  String? url;
  String? filename;
  String? type;
  String? folder;
  DateTime? updatedAt;

  FileModel({this.url, this.filename, this.type, this.folder, this.updatedAt});

  FileModel copyWith({String? url, String? filename, DateTime? updatedAt}) =>
      FileModel(
        url: url ?? this.url,
        filename: filename ?? this.filename,
        type: type ?? this.type,
        folder: filename ?? this.folder,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  FileModel.fromJson(dynamic data) {
    url = data["url"];
    filename = data["filename"];
    type = data["type"];
    folder = data["folder"];
    updatedAt = data["updatedAt"]?.toDate();
  }

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "filename": filename == null ? null : filename,
        "type": type == null ? null : type,
        "folder": folder == null ? null : folder,
        "updatedAt": updatedAt == null ? null : updatedAt,
      };
}
