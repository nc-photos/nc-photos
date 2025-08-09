// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// CopyWithLintRuleGenerator
// **************************************************************************

// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class $AccountCopyWithWorker {
  Account call({
    String? id,
    String? scheme,
    String? address,
    CiString? userId,
    String? username2,
    String? password,
    List<String>? roots,
  });
}

class _$AccountCopyWithWorkerImpl implements $AccountCopyWithWorker {
  _$AccountCopyWithWorkerImpl(this.that);

  @override
  Account call({
    dynamic id,
    dynamic scheme,
    dynamic address,
    dynamic userId,
    dynamic username2,
    dynamic password,
    dynamic roots,
  }) {
    return Account(
      id: id as String? ?? that.id,
      scheme: scheme as String? ?? that.scheme,
      address: address as String? ?? that.address,
      userId: userId as CiString? ?? that.userId,
      username2: username2 as String? ?? that.username2,
      password: password as String? ?? that.password,
      roots: roots as List<String>? ?? List.of(that.roots),
    );
  }

  final Account that;
}

extension $AccountCopyWith on Account {
  $AccountCopyWithWorker get copyWith => _$copyWith;
  $AccountCopyWithWorker get _$copyWith => _$AccountCopyWithWorkerImpl(this);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$AccountNpLog on Account {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("account.Account");
}

extension _$AccountUpgraderV1NpLog on AccountUpgraderV1 {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("account.AccountUpgraderV1");
}

// **************************************************************************
// ToStringGenerator
// **************************************************************************

extension _$AccountToString on Account {
  String _$toString() {
    // ignore: unnecessary_string_interpolations
    return "Account {id: $id, scheme: $scheme, address: ${isDevMode ? address : '***'}, userId: ${isDevMode ? userId : '***'}, username2: ${isDevMode ? username2 : '***'}, password: ${password.isNotEmpty ? (isDevMode ? password : '***') : null}, roots: ${roots.toReadableString()}}";
  }
}
