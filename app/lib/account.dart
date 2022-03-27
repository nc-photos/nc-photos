import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nc_photos/ci_string.dart';
import 'package:nc_photos/object_extension.dart';
import 'package:nc_photos/or_null.dart';
import 'package:nc_photos/string_extension.dart';
import 'package:nc_photos/type.dart';

/// Details of a remote Nextcloud server account
class Account with EquatableMixin {
  Account(
    this.id,
    this.scheme,
    String address,
    this.username,
    this.password,
    this.altHomeDir,
    List<String> roots,
  )   : address = address.trimRightAny("/"),
        _roots = roots.map((e) => e.trimRightAny("/")).toList() {
    if (scheme != "http" && scheme != "https") {
      throw const FormatException("scheme is neither http or https");
    }
  }

  Account copyWith({
    String? id,
    String? scheme,
    String? address,
    CiString? username,
    String? password,
    OrNull<CiString>? altHomeDir,
    List<String>? roots,
  }) {
    return Account(
      id ?? this.id,
      scheme ?? this.scheme,
      address ?? this.address,
      username ?? this.username,
      password ?? this.password,
      altHomeDir == null ? this.altHomeDir : altHomeDir.obj,
      roots ?? List.of(_roots),
    );
  }

  static String newId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(0xFFFFFF);
    return "${timestamp.toRadixString(16)}-${random.toRadixString(16).padLeft(6, '0')}";
  }

  @override
  toString() {
    return "$runtimeType {"
        "id: '$id', "
        "scheme: '$scheme', "
        "address: '${kDebugMode ? address : "***"}', "
        "username: '${kDebugMode ? username : "***"}', "
        "password: '${password.isNotEmpty == true ? (kDebugMode ? password : '***') : null}', "
        "altHomeDir: '${altHomeDir == null || kDebugMode ? altHomeDir : "***"}', "
        "roots: List {'${roots.join('\', \'')}'}, "
        "}";
  }

  Account.fromJson(JsonObj json)
      : id = json["id"],
        scheme = json["scheme"],
        address = json["address"],
        username = CiString(json["username"]),
        password = json["password"],
        altHomeDir = (json["altHomeDir"] as String?)?.run((v) => CiString(v)),
        _roots = json["roots"].cast<String>();

  JsonObj toJson() => {
        "id": id,
        "scheme": scheme,
        "address": address,
        "username": username.toString(),
        "password": password,
        "altHomeDir": altHomeDir?.toString(),
        "roots": _roots,
      };

  @override
  get props => [id, scheme, address, username, password, altHomeDir, _roots];

  List<String> get roots => _roots;

  CiString get homeDir => altHomeDir ?? username;

  final String id;
  final String scheme;
  final String address;
  final CiString username;
  final String password;

  /// Name of the user home dir. Normally [username] is used as the home dir
  /// name, but for LDAP users, their home dir might be named differently
  final CiString? altHomeDir;
  final List<String> _roots;
}

extension AccountExtension on Account {
  String get url => "$scheme://$address";

  /// Compare the server identity of two Accounts
  ///
  /// Return true if two Accounts point to the same user on server. Be careful
  /// that this does NOT mean that the two Accounts are identical (e.g., they
  /// can have difference password)
  bool compareServerIdentity(Account other) {
    return scheme == other.scheme &&
        address == other.address &&
        username == other.username;
  }
}