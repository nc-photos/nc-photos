import 'dart:math';

import 'package:clock/clock.dart';
import 'package:copy_with/copy_with.dart';
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_common/type.dart';
import 'package:np_log/np_log.dart';
import 'package:np_string/np_string.dart';
import 'package:to_string/to_string.dart';

part 'account.g.dart';

/// Details of a remote Nextcloud server account
@genCopyWith
@npLog
@toString
class Account with EquatableMixin {
  Account({
    required this.id,
    required this.scheme,
    required String address,
    required this.userId,
    required this.username2,
    required this.password,
    required List<String> roots,
  }) : address = address.trimRightAny("/"),
       roots = roots.map((e) => e.trimRightAny("/")).toList() {
    if (scheme != "http" && scheme != "https") {
      throw const FormatException("scheme is neither http or https");
    }
  }

  static String newId() {
    final timestamp = clock.now().millisecondsSinceEpoch;
    final random = Random().nextInt(0xFFFFFF);
    return "${timestamp.toRadixString(16)}-${random.toRadixString(16).padLeft(6, '0')}";
  }

  @override
  String toString() => _$toString();

  static Account? fromJson(
    JsonObj json, {
    required AccountUpgraderV1? upgraderV1,
  }) {
    final jsonVersion = json["version"] ?? 1;
    JsonObj? result = json;
    if (jsonVersion < 2) {
      result = upgraderV1?.call(result);
      if (result == null) {
        _log.info("[fromJson] Version $jsonVersion not compatible");
        return null;
      }
    }
    return Account(
      id: result["id"],
      scheme: result["scheme"],
      address: result["address"],
      userId: CiString(result["userId"]),
      username2: result["username2"],
      password: result["password"],
      roots: result["roots"].cast<String>(),
    );
  }

  JsonObj toJson() => {
    "version": version,
    "id": id,
    "scheme": scheme,
    "address": address,
    "userId": userId.toString(),
    "username2": username2,
    "password": password,
    "roots": roots,
  };

  @override
  get props => [id, scheme, address, userId, username2, password, roots];

  final String id;
  final String scheme;
  @Format(r"${isDevMode ? $? : '***'}")
  final String address;
  // For non LDAP users, this is the username used to sign in
  @Format(r"${isDevMode ? $? : '***'}")
  final CiString userId;
  // Username used to sign in. For non-LDAP users, this is identical to userId
  @Format(r"${isDevMode ? $? : '***'}")
  final String username2;
  @Format(r"${$?.isNotEmpty ? (isDevMode ? $? : '***') : null}")
  final String password;

  @deepCopy
  @Format(r"${$?.toReadableString()}")
  final List<String> roots;

  /// versioning of this class, use to upgrade old persisted accounts
  static const version = 2;

  static final _log = _$AccountNpLog.log;
}

extension AccountExtension on Account {
  String get url => "$scheme://$address";

  Uri get uri {
    final pos = address.trimAny("/").indexOf("/");
    final String authority, path;
    if (pos == -1) {
      authority = address;
      path = "";
    } else {
      authority = address.substring(0, pos);
      path = address.substring(pos);
    }
    if (scheme == "http") {
      return Uri.http(authority, path);
    } else {
      return Uri.https(authority, path);
    }
  }

  /// Compare the server identity of two Accounts
  ///
  /// Return true if two Accounts point to the same user on server. Be careful
  /// that this does NOT mean that the two Accounts are identical (e.g., they
  /// can have different password)
  bool compareServerIdentity(Account other) {
    return scheme == other.scheme &&
        address == other.address &&
        userId == other.userId;
  }
}

abstract class AccountUpgrader {
  JsonObj? call(JsonObj json);
}

@npLog
class AccountUpgraderV1 implements AccountUpgrader {
  const AccountUpgraderV1({this.logAccountId});

  @override
  call(JsonObj json) {
    // clarify user id and display name v1
    _log.fine("[call] Upgrade v1 Account: $logAccountId");
    final result = JsonObj.of(json);
    result["userId"] = json["altHomeDir"] ?? json["username"];
    result["username2"] = json["username"];
    result
      ..remove("username")
      ..remove("altHomeDir");
    return result;
  }

  /// Account ID for logging only
  final String? logAccountId;
}
