// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel? loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel? data) =>
    json.encode(data!.toJson());

class LoginResponseModel {
  LoginResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.settings,
  });

  int? statusCode;
  Data? data;
  String? message;
  List<dynamic>? settings;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        statusCode: json["status_code"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
        settings: json["settings"] == null
            ? []
            : List<dynamic>.from(json["settings"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": data!.toJson(),
        "message": message,
        "settings":
            settings == null ? [] : List<dynamic>.from(settings!.map((x) => x)),
      };
}

class Data {
  Data({
    this.accessToken,
    this.tokenType,
    this.user,
  });

  String? accessToken;
  String? tokenType;
  User? user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "user": user!.toJson(),
      };
}

class User {
  User({
    this.id,
    this.nama,
    this.initial,
    this.email,
    this.humanisId,
    this.humanisFoto,
    this.jabatan,
    this.levelJabatan,
    this.fotoUrl,
    this.fotoPp,
    this.updatedSecurity,
    this.akses,
    this.role,
    this.username,
    this.telepon,
    this.atasan,
  });

  int? id;
  String? nama;
  String? initial;
  String? email;
  int? humanisId;
  String? humanisFoto;
  String? jabatan;
  String? levelJabatan;
  String? fotoUrl;
  bool? fotoPp;
  dynamic updatedSecurity;
  String? akses;
  Role? role;
  dynamic username;
  String? telepon;
  String? atasan;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        nama: json["nama"],
        initial: json["initial"],
        email: json["email"],
        humanisId: json["humanis_id"],
        humanisFoto: json["humanis_foto"],
        jabatan: json["jabatan"],
        levelJabatan: json["level_jabatan"],
        fotoUrl: json["fotoUrl"],
        fotoPp: json["fotoPP"],
        updatedSecurity: json["updated_security"],
        akses: json["akses"],
        role: Role.fromJson(json["role"]),
        username: json["username"],
        telepon: json["telepon"],
        atasan: json["atasan_langsung"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "initial": initial,
        "email": email,
        "humanis_id": humanisId,
        "humanis_foto": humanisFoto,
        "jabatan": jabatan,
        "level_jabatan": levelJabatan,
        "fotoUrl": fotoUrl,
        "fotoPP": fotoPp,
        "updated_security": updatedSecurity,
        "akses": akses,
        "role": role!.toJson(),
        "username": username,
        "telepon": telepon,
        "atasan_langsung": atasan,
      };
}

class Role {
  Role({
    this.id,
    this.nama,
    this.akses,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
  });

  int? id;
  String? nama;
  String? akses;
  String? isDeleted;
  dynamic createdAt;
  String? updatedAt;
  dynamic deletedAt;
  int? createdBy;
  int? updatedBy;
  int? deletedBy;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        nama: json["nama"],
        akses: json["akses"],
        isDeleted: json["is_deleted"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        deletedBy: json["deleted_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "akses": akses,
        "is_deleted": isDeleted,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "deleted_by": deletedBy,
      };
}
