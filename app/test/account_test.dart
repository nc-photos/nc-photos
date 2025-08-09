import 'package:nc_photos/account.dart';
import 'package:np_string/np_string.dart';
import 'package:test/test.dart';

void main() {
  group("Account", () {
    group("constructor", () {
      test("trim address", _constructTrimAddress);
      test("invalid scheme", _constructInvalidScheme);
    });
    test("fromJson", _fromJson);
  });
  group("AccountUpgraderV1", () {
    test("normal", _upgraderV1);
    test("ldap", _upgraderV1Ldap);
  });
}

/// Convert json obj to Account
///
/// Expect: Account constructed
void _fromJson() {
  final json = <String, dynamic>{
    "version": Account.version,
    "id": "123456",
    "scheme": "https",
    "address": "example.com",
    "userId": "00000000-1111-aaaa-bbbb-223344ccddee",
    "username2": "admin",
    "password": "123456",
    "roots": ["test1", "test2"],
  };
  expect(
    Account.fromJson(json, upgraderV1: null),
    Account(
      id: "123456",
      scheme: "https",
      address: "example.com",
      userId: "00000000-1111-aaaa-bbbb-223344ccddee".toCi(),
      username2: "admin",
      password: "123456",
      roots: ["test1", "test2"],
    ),
  );
}

/// Upgrade v1 Account json to v2 Account json
///
/// Expect: v2.userId = v1.username;
/// v2.username2 = v1.username
void _upgraderV1() {
  final json = <String, dynamic>{
    "version": 1,
    "id": "123456",
    "scheme": "https",
    "address": "example.com",
    "username": "admin",
    "password": "123456",
    "roots": ["test1", "test2"],
  };
  expect(const AccountUpgraderV1()(json), <String, dynamic>{
    "version": 1,
    "id": "123456",
    "scheme": "https",
    "address": "example.com",
    "userId": "admin",
    "username2": "admin",
    "password": "123456",
    "roots": ["test1", "test2"],
  });
}

/// Upgrade v1 Account json to v2 Account json for a LDAP account
///
/// Expect: v2.userId = v1.altHomeDir;
/// v2.username2 = v1.username
void _upgraderV1Ldap() {
  final json = <String, dynamic>{
    "version": 1,
    "id": "123456",
    "scheme": "https",
    "address": "example.com",
    "username": "admin",
    "altHomeDir": "00000000-1111-aaaa-bbbb-223344ccddee",
    "password": "123456",
    "roots": ["test1", "test2"],
  };
  expect(const AccountUpgraderV1()(json), <String, dynamic>{
    "version": 1,
    "id": "123456",
    "scheme": "https",
    "address": "example.com",
    "userId": "00000000-1111-aaaa-bbbb-223344ccddee",
    "username2": "admin",
    "password": "123456",
    "roots": ["test1", "test2"],
  });
}

/// Construct a new Account, with address ending with /
///
/// Expect: Account constructed;
/// Trailing / in address removed
void _constructTrimAddress() {
  expect(
    Account(
      id: "123456",
      scheme: "https",
      address: "example.com/",
      userId: "00000000-1111-aaaa-bbbb-223344ccddee".toCi(),
      username2: "admin",
      password: "123456",
      roots: ["test1", "test2"],
    ),
    Account(
      id: "123456",
      scheme: "https",
      address: "example.com",
      userId: "00000000-1111-aaaa-bbbb-223344ccddee".toCi(),
      username2: "admin",
      password: "123456",
      roots: ["test1", "test2"],
    ),
  );
}

/// Construct a new Account, with scheme != http/https
///
/// Expect: FormatException
void _constructInvalidScheme() {
  expect(
    () => Account(
      id: "123456",
      scheme: "ssh",
      address: "example.com/",
      userId: "00000000-1111-aaaa-bbbb-223344ccddee".toCi(),
      username2: "admin",
      password: "123456",
      roots: ["test1", "test2"],
    ),
    throwsFormatException,
  );
}
