// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ServersTable extends Servers with TableInfo<$ServersTable, Server> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, address];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Server> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  Server map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Server(
      rowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}row_id'],
          )!,
      address:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}address'],
          )!,
    );
  }

  @override
  $ServersTable createAlias(String alias) {
    return $ServersTable(attachedDatabase, alias);
  }
}

class Server extends DataClass implements Insertable<Server> {
  final int rowId;
  final String address;
  const Server({required this.rowId, required this.address});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['address'] = Variable<String>(address);
    return map;
  }

  ServersCompanion toCompanion(bool nullToAbsent) {
    return ServersCompanion(rowId: Value(rowId), address: Value(address));
  }

  factory Server.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Server(
      rowId: serializer.fromJson<int>(json['rowId']),
      address: serializer.fromJson<String>(json['address']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'address': serializer.toJson<String>(address),
    };
  }

  Server copyWith({int? rowId, String? address}) =>
      Server(rowId: rowId ?? this.rowId, address: address ?? this.address);
  Server copyWithCompanion(ServersCompanion data) {
    return Server(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      address: data.address.present ? data.address.value : this.address,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Server(')
          ..write('rowId: $rowId, ')
          ..write('address: $address')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, address);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Server &&
          other.rowId == this.rowId &&
          other.address == this.address);
}

class ServersCompanion extends UpdateCompanion<Server> {
  final Value<int> rowId;
  final Value<String> address;
  const ServersCompanion({
    this.rowId = const Value.absent(),
    this.address = const Value.absent(),
  });
  ServersCompanion.insert({
    this.rowId = const Value.absent(),
    required String address,
  }) : address = Value(address);
  static Insertable<Server> custom({
    Expression<int>? rowId,
    Expression<String>? address,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (address != null) 'address': address,
    });
  }

  ServersCompanion copyWith({Value<int>? rowId, Value<String>? address}) {
    return ServersCompanion(
      rowId: rowId ?? this.rowId,
      address: address ?? this.address,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServersCompanion(')
          ..write('rowId: $rowId, ')
          ..write('address: $address')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverMeta = const VerificationMeta('server');
  @override
  late final GeneratedColumn<int> server = GeneratedColumn<int>(
    'server',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES servers (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, server, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('server')) {
      context.handle(
        _serverMeta,
        server.isAcceptableOrUnknown(data['server']!, _serverMeta),
      );
    } else if (isInserting) {
      context.missing(_serverMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {server, userId},
  ];
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      rowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}row_id'],
          )!,
      server:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}server'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int rowId;
  final int server;
  final String userId;
  const Account({
    required this.rowId,
    required this.server,
    required this.userId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['server'] = Variable<int>(server);
    map['user_id'] = Variable<String>(userId);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      rowId: Value(rowId),
      server: Value(server),
      userId: Value(userId),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      rowId: serializer.fromJson<int>(json['rowId']),
      server: serializer.fromJson<int>(json['server']),
      userId: serializer.fromJson<String>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'server': serializer.toJson<int>(server),
      'userId': serializer.toJson<String>(userId),
    };
  }

  Account copyWith({int? rowId, int? server, String? userId}) => Account(
    rowId: rowId ?? this.rowId,
    server: server ?? this.server,
    userId: userId ?? this.userId,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      server: data.server.present ? data.server.value : this.server,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('rowId: $rowId, ')
          ..write('server: $server, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, server, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.rowId == this.rowId &&
          other.server == this.server &&
          other.userId == this.userId);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> rowId;
  final Value<int> server;
  final Value<String> userId;
  const AccountsCompanion({
    this.rowId = const Value.absent(),
    this.server = const Value.absent(),
    this.userId = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.rowId = const Value.absent(),
    required int server,
    required String userId,
  }) : server = Value(server),
       userId = Value(userId);
  static Insertable<Account> custom({
    Expression<int>? rowId,
    Expression<int>? server,
    Expression<String>? userId,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (server != null) 'server': server,
      if (userId != null) 'user_id': userId,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? rowId,
    Value<int>? server,
    Value<String>? userId,
  }) {
    return AccountsCompanion(
      rowId: rowId ?? this.rowId,
      server: server ?? this.server,
      userId: userId ?? this.userId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (server.present) {
      map['server'] = Variable<int>(server.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('server: $server, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

class $FilesTable extends Files with TableInfo<$FilesTable, File> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverMeta = const VerificationMeta('server');
  @override
  late final GeneratedColumn<int> server = GeneratedColumn<int>(
    'server',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES servers (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<int> fileId = GeneratedColumn<int>(
    'file_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentLengthMeta = const VerificationMeta(
    'contentLength',
  );
  @override
  late final GeneratedColumn<int> contentLength = GeneratedColumn<int>(
    'content_length',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, DateTime>
  lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  ).withConverter<DateTime?>($FilesTable.$converterlastModifiedn);
  static const VerificationMeta _isCollectionMeta = const VerificationMeta(
    'isCollection',
  );
  @override
  late final GeneratedColumn<bool> isCollection = GeneratedColumn<bool>(
    'is_collection',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_collection" IN (0, 1))',
    ),
  );
  static const VerificationMeta _usedBytesMeta = const VerificationMeta(
    'usedBytes',
  );
  @override
  late final GeneratedColumn<int> usedBytes = GeneratedColumn<int>(
    'used_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasPreviewMeta = const VerificationMeta(
    'hasPreview',
  );
  @override
  late final GeneratedColumn<bool> hasPreview = GeneratedColumn<bool>(
    'has_preview',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_preview" IN (0, 1))',
    ),
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerDisplayNameMeta = const VerificationMeta(
    'ownerDisplayName',
  );
  @override
  late final GeneratedColumn<String> ownerDisplayName = GeneratedColumn<String>(
    'owner_display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    server,
    fileId,
    contentLength,
    contentType,
    etag,
    lastModified,
    isCollection,
    usedBytes,
    hasPreview,
    ownerId,
    ownerDisplayName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'files';
  @override
  VerificationContext validateIntegrity(
    Insertable<File> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('server')) {
      context.handle(
        _serverMeta,
        server.isAcceptableOrUnknown(data['server']!, _serverMeta),
      );
    } else if (isInserting) {
      context.missing(_serverMeta);
    }
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fileIdMeta);
    }
    if (data.containsKey('content_length')) {
      context.handle(
        _contentLengthMeta,
        contentLength.isAcceptableOrUnknown(
          data['content_length']!,
          _contentLengthMeta,
        ),
      );
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    context.handle(_lastModifiedMeta, const VerificationResult.success());
    if (data.containsKey('is_collection')) {
      context.handle(
        _isCollectionMeta,
        isCollection.isAcceptableOrUnknown(
          data['is_collection']!,
          _isCollectionMeta,
        ),
      );
    }
    if (data.containsKey('used_bytes')) {
      context.handle(
        _usedBytesMeta,
        usedBytes.isAcceptableOrUnknown(data['used_bytes']!, _usedBytesMeta),
      );
    }
    if (data.containsKey('has_preview')) {
      context.handle(
        _hasPreviewMeta,
        hasPreview.isAcceptableOrUnknown(data['has_preview']!, _hasPreviewMeta),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('owner_display_name')) {
      context.handle(
        _ownerDisplayNameMeta,
        ownerDisplayName.isAcceptableOrUnknown(
          data['owner_display_name']!,
          _ownerDisplayNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {server, fileId},
  ];
  @override
  File map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return File(
      rowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}row_id'],
          )!,
      server:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}server'],
          )!,
      fileId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}file_id'],
          )!,
      contentLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_length'],
      ),
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      ),
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      lastModified: $FilesTable.$converterlastModifiedn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_modified'],
        ),
      ),
      isCollection: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_collection'],
      ),
      usedBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}used_bytes'],
      ),
      hasPreview: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_preview'],
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      ),
      ownerDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_display_name'],
      ),
    );
  }

  @override
  $FilesTable createAlias(String alias) {
    return $FilesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, DateTime> $converterlastModified =
      const SqliteDateTimeConverter();
  static TypeConverter<DateTime?, DateTime?> $converterlastModifiedn =
      NullAwareTypeConverter.wrap($converterlastModified);
}

class File extends DataClass implements Insertable<File> {
  final int rowId;
  final int server;
  final int fileId;
  final int? contentLength;
  final String? contentType;
  final String? etag;
  final DateTime? lastModified;
  final bool? isCollection;
  final int? usedBytes;
  final bool? hasPreview;
  final String? ownerId;
  final String? ownerDisplayName;
  const File({
    required this.rowId,
    required this.server,
    required this.fileId,
    this.contentLength,
    this.contentType,
    this.etag,
    this.lastModified,
    this.isCollection,
    this.usedBytes,
    this.hasPreview,
    this.ownerId,
    this.ownerDisplayName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['server'] = Variable<int>(server);
    map['file_id'] = Variable<int>(fileId);
    if (!nullToAbsent || contentLength != null) {
      map['content_length'] = Variable<int>(contentLength);
    }
    if (!nullToAbsent || contentType != null) {
      map['content_type'] = Variable<String>(contentType);
    }
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    if (!nullToAbsent || lastModified != null) {
      map['last_modified'] = Variable<DateTime>(
        $FilesTable.$converterlastModifiedn.toSql(lastModified),
      );
    }
    if (!nullToAbsent || isCollection != null) {
      map['is_collection'] = Variable<bool>(isCollection);
    }
    if (!nullToAbsent || usedBytes != null) {
      map['used_bytes'] = Variable<int>(usedBytes);
    }
    if (!nullToAbsent || hasPreview != null) {
      map['has_preview'] = Variable<bool>(hasPreview);
    }
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<String>(ownerId);
    }
    if (!nullToAbsent || ownerDisplayName != null) {
      map['owner_display_name'] = Variable<String>(ownerDisplayName);
    }
    return map;
  }

  FilesCompanion toCompanion(bool nullToAbsent) {
    return FilesCompanion(
      rowId: Value(rowId),
      server: Value(server),
      fileId: Value(fileId),
      contentLength:
          contentLength == null && nullToAbsent
              ? const Value.absent()
              : Value(contentLength),
      contentType:
          contentType == null && nullToAbsent
              ? const Value.absent()
              : Value(contentType),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      lastModified:
          lastModified == null && nullToAbsent
              ? const Value.absent()
              : Value(lastModified),
      isCollection:
          isCollection == null && nullToAbsent
              ? const Value.absent()
              : Value(isCollection),
      usedBytes:
          usedBytes == null && nullToAbsent
              ? const Value.absent()
              : Value(usedBytes),
      hasPreview:
          hasPreview == null && nullToAbsent
              ? const Value.absent()
              : Value(hasPreview),
      ownerId:
          ownerId == null && nullToAbsent
              ? const Value.absent()
              : Value(ownerId),
      ownerDisplayName:
          ownerDisplayName == null && nullToAbsent
              ? const Value.absent()
              : Value(ownerDisplayName),
    );
  }

  factory File.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return File(
      rowId: serializer.fromJson<int>(json['rowId']),
      server: serializer.fromJson<int>(json['server']),
      fileId: serializer.fromJson<int>(json['fileId']),
      contentLength: serializer.fromJson<int?>(json['contentLength']),
      contentType: serializer.fromJson<String?>(json['contentType']),
      etag: serializer.fromJson<String?>(json['etag']),
      lastModified: serializer.fromJson<DateTime?>(json['lastModified']),
      isCollection: serializer.fromJson<bool?>(json['isCollection']),
      usedBytes: serializer.fromJson<int?>(json['usedBytes']),
      hasPreview: serializer.fromJson<bool?>(json['hasPreview']),
      ownerId: serializer.fromJson<String?>(json['ownerId']),
      ownerDisplayName: serializer.fromJson<String?>(json['ownerDisplayName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'server': serializer.toJson<int>(server),
      'fileId': serializer.toJson<int>(fileId),
      'contentLength': serializer.toJson<int?>(contentLength),
      'contentType': serializer.toJson<String?>(contentType),
      'etag': serializer.toJson<String?>(etag),
      'lastModified': serializer.toJson<DateTime?>(lastModified),
      'isCollection': serializer.toJson<bool?>(isCollection),
      'usedBytes': serializer.toJson<int?>(usedBytes),
      'hasPreview': serializer.toJson<bool?>(hasPreview),
      'ownerId': serializer.toJson<String?>(ownerId),
      'ownerDisplayName': serializer.toJson<String?>(ownerDisplayName),
    };
  }

  File copyWith({
    int? rowId,
    int? server,
    int? fileId,
    Value<int?> contentLength = const Value.absent(),
    Value<String?> contentType = const Value.absent(),
    Value<String?> etag = const Value.absent(),
    Value<DateTime?> lastModified = const Value.absent(),
    Value<bool?> isCollection = const Value.absent(),
    Value<int?> usedBytes = const Value.absent(),
    Value<bool?> hasPreview = const Value.absent(),
    Value<String?> ownerId = const Value.absent(),
    Value<String?> ownerDisplayName = const Value.absent(),
  }) => File(
    rowId: rowId ?? this.rowId,
    server: server ?? this.server,
    fileId: fileId ?? this.fileId,
    contentLength:
        contentLength.present ? contentLength.value : this.contentLength,
    contentType: contentType.present ? contentType.value : this.contentType,
    etag: etag.present ? etag.value : this.etag,
    lastModified: lastModified.present ? lastModified.value : this.lastModified,
    isCollection: isCollection.present ? isCollection.value : this.isCollection,
    usedBytes: usedBytes.present ? usedBytes.value : this.usedBytes,
    hasPreview: hasPreview.present ? hasPreview.value : this.hasPreview,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    ownerDisplayName:
        ownerDisplayName.present
            ? ownerDisplayName.value
            : this.ownerDisplayName,
  );
  File copyWithCompanion(FilesCompanion data) {
    return File(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      server: data.server.present ? data.server.value : this.server,
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      contentLength:
          data.contentLength.present
              ? data.contentLength.value
              : this.contentLength,
      contentType:
          data.contentType.present ? data.contentType.value : this.contentType,
      etag: data.etag.present ? data.etag.value : this.etag,
      lastModified:
          data.lastModified.present
              ? data.lastModified.value
              : this.lastModified,
      isCollection:
          data.isCollection.present
              ? data.isCollection.value
              : this.isCollection,
      usedBytes: data.usedBytes.present ? data.usedBytes.value : this.usedBytes,
      hasPreview:
          data.hasPreview.present ? data.hasPreview.value : this.hasPreview,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      ownerDisplayName:
          data.ownerDisplayName.present
              ? data.ownerDisplayName.value
              : this.ownerDisplayName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('File(')
          ..write('rowId: $rowId, ')
          ..write('server: $server, ')
          ..write('fileId: $fileId, ')
          ..write('contentLength: $contentLength, ')
          ..write('contentType: $contentType, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('isCollection: $isCollection, ')
          ..write('usedBytes: $usedBytes, ')
          ..write('hasPreview: $hasPreview, ')
          ..write('ownerId: $ownerId, ')
          ..write('ownerDisplayName: $ownerDisplayName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    server,
    fileId,
    contentLength,
    contentType,
    etag,
    lastModified,
    isCollection,
    usedBytes,
    hasPreview,
    ownerId,
    ownerDisplayName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is File &&
          other.rowId == this.rowId &&
          other.server == this.server &&
          other.fileId == this.fileId &&
          other.contentLength == this.contentLength &&
          other.contentType == this.contentType &&
          other.etag == this.etag &&
          other.lastModified == this.lastModified &&
          other.isCollection == this.isCollection &&
          other.usedBytes == this.usedBytes &&
          other.hasPreview == this.hasPreview &&
          other.ownerId == this.ownerId &&
          other.ownerDisplayName == this.ownerDisplayName);
}

class FilesCompanion extends UpdateCompanion<File> {
  final Value<int> rowId;
  final Value<int> server;
  final Value<int> fileId;
  final Value<int?> contentLength;
  final Value<String?> contentType;
  final Value<String?> etag;
  final Value<DateTime?> lastModified;
  final Value<bool?> isCollection;
  final Value<int?> usedBytes;
  final Value<bool?> hasPreview;
  final Value<String?> ownerId;
  final Value<String?> ownerDisplayName;
  const FilesCompanion({
    this.rowId = const Value.absent(),
    this.server = const Value.absent(),
    this.fileId = const Value.absent(),
    this.contentLength = const Value.absent(),
    this.contentType = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isCollection = const Value.absent(),
    this.usedBytes = const Value.absent(),
    this.hasPreview = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.ownerDisplayName = const Value.absent(),
  });
  FilesCompanion.insert({
    this.rowId = const Value.absent(),
    required int server,
    required int fileId,
    this.contentLength = const Value.absent(),
    this.contentType = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isCollection = const Value.absent(),
    this.usedBytes = const Value.absent(),
    this.hasPreview = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.ownerDisplayName = const Value.absent(),
  }) : server = Value(server),
       fileId = Value(fileId);
  static Insertable<File> custom({
    Expression<int>? rowId,
    Expression<int>? server,
    Expression<int>? fileId,
    Expression<int>? contentLength,
    Expression<String>? contentType,
    Expression<String>? etag,
    Expression<DateTime>? lastModified,
    Expression<bool>? isCollection,
    Expression<int>? usedBytes,
    Expression<bool>? hasPreview,
    Expression<String>? ownerId,
    Expression<String>? ownerDisplayName,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (server != null) 'server': server,
      if (fileId != null) 'file_id': fileId,
      if (contentLength != null) 'content_length': contentLength,
      if (contentType != null) 'content_type': contentType,
      if (etag != null) 'etag': etag,
      if (lastModified != null) 'last_modified': lastModified,
      if (isCollection != null) 'is_collection': isCollection,
      if (usedBytes != null) 'used_bytes': usedBytes,
      if (hasPreview != null) 'has_preview': hasPreview,
      if (ownerId != null) 'owner_id': ownerId,
      if (ownerDisplayName != null) 'owner_display_name': ownerDisplayName,
    });
  }

  FilesCompanion copyWith({
    Value<int>? rowId,
    Value<int>? server,
    Value<int>? fileId,
    Value<int?>? contentLength,
    Value<String?>? contentType,
    Value<String?>? etag,
    Value<DateTime?>? lastModified,
    Value<bool?>? isCollection,
    Value<int?>? usedBytes,
    Value<bool?>? hasPreview,
    Value<String?>? ownerId,
    Value<String?>? ownerDisplayName,
  }) {
    return FilesCompanion(
      rowId: rowId ?? this.rowId,
      server: server ?? this.server,
      fileId: fileId ?? this.fileId,
      contentLength: contentLength ?? this.contentLength,
      contentType: contentType ?? this.contentType,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      isCollection: isCollection ?? this.isCollection,
      usedBytes: usedBytes ?? this.usedBytes,
      hasPreview: hasPreview ?? this.hasPreview,
      ownerId: ownerId ?? this.ownerId,
      ownerDisplayName: ownerDisplayName ?? this.ownerDisplayName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (server.present) {
      map['server'] = Variable<int>(server.value);
    }
    if (fileId.present) {
      map['file_id'] = Variable<int>(fileId.value);
    }
    if (contentLength.present) {
      map['content_length'] = Variable<int>(contentLength.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(
        $FilesTable.$converterlastModifiedn.toSql(lastModified.value),
      );
    }
    if (isCollection.present) {
      map['is_collection'] = Variable<bool>(isCollection.value);
    }
    if (usedBytes.present) {
      map['used_bytes'] = Variable<int>(usedBytes.value);
    }
    if (hasPreview.present) {
      map['has_preview'] = Variable<bool>(hasPreview.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (ownerDisplayName.present) {
      map['owner_display_name'] = Variable<String>(ownerDisplayName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FilesCompanion(')
          ..write('rowId: $rowId, ')
          ..write('server: $server, ')
          ..write('fileId: $fileId, ')
          ..write('contentLength: $contentLength, ')
          ..write('contentType: $contentType, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('isCollection: $isCollection, ')
          ..write('usedBytes: $usedBytes, ')
          ..write('hasPreview: $hasPreview, ')
          ..write('ownerId: $ownerId, ')
          ..write('ownerDisplayName: $ownerDisplayName')
          ..write(')'))
        .toString();
  }
}

class $AccountFilesTable extends AccountFiles
    with TableInfo<$AccountFilesTable, AccountFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountMeta = const VerificationMeta(
    'account',
  );
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
    'account',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _fileMeta = const VerificationMeta('file');
  @override
  late final GeneratedColumn<int> file = GeneratedColumn<int>(
    'file',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES files (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
  );
  static const VerificationMeta _overrideDateTimeMeta = const VerificationMeta(
    'overrideDateTime',
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, DateTime>
  overrideDateTime = GeneratedColumn<DateTime>(
    'override_date_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  ).withConverter<DateTime?>($AccountFilesTable.$converteroverrideDateTimen);
  static const VerificationMeta _bestDateTimeMeta = const VerificationMeta(
    'bestDateTime',
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime> bestDateTime =
      GeneratedColumn<DateTime>(
        'best_date_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($AccountFilesTable.$converterbestDateTime);
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    account,
    file,
    relativePath,
    isFavorite,
    isArchived,
    overrideDateTime,
    bestDateTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('account')) {
      context.handle(
        _accountMeta,
        account.isAcceptableOrUnknown(data['account']!, _accountMeta),
      );
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('file')) {
      context.handle(
        _fileMeta,
        file.isAcceptableOrUnknown(data['file']!, _fileMeta),
      );
    } else if (isInserting) {
      context.missing(_fileMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    context.handle(_overrideDateTimeMeta, const VerificationResult.success());
    context.handle(_bestDateTimeMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {account, file},
  ];
  @override
  AccountFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountFile(
      rowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}row_id'],
          )!,
      account:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}account'],
          )!,
      file:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}file'],
          )!,
      relativePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}relative_path'],
          )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      ),
      overrideDateTime: $AccountFilesTable.$converteroverrideDateTimen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}override_date_time'],
        ),
      ),
      bestDateTime: $AccountFilesTable.$converterbestDateTime.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}best_date_time'],
        )!,
      ),
    );
  }

  @override
  $AccountFilesTable createAlias(String alias) {
    return $AccountFilesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, DateTime> $converteroverrideDateTime =
      const SqliteDateTimeConverter();
  static TypeConverter<DateTime?, DateTime?> $converteroverrideDateTimen =
      NullAwareTypeConverter.wrap($converteroverrideDateTime);
  static TypeConverter<DateTime, DateTime> $converterbestDateTime =
      const SqliteDateTimeConverter();
}

class AccountFile extends DataClass implements Insertable<AccountFile> {
  final int rowId;
  final int account;
  final int file;
  final String relativePath;
  final bool? isFavorite;
  final bool? isArchived;
  final DateTime? overrideDateTime;
  final DateTime bestDateTime;
  const AccountFile({
    required this.rowId,
    required this.account,
    required this.file,
    required this.relativePath,
    this.isFavorite,
    this.isArchived,
    this.overrideDateTime,
    required this.bestDateTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['account'] = Variable<int>(account);
    map['file'] = Variable<int>(file);
    map['relative_path'] = Variable<String>(relativePath);
    if (!nullToAbsent || isFavorite != null) {
      map['is_favorite'] = Variable<bool>(isFavorite);
    }
    if (!nullToAbsent || isArchived != null) {
      map['is_archived'] = Variable<bool>(isArchived);
    }
    if (!nullToAbsent || overrideDateTime != null) {
      map['override_date_time'] = Variable<DateTime>(
        $AccountFilesTable.$converteroverrideDateTimen.toSql(overrideDateTime),
      );
    }
    {
      map['best_date_time'] = Variable<DateTime>(
        $AccountFilesTable.$converterbestDateTime.toSql(bestDateTime),
      );
    }
    return map;
  }

  AccountFilesCompanion toCompanion(bool nullToAbsent) {
    return AccountFilesCompanion(
      rowId: Value(rowId),
      account: Value(account),
      file: Value(file),
      relativePath: Value(relativePath),
      isFavorite:
          isFavorite == null && nullToAbsent
              ? const Value.absent()
              : Value(isFavorite),
      isArchived:
          isArchived == null && nullToAbsent
              ? const Value.absent()
              : Value(isArchived),
      overrideDateTime:
          overrideDateTime == null && nullToAbsent
              ? const Value.absent()
              : Value(overrideDateTime),
      bestDateTime: Value(bestDateTime),
    );
  }

  factory AccountFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountFile(
      rowId: serializer.fromJson<int>(json['rowId']),
      account: serializer.fromJson<int>(json['account']),
      file: serializer.fromJson<int>(json['file']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      isFavorite: serializer.fromJson<bool?>(json['isFavorite']),
      isArchived: serializer.fromJson<bool?>(json['isArchived']),
      overrideDateTime: serializer.fromJson<DateTime?>(
        json['overrideDateTime'],
      ),
      bestDateTime: serializer.fromJson<DateTime>(json['bestDateTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'account': serializer.toJson<int>(account),
      'file': serializer.toJson<int>(file),
      'relativePath': serializer.toJson<String>(relativePath),
      'isFavorite': serializer.toJson<bool?>(isFavorite),
      'isArchived': serializer.toJson<bool?>(isArchived),
      'overrideDateTime': serializer.toJson<DateTime?>(overrideDateTime),
      'bestDateTime': serializer.toJson<DateTime>(bestDateTime),
    };
  }

  AccountFile copyWith({
    int? rowId,
    int? account,
    int? file,
    String? relativePath,
    Value<bool?> isFavorite = const Value.absent(),
    Value<bool?> isArchived = const Value.absent(),
    Value<DateTime?> overrideDateTime = const Value.absent(),
    DateTime? bestDateTime,
  }) => AccountFile(
    rowId: rowId ?? this.rowId,
    account: account ?? this.account,
    file: file ?? this.file,
    relativePath: relativePath ?? this.relativePath,
    isFavorite: isFavorite.present ? isFavorite.value : this.isFavorite,
    isArchived: isArchived.present ? isArchived.value : this.isArchived,
    overrideDateTime:
        overrideDateTime.present
            ? overrideDateTime.value
            : this.overrideDateTime,
    bestDateTime: bestDateTime ?? this.bestDateTime,
  );
  AccountFile copyWithCompanion(AccountFilesCompanion data) {
    return AccountFile(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      account: data.account.present ? data.account.value : this.account,
      file: data.file.present ? data.file.value : this.file,
      relativePath:
          data.relativePath.present
              ? data.relativePath.value
              : this.relativePath,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      overrideDateTime:
          data.overrideDateTime.present
              ? data.overrideDateTime.value
              : this.overrideDateTime,
      bestDateTime:
          data.bestDateTime.present
              ? data.bestDateTime.value
              : this.bestDateTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountFile(')
          ..write('rowId: $rowId, ')
          ..write('account: $account, ')
          ..write('file: $file, ')
          ..write('relativePath: $relativePath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isArchived: $isArchived, ')
          ..write('overrideDateTime: $overrideDateTime, ')
          ..write('bestDateTime: $bestDateTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    account,
    file,
    relativePath,
    isFavorite,
    isArchived,
    overrideDateTime,
    bestDateTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountFile &&
          other.rowId == this.rowId &&
          other.account == this.account &&
          other.file == this.file &&
          other.relativePath == this.relativePath &&
          other.isFavorite == this.isFavorite &&
          other.isArchived == this.isArchived &&
          other.overrideDateTime == this.overrideDateTime &&
          other.bestDateTime == this.bestDateTime);
}

class AccountFilesCompanion extends UpdateCompanion<AccountFile> {
  final Value<int> rowId;
  final Value<int> account;
  final Value<int> file;
  final Value<String> relativePath;
  final Value<bool?> isFavorite;
  final Value<bool?> isArchived;
  final Value<DateTime?> overrideDateTime;
  final Value<DateTime> bestDateTime;
  const AccountFilesCompanion({
    this.rowId = const Value.absent(),
    this.account = const Value.absent(),
    this.file = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.overrideDateTime = const Value.absent(),
    this.bestDateTime = const Value.absent(),
  });
  AccountFilesCompanion.insert({
    this.rowId = const Value.absent(),
    required int account,
    required int file,
    required String relativePath,
    this.isFavorite = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.overrideDateTime = const Value.absent(),
    required DateTime bestDateTime,
  }) : account = Value(account),
       file = Value(file),
       relativePath = Value(relativePath),
       bestDateTime = Value(bestDateTime);
  static Insertable<AccountFile> custom({
    Expression<int>? rowId,
    Expression<int>? account,
    Expression<int>? file,
    Expression<String>? relativePath,
    Expression<bool>? isFavorite,
    Expression<bool>? isArchived,
    Expression<DateTime>? overrideDateTime,
    Expression<DateTime>? bestDateTime,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (account != null) 'account': account,
      if (file != null) 'file': file,
      if (relativePath != null) 'relative_path': relativePath,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isArchived != null) 'is_archived': isArchived,
      if (overrideDateTime != null) 'override_date_time': overrideDateTime,
      if (bestDateTime != null) 'best_date_time': bestDateTime,
    });
  }

  AccountFilesCompanion copyWith({
    Value<int>? rowId,
    Value<int>? account,
    Value<int>? file,
    Value<String>? relativePath,
    Value<bool?>? isFavorite,
    Value<bool?>? isArchived,
    Value<DateTime?>? overrideDateTime,
    Value<DateTime>? bestDateTime,
  }) {
    return AccountFilesCompanion(
      rowId: rowId ?? this.rowId,
      account: account ?? this.account,
      file: file ?? this.file,
      relativePath: relativePath ?? this.relativePath,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      overrideDateTime: overrideDateTime ?? this.overrideDateTime,
      bestDateTime: bestDateTime ?? this.bestDateTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    if (file.present) {
      map['file'] = Variable<int>(file.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (overrideDateTime.present) {
      map['override_date_time'] = Variable<DateTime>(
        $AccountFilesTable.$converteroverrideDateTimen.toSql(
          overrideDateTime.value,
        ),
      );
    }
    if (bestDateTime.present) {
      map['best_date_time'] = Variable<DateTime>(
        $AccountFilesTable.$converterbestDateTime.toSql(bestDateTime.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountFilesCompanion(')
          ..write('rowId: $rowId, ')
          ..write('account: $account, ')
          ..write('file: $file, ')
          ..write('relativePath: $relativePath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isArchived: $isArchived, ')
          ..write('overrideDateTime: $overrideDateTime, ')
          ..write('bestDateTime: $bestDateTime')
          ..write(')'))
        .toString();
  }
}

class $ImagesTable extends Images with TableInfo<$ImagesTable, Image> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountFileMeta = const VerificationMeta(
    'accountFile',
  );
  @override
  late final GeneratedColumn<int> accountFile = GeneratedColumn<int>(
    'account_file',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES account_files (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime> lastUpdated =
      GeneratedColumn<DateTime>(
        'last_updated',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($ImagesTable.$converterlastUpdated);
  static const VerificationMeta _fileEtagMeta = const VerificationMeta(
    'fileEtag',
  );
  @override
  late final GeneratedColumn<String> fileEtag = GeneratedColumn<String>(
    'file_etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exifRawMeta = const VerificationMeta(
    'exifRaw',
  );
  @override
  late final GeneratedColumn<String> exifRaw = GeneratedColumn<String>(
    'exif_raw',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _xmpRawMeta = const VerificationMeta('xmpRaw');
  @override
  late final GeneratedColumn<String> xmpRaw = GeneratedColumn<String>(
    'xmp_raw',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _srcMeta = const VerificationMeta('src');
  @override
  late final GeneratedColumn<int> src = GeneratedColumn<int>(
    'src',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateTimeOriginalMeta = const VerificationMeta(
    'dateTimeOriginal',
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, DateTime>
  dateTimeOriginal = GeneratedColumn<DateTime>(
    'date_time_original',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  ).withConverter<DateTime?>($ImagesTable.$converterdateTimeOriginaln);
  @override
  List<GeneratedColumn> get $columns => [
    accountFile,
    lastUpdated,
    fileEtag,
    width,
    height,
    exifRaw,
    xmpRaw,
    src,
    dateTimeOriginal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'images';
  @override
  VerificationContext validateIntegrity(
    Insertable<Image> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_file')) {
      context.handle(
        _accountFileMeta,
        accountFile.isAcceptableOrUnknown(
          data['account_file']!,
          _accountFileMeta,
        ),
      );
    }
    context.handle(_lastUpdatedMeta, const VerificationResult.success());
    if (data.containsKey('file_etag')) {
      context.handle(
        _fileEtagMeta,
        fileEtag.isAcceptableOrUnknown(data['file_etag']!, _fileEtagMeta),
      );
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    }
    if (data.containsKey('exif_raw')) {
      context.handle(
        _exifRawMeta,
        exifRaw.isAcceptableOrUnknown(data['exif_raw']!, _exifRawMeta),
      );
    }
    if (data.containsKey('xmp_raw')) {
      context.handle(
        _xmpRawMeta,
        xmpRaw.isAcceptableOrUnknown(data['xmp_raw']!, _xmpRawMeta),
      );
    }
    if (data.containsKey('src')) {
      context.handle(
        _srcMeta,
        src.isAcceptableOrUnknown(data['src']!, _srcMeta),
      );
    }
    context.handle(_dateTimeOriginalMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountFile};
  @override
  Image map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Image(
      accountFile:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}account_file'],
          )!,
      lastUpdated: $ImagesTable.$converterlastUpdated.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_updated'],
        )!,
      ),
      fileEtag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_etag'],
      ),
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      ),
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      ),
      exifRaw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exif_raw'],
      ),
      xmpRaw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}xmp_raw'],
      ),
      src: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}src'],
      ),
      dateTimeOriginal: $ImagesTable.$converterdateTimeOriginaln.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}date_time_original'],
        ),
      ),
    );
  }

  @override
  $ImagesTable createAlias(String alias) {
    return $ImagesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, DateTime> $converterlastUpdated =
      const SqliteDateTimeConverter();
  static TypeConverter<DateTime, DateTime> $converterdateTimeOriginal =
      const SqliteDateTimeConverter();
  static TypeConverter<DateTime?, DateTime?> $converterdateTimeOriginaln =
      NullAwareTypeConverter.wrap($converterdateTimeOriginal);
}

class Image extends DataClass implements Insertable<Image> {
  final int accountFile;
  final DateTime lastUpdated;
  final String? fileEtag;
  final int? width;
  final int? height;
  final String? exifRaw;
  final String? xmpRaw;
  final int? src;
  final DateTime? dateTimeOriginal;
  const Image({
    required this.accountFile,
    required this.lastUpdated,
    this.fileEtag,
    this.width,
    this.height,
    this.exifRaw,
    this.xmpRaw,
    this.src,
    this.dateTimeOriginal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_file'] = Variable<int>(accountFile);
    {
      map['last_updated'] = Variable<DateTime>(
        $ImagesTable.$converterlastUpdated.toSql(lastUpdated),
      );
    }
    if (!nullToAbsent || fileEtag != null) {
      map['file_etag'] = Variable<String>(fileEtag);
    }
    if (!nullToAbsent || width != null) {
      map['width'] = Variable<int>(width);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<int>(height);
    }
    if (!nullToAbsent || exifRaw != null) {
      map['exif_raw'] = Variable<String>(exifRaw);
    }
    if (!nullToAbsent || xmpRaw != null) {
      map['xmp_raw'] = Variable<String>(xmpRaw);
    }
    if (!nullToAbsent || src != null) {
      map['src'] = Variable<int>(src);
    }
    if (!nullToAbsent || dateTimeOriginal != null) {
      map['date_time_original'] = Variable<DateTime>(
        $ImagesTable.$converterdateTimeOriginaln.toSql(dateTimeOriginal),
      );
    }
    return map;
  }

  ImagesCompanion toCompanion(bool nullToAbsent) {
    return ImagesCompanion(
      accountFile: Value(accountFile),
      lastUpdated: Value(lastUpdated),
      fileEtag:
          fileEtag == null && nullToAbsent
              ? const Value.absent()
              : Value(fileEtag),
      width:
          width == null && nullToAbsent ? const Value.absent() : Value(width),
      height:
          height == null && nullToAbsent ? const Value.absent() : Value(height),
      exifRaw:
          exifRaw == null && nullToAbsent
              ? const Value.absent()
              : Value(exifRaw),
      xmpRaw:
          xmpRaw == null && nullToAbsent ? const Value.absent() : Value(xmpRaw),
      src: src == null && nullToAbsent ? const Value.absent() : Value(src),
      dateTimeOriginal:
          dateTimeOriginal == null && nullToAbsent
              ? const Value.absent()
              : Value(dateTimeOriginal),
    );
  }

  factory Image.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Image(
      accountFile: serializer.fromJson<int>(json['accountFile']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      fileEtag: serializer.fromJson<String?>(json['fileEtag']),
      width: serializer.fromJson<int?>(json['width']),
      height: serializer.fromJson<int?>(json['height']),
      exifRaw: serializer.fromJson<String?>(json['exifRaw']),
      xmpRaw: serializer.fromJson<String?>(json['xmpRaw']),
      src: serializer.fromJson<int?>(json['src']),
      dateTimeOriginal: serializer.fromJson<DateTime?>(
        json['dateTimeOriginal'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountFile': serializer.toJson<int>(accountFile),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'fileEtag': serializer.toJson<String?>(fileEtag),
      'width': serializer.toJson<int?>(width),
      'height': serializer.toJson<int?>(height),
      'exifRaw': serializer.toJson<String?>(exifRaw),
      'xmpRaw': serializer.toJson<String?>(xmpRaw),
      'src': serializer.toJson<int?>(src),
      'dateTimeOriginal': serializer.toJson<DateTime?>(dateTimeOriginal),
    };
  }

  Image copyWith({
    int? accountFile,
    DateTime? lastUpdated,
    Value<String?> fileEtag = const Value.absent(),
    Value<int?> width = const Value.absent(),
    Value<int?> height = const Value.absent(),
    Value<String?> exifRaw = const Value.absent(),
    Value<String?> xmpRaw = const Value.absent(),
    Value<int?> src = const Value.absent(),
    Value<DateTime?> dateTimeOriginal = const Value.absent(),
  }) => Image(
    accountFile: accountFile ?? this.accountFile,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    fileEtag: fileEtag.present ? fileEtag.value : this.fileEtag,
    width: width.present ? width.value : this.width,
    height: height.present ? height.value : this.height,
    exifRaw: exifRaw.present ? exifRaw.value : this.exifRaw,
    xmpRaw: xmpRaw.present ? xmpRaw.value : this.xmpRaw,
    src: src.present ? src.value : this.src,
    dateTimeOriginal:
        dateTimeOriginal.present
            ? dateTimeOriginal.value
            : this.dateTimeOriginal,
  );
  Image copyWithCompanion(ImagesCompanion data) {
    return Image(
      accountFile:
          data.accountFile.present ? data.accountFile.value : this.accountFile,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      fileEtag: data.fileEtag.present ? data.fileEtag.value : this.fileEtag,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      exifRaw: data.exifRaw.present ? data.exifRaw.value : this.exifRaw,
      xmpRaw: data.xmpRaw.present ? data.xmpRaw.value : this.xmpRaw,
      src: data.src.present ? data.src.value : this.src,
      dateTimeOriginal:
          data.dateTimeOriginal.present
              ? data.dateTimeOriginal.value
              : this.dateTimeOriginal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Image(')
          ..write('accountFile: $accountFile, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('fileEtag: $fileEtag, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('exifRaw: $exifRaw, ')
          ..write('xmpRaw: $xmpRaw, ')
          ..write('src: $src, ')
          ..write('dateTimeOriginal: $dateTimeOriginal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    accountFile,
    lastUpdated,
    fileEtag,
    width,
    height,
    exifRaw,
    xmpRaw,
    src,
    dateTimeOriginal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Image &&
          other.accountFile == this.accountFile &&
          other.lastUpdated == this.lastUpdated &&
          other.fileEtag == this.fileEtag &&
          other.width == this.width &&
          other.height == this.height &&
          other.exifRaw == this.exifRaw &&
          other.xmpRaw == this.xmpRaw &&
          other.src == this.src &&
          other.dateTimeOriginal == this.dateTimeOriginal);
}

class ImagesCompanion extends UpdateCompanion<Image> {
  final Value<int> accountFile;
  final Value<DateTime> lastUpdated;
  final Value<String?> fileEtag;
  final Value<int?> width;
  final Value<int?> height;
  final Value<String?> exifRaw;
  final Value<String?> xmpRaw;
  final Value<int?> src;
  final Value<DateTime?> dateTimeOriginal;
  const ImagesCompanion({
    this.accountFile = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.fileEtag = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.exifRaw = const Value.absent(),
    this.xmpRaw = const Value.absent(),
    this.src = const Value.absent(),
    this.dateTimeOriginal = const Value.absent(),
  });
  ImagesCompanion.insert({
    this.accountFile = const Value.absent(),
    required DateTime lastUpdated,
    this.fileEtag = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.exifRaw = const Value.absent(),
    this.xmpRaw = const Value.absent(),
    this.src = const Value.absent(),
    this.dateTimeOriginal = const Value.absent(),
  }) : lastUpdated = Value(lastUpdated);
  static Insertable<Image> custom({
    Expression<int>? accountFile,
    Expression<DateTime>? lastUpdated,
    Expression<String>? fileEtag,
    Expression<int>? width,
    Expression<int>? height,
    Expression<String>? exifRaw,
    Expression<String>? xmpRaw,
    Expression<int>? src,
    Expression<DateTime>? dateTimeOriginal,
  }) {
    return RawValuesInsertable({
      if (accountFile != null) 'account_file': accountFile,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (fileEtag != null) 'file_etag': fileEtag,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (exifRaw != null) 'exif_raw': exifRaw,
      if (xmpRaw != null) 'xmp_raw': xmpRaw,
      if (src != null) 'src': src,
      if (dateTimeOriginal != null) 'date_time_original': dateTimeOriginal,
    });
  }

  ImagesCompanion copyWith({
    Value<int>? accountFile,
    Value<DateTime>? lastUpdated,
    Value<String?>? fileEtag,
    Value<int?>? width,
    Value<int?>? height,
    Value<String?>? exifRaw,
    Value<String?>? xmpRaw,
    Value<int?>? src,
    Value<DateTime?>? dateTimeOriginal,
  }) {
    return ImagesCompanion(
      accountFile: accountFile ?? this.accountFile,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      fileEtag: fileEtag ?? this.fileEtag,
      width: width ?? this.width,
      height: height ?? this.height,
      exifRaw: exifRaw ?? this.exifRaw,
      xmpRaw: xmpRaw ?? this.xmpRaw,
      src: src ?? this.src,
      dateTimeOriginal: dateTimeOriginal ?? this.dateTimeOriginal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountFile.present) {
      map['account_file'] = Variable<int>(accountFile.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(
        $ImagesTable.$converterlastUpdated.toSql(lastUpdated.value),
      );
    }
    if (fileEtag.present) {
      map['file_etag'] = Variable<String>(fileEtag.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (exifRaw.present) {
      map['exif_raw'] = Variable<String>(exifRaw.value);
    }
    if (xmpRaw.present) {
      map['xmp_raw'] = Variable<String>(xmpRaw.value);
    }
    if (src.present) {
      map['src'] = Variable<int>(src.value);
    }
    if (dateTimeOriginal.present) {
      map['date_time_original'] = Variable<DateTime>(
        $ImagesTable.$converterdateTimeOriginaln.toSql(dateTimeOriginal.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImagesCompanion(')
          ..write('accountFile: $accountFile, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('fileEtag: $fileEtag, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('exifRaw: $exifRaw, ')
          ..write('xmpRaw: $xmpRaw, ')
          ..write('src: $src, ')
          ..write('dateTimeOriginal: $dateTimeOriginal')
          ..write(')'))
        .toString();
  }
}

class $ImageLocationsTable extends ImageLocations
    with TableInfo<$ImageLocationsTable, ImageLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImageLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountFileMeta = const VerificationMeta(
    'accountFile',
  );
  @override
  late final GeneratedColumn<int> accountFile = GeneratedColumn<int>(
    'account_file',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES account_files (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _admin1Meta = const VerificationMeta('admin1');
  @override
  late final GeneratedColumn<String> admin1 = GeneratedColumn<String>(
    'admin1',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _admin2Meta = const VerificationMeta('admin2');
  @override
  late final GeneratedColumn<String> admin2 = GeneratedColumn<String>(
    'admin2',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    accountFile,
    version,
    name,
    latitude,
    longitude,
    countryCode,
    admin1,
    admin2,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'image_locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImageLocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_file')) {
      context.handle(
        _accountFileMeta,
        accountFile.isAcceptableOrUnknown(
          data['account_file']!,
          _accountFileMeta,
        ),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    }
    if (data.containsKey('admin1')) {
      context.handle(
        _admin1Meta,
        admin1.isAcceptableOrUnknown(data['admin1']!, _admin1Meta),
      );
    }
    if (data.containsKey('admin2')) {
      context.handle(
        _admin2Meta,
        admin2.isAcceptableOrUnknown(data['admin2']!, _admin2Meta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountFile};
  @override
  ImageLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImageLocation(
      accountFile:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}account_file'],
          )!,
      version:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}version'],
          )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      ),
      admin1: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}admin1'],
      ),
      admin2: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}admin2'],
      ),
    );
  }

  @override
  $ImageLocationsTable createAlias(String alias) {
    return $ImageLocationsTable(attachedDatabase, alias);
  }
}

class ImageLocation extends DataClass implements Insertable<ImageLocation> {
  final int accountFile;
  final int version;
  final String? name;
  final double? latitude;
  final double? longitude;
  final String? countryCode;
  final String? admin1;
  final String? admin2;
  const ImageLocation({
    required this.accountFile,
    required this.version,
    this.name,
    this.latitude,
    this.longitude,
    this.countryCode,
    this.admin1,
    this.admin2,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_file'] = Variable<int>(accountFile);
    map['version'] = Variable<int>(version);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || countryCode != null) {
      map['country_code'] = Variable<String>(countryCode);
    }
    if (!nullToAbsent || admin1 != null) {
      map['admin1'] = Variable<String>(admin1);
    }
    if (!nullToAbsent || admin2 != null) {
      map['admin2'] = Variable<String>(admin2);
    }
    return map;
  }

  ImageLocationsCompanion toCompanion(bool nullToAbsent) {
    return ImageLocationsCompanion(
      accountFile: Value(accountFile),
      version: Value(version),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      latitude:
          latitude == null && nullToAbsent
              ? const Value.absent()
              : Value(latitude),
      longitude:
          longitude == null && nullToAbsent
              ? const Value.absent()
              : Value(longitude),
      countryCode:
          countryCode == null && nullToAbsent
              ? const Value.absent()
              : Value(countryCode),
      admin1:
          admin1 == null && nullToAbsent ? const Value.absent() : Value(admin1),
      admin2:
          admin2 == null && nullToAbsent ? const Value.absent() : Value(admin2),
    );
  }

  factory ImageLocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImageLocation(
      accountFile: serializer.fromJson<int>(json['accountFile']),
      version: serializer.fromJson<int>(json['version']),
      name: serializer.fromJson<String?>(json['name']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      countryCode: serializer.fromJson<String?>(json['countryCode']),
      admin1: serializer.fromJson<String?>(json['admin1']),
      admin2: serializer.fromJson<String?>(json['admin2']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountFile': serializer.toJson<int>(accountFile),
      'version': serializer.toJson<int>(version),
      'name': serializer.toJson<String?>(name),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'countryCode': serializer.toJson<String?>(countryCode),
      'admin1': serializer.toJson<String?>(admin1),
      'admin2': serializer.toJson<String?>(admin2),
    };
  }

  ImageLocation copyWith({
    int? accountFile,
    int? version,
    Value<String?> name = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> countryCode = const Value.absent(),
    Value<String?> admin1 = const Value.absent(),
    Value<String?> admin2 = const Value.absent(),
  }) => ImageLocation(
    accountFile: accountFile ?? this.accountFile,
    version: version ?? this.version,
    name: name.present ? name.value : this.name,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    countryCode: countryCode.present ? countryCode.value : this.countryCode,
    admin1: admin1.present ? admin1.value : this.admin1,
    admin2: admin2.present ? admin2.value : this.admin2,
  );
  ImageLocation copyWithCompanion(ImageLocationsCompanion data) {
    return ImageLocation(
      accountFile:
          data.accountFile.present ? data.accountFile.value : this.accountFile,
      version: data.version.present ? data.version.value : this.version,
      name: data.name.present ? data.name.value : this.name,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      countryCode:
          data.countryCode.present ? data.countryCode.value : this.countryCode,
      admin1: data.admin1.present ? data.admin1.value : this.admin1,
      admin2: data.admin2.present ? data.admin2.value : this.admin2,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImageLocation(')
          ..write('accountFile: $accountFile, ')
          ..write('version: $version, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('countryCode: $countryCode, ')
          ..write('admin1: $admin1, ')
          ..write('admin2: $admin2')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    accountFile,
    version,
    name,
    latitude,
    longitude,
    countryCode,
    admin1,
    admin2,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImageLocation &&
          other.accountFile == this.accountFile &&
          other.version == this.version &&
          other.name == this.name &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.countryCode == this.countryCode &&
          other.admin1 == this.admin1 &&
          other.admin2 == this.admin2);
}

class ImageLocationsCompanion extends UpdateCompanion<ImageLocation> {
  final Value<int> accountFile;
  final Value<int> version;
  final Value<String?> name;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> countryCode;
  final Value<String?> admin1;
  final Value<String?> admin2;
  const ImageLocationsCompanion({
    this.accountFile = const Value.absent(),
    this.version = const Value.absent(),
    this.name = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.admin1 = const Value.absent(),
    this.admin2 = const Value.absent(),
  });
  ImageLocationsCompanion.insert({
    this.accountFile = const Value.absent(),
    required int version,
    this.name = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.admin1 = const Value.absent(),
    this.admin2 = const Value.absent(),
  }) : version = Value(version);
  static Insertable<ImageLocation> custom({
    Expression<int>? accountFile,
    Expression<int>? version,
    Expression<String>? name,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? countryCode,
    Expression<String>? admin1,
    Expression<String>? admin2,
  }) {
    return RawValuesInsertable({
      if (accountFile != null) 'account_file': accountFile,
      if (version != null) 'version': version,
      if (name != null) 'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (countryCode != null) 'country_code': countryCode,
      if (admin1 != null) 'admin1': admin1,
      if (admin2 != null) 'admin2': admin2,
    });
  }

  ImageLocationsCompanion copyWith({
    Value<int>? accountFile,
    Value<int>? version,
    Value<String?>? name,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? countryCode,
    Value<String?>? admin1,
    Value<String?>? admin2,
  }) {
    return ImageLocationsCompanion(
      accountFile: accountFile ?? this.accountFile,
      version: version ?? this.version,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      countryCode: countryCode ?? this.countryCode,
      admin1: admin1 ?? this.admin1,
      admin2: admin2 ?? this.admin2,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountFile.present) {
      map['account_file'] = Variable<int>(accountFile.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (admin1.present) {
      map['admin1'] = Variable<String>(admin1.value);
    }
    if (admin2.present) {
      map['admin2'] = Variable<String>(admin2.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImageLocationsCompanion(')
          ..write('accountFile: $accountFile, ')
          ..write('version: $version, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('countryCode: $countryCode, ')
          ..write('admin1: $admin1, ')
          ..write('admin2: $admin2')
          ..write(')'))
        .toString();
  }
}

class $TrashesTable extends Trashes with TableInfo<$TrashesTable, Trash> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrashesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fileMeta = const VerificationMeta('file');
  @override
  late final GeneratedColumn<int> file = GeneratedColumn<int>(
    'file',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES files (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filenameMeta = const VerificationMeta(
    'filename',
  );
  @override
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
    'filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalLocationMeta = const VerificationMeta(
    'originalLocation',
  );
  @override
  late final GeneratedColumn<String> originalLocation = GeneratedColumn<String>(
    'original_location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletionTimeMeta = const VerificationMeta(
    'deletionTime',
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime> deletionTime =
      GeneratedColumn<DateTime>(
        'deletion_time',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($TrashesTable.$converterdeletionTime);
  @override
  List<GeneratedColumn> get $columns => [
    file,
    filename,
    originalLocation,
    deletionTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trashes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trash> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('file')) {
      context.handle(
        _fileMeta,
        file.isAcceptableOrUnknown(data['file']!, _fileMeta),
      );
    }
    if (data.containsKey('filename')) {
      context.handle(
        _filenameMeta,
        filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta),
      );
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('original_location')) {
      context.handle(
        _originalLocationMeta,
        originalLocation.isAcceptableOrUnknown(
          data['original_location']!,
          _originalLocationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalLocationMeta);
    }
    context.handle(_deletionTimeMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {file};
  @override
  Trash map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trash(
      file:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}file'],
          )!,
      filename:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}filename'],
          )!,
      originalLocation:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}original_location'],
          )!,
      deletionTime: $TrashesTable.$converterdeletionTime.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}deletion_time'],
        )!,
      ),
    );
  }

  @override
  $TrashesTable createAlias(String alias) {
    return $TrashesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, DateTime> $converterdeletionTime =
      const SqliteDateTimeConverter();
}

class Trash extends DataClass implements Insertable<Trash> {
  final int file;
  final String filename;
  final String originalLocation;
  final DateTime deletionTime;
  const Trash({
    required this.file,
    required this.filename,
    required this.originalLocation,
    required this.deletionTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['file'] = Variable<int>(file);
    map['filename'] = Variable<String>(filename);
    map['original_location'] = Variable<String>(originalLocation);
    {
      map['deletion_time'] = Variable<DateTime>(
        $TrashesTable.$converterdeletionTime.toSql(deletionTime),
      );
    }
    return map;
  }

  TrashesCompanion toCompanion(bool nullToAbsent) {
    return TrashesCompanion(
      file: Value(file),
      filename: Value(filename),
      originalLocation: Value(originalLocation),
      deletionTime: Value(deletionTime),
    );
  }

  factory Trash.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trash(
      file: serializer.fromJson<int>(json['file']),
      filename: serializer.fromJson<String>(json['filename']),
      originalLocation: serializer.fromJson<String>(json['originalLocation']),
      deletionTime: serializer.fromJson<DateTime>(json['deletionTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'file': serializer.toJson<int>(file),
      'filename': serializer.toJson<String>(filename),
      'originalLocation': serializer.toJson<String>(originalLocation),
      'deletionTime': serializer.toJson<DateTime>(deletionTime),
    };
  }

  Trash copyWith({
    int? file,
    String? filename,
    String? originalLocation,
    DateTime? deletionTime,
  }) => Trash(
    file: file ?? this.file,
    filename: filename ?? this.filename,
    originalLocation: originalLocation ?? this.originalLocation,
    deletionTime: deletionTime ?? this.deletionTime,
  );
  Trash copyWithCompanion(TrashesCompanion data) {
    return Trash(
      file: data.file.present ? data.file.value : this.file,
      filename: data.filename.present ? data.filename.value : this.filename,
      originalLocation:
          data.originalLocation.present
              ? data.originalLocation.value
              : this.originalLocation,
      deletionTime:
          data.deletionTime.present
              ? data.deletionTime.value
              : this.deletionTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trash(')
          ..write('file: $file, ')
          ..write('filename: $filename, ')
          ..write('originalLocation: $originalLocation, ')
          ..write('deletionTime: $deletionTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(file, filename, originalLocation, deletionTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trash &&
          other.file == this.file &&
          other.filename == this.filename &&
          other.originalLocation == this.originalLocation &&
          other.deletionTime == this.deletionTime);
}

class TrashesCompanion extends UpdateCompanion<Trash> {
  final Value<int> file;
  final Value<String> filename;
  final Value<String> originalLocation;
  final Value<DateTime> deletionTime;
  const TrashesCompanion({
    this.file = const Value.absent(),
    this.filename = const Value.absent(),
    this.originalLocation = const Value.absent(),
    this.deletionTime = const Value.absent(),
  });
  TrashesCompanion.insert({
    this.file = const Value.absent(),
    required String filename,
    required String originalLocation,
    required DateTime deletionTime,
  }) : filename = Value(filename),
       originalLocation = Value(originalLocation),
       deletionTime = Value(deletionTime);
  static Insertable<Trash> custom({
    Expression<int>? file,
    Expression<String>? filename,
    Expression<String>? originalLocation,
    Expression<DateTime>? deletionTime,
  }) {
    return RawValuesInsertable({
      if (file != null) 'file': file,
      if (filename != null) 'filename': filename,
      if (originalLocation != null) 'original_location': originalLocation,
      if (deletionTime != null) 'deletion_time': deletionTime,
    });
  }

  TrashesCompanion copyWith({
    Value<int>? file,
    Value<String>? filename,
    Value<String>? originalLocation,
    Value<DateTime>? deletionTime,
  }) {
    return TrashesCompanion(
      file: file ?? this.file,
      filename: filename ?? this.filename,
      originalLocation: originalLocation ?? this.originalLocation,
      deletionTime: deletionTime ?? this.deletionTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (file.present) {
      map['file'] = Variable<int>(file.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (originalLocation.present) {
      map['original_location'] = Variable<String>(originalLocation.value);
    }
    if (deletionTime.present) {
      map['deletion_time'] = Variable<DateTime>(
        $TrashesTable.$converterdeletionTime.toSql(deletionTime.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrashesCompanion(')
          ..write('file: $file, ')
          ..write('filename: $filename, ')
          ..write('originalLocation: $originalLocation, ')
          ..write('deletionTime: $deletionTime')
          ..write(')'))
        .toString();
  }
}

class $DirFilesTable extends DirFiles with TableInfo<$DirFilesTable, DirFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DirFilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dirMeta = const VerificationMeta('dir');
  @override
  late final GeneratedColumn<int> dir = GeneratedColumn<int>(
    'dir',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES files (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _childMeta = const VerificationMeta('child');
  @override
  late final GeneratedColumn<int> child = GeneratedColumn<int>(
    'child',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES files (row_id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [dir, child];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dir_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<DirFile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('dir')) {
      context.handle(
        _dirMeta,
        dir.isAcceptableOrUnknown(data['dir']!, _dirMeta),
      );
    } else if (isInserting) {
      context.missing(_dirMeta);
    }
    if (data.containsKey('child')) {
      context.handle(
        _childMeta,
        child.isAcceptableOrUnknown(data['child']!, _childMeta),
      );
    } else if (isInserting) {
      context.missing(_childMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dir, child};
  @override
  DirFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DirFile(
      dir:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}dir'],
          )!,
      child:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}child'],
          )!,
    );
  }

  @override
  $DirFilesTable createAlias(String alias) {
    return $DirFilesTable(attachedDatabase, alias);
  }
}

class DirFile extends DataClass implements Insertable<DirFile> {
  final int dir;
  final int child;
  const DirFile({required this.dir, required this.child});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['dir'] = Variable<int>(dir);
    map['child'] = Variable<int>(child);
    return map;
  }

  DirFilesCompanion toCompanion(bool nullToAbsent) {
    return DirFilesCompanion(dir: Value(dir), child: Value(child));
  }

  factory DirFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DirFile(
      dir: serializer.fromJson<int>(json['dir']),
      child: serializer.fromJson<int>(json['child']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dir': serializer.toJson<int>(dir),
      'child': serializer.toJson<int>(child),
    };
  }

  DirFile copyWith({int? dir, int? child}) =>
      DirFile(dir: dir ?? this.dir, child: child ?? this.child);
  DirFile copyWithCompanion(DirFilesCompanion data) {
    return DirFile(
      dir: data.dir.present ? data.dir.value : this.dir,
      child: data.child.present ? data.child.value : this.child,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DirFile(')
          ..write('dir: $dir, ')
          ..write('child: $child')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dir, child);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DirFile && other.dir == this.dir && other.child == this.child);
}

class DirFilesCompanion extends UpdateCompanion<DirFile> {
  final Value<int> dir;
  final Value<int> child;
  final Value<int> rowid;
  const DirFilesCompanion({
    this.dir = const Value.absent(),
    this.child = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DirFilesCompanion.insert({
    required int dir,
    required int child,
    this.rowid = const Value.absent(),
  }) : dir = Value(dir),
       child = Value(child);
  static Insertable<DirFile> custom({
    Expression<int>? dir,
    Expression<int>? child,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dir != null) 'dir': dir,
      if (child != null) 'child': child,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DirFilesCompanion copyWith({
    Value<int>? dir,
    Value<int>? child,
    Value<int>? rowid,
  }) {
    return DirFilesCompanion(
      dir: dir ?? this.dir,
      child: child ?? this.child,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dir.present) {
      map['dir'] = Variable<int>(dir.value);
    }
    if (child.present) {
      map['child'] = Variable<int>(child.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DirFilesCompanion(')
          ..write('dir: $dir, ')
          ..write('child: $child, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, Album> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fileMeta = const VerificationMeta('file');
  @override
  late final GeneratedColumn<int> file = GeneratedColumn<int>(
    'file',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES files (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _fileEtagMeta = const VerificationMeta(
    'fileEtag',
  );
  @override
  late final GeneratedColumn<String> fileEtag = GeneratedColumn<String>(
    'file_etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime> lastUpdated =
      GeneratedColumn<DateTime>(
        'last_updated',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($AlbumsTable.$converterlastUpdated);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerTypeMeta = const VerificationMeta(
    'providerType',
  );
  @override
  late final GeneratedColumn<String> providerType = GeneratedColumn<String>(
    'provider_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerContentMeta = const VerificationMeta(
    'providerContent',
  );
  @override
  late final GeneratedColumn<String> providerContent = GeneratedColumn<String>(
    'provider_content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverProviderTypeMeta = const VerificationMeta(
    'coverProviderType',
  );
  @override
  late final GeneratedColumn<String> coverProviderType =
      GeneratedColumn<String>(
        'cover_provider_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _coverProviderContentMeta =
      const VerificationMeta('coverProviderContent');
  @override
  late final GeneratedColumn<String> coverProviderContent =
      GeneratedColumn<String>(
        'cover_provider_content',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sortProviderTypeMeta = const VerificationMeta(
    'sortProviderType',
  );
  @override
  late final GeneratedColumn<String> sortProviderType = GeneratedColumn<String>(
    'sort_provider_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortProviderContentMeta =
      const VerificationMeta('sortProviderContent');
  @override
  late final GeneratedColumn<String> sortProviderContent =
      GeneratedColumn<String>(
        'sort_provider_content',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    file,
    fileEtag,
    version,
    lastUpdated,
    name,
    providerType,
    providerContent,
    coverProviderType,
    coverProviderContent,
    sortProviderType,
    sortProviderContent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'albums';
  @override
  VerificationContext validateIntegrity(
    Insertable<Album> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('file')) {
      context.handle(
        _fileMeta,
        file.isAcceptableOrUnknown(data['file']!, _fileMeta),
      );
    } else if (isInserting) {
      context.missing(_fileMeta);
    }
    if (data.containsKey('file_etag')) {
      context.handle(
        _fileEtagMeta,
        fileEtag.isAcceptableOrUnknown(data['file_etag']!, _fileEtagMeta),
      );
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    context.handle(_lastUpdatedMeta, const VerificationResult.success());
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('provider_type')) {
      context.handle(
        _providerTypeMeta,
        providerType.isAcceptableOrUnknown(
          data['provider_type']!,
          _providerTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerTypeMeta);
    }
    if (data.containsKey('provider_content')) {
      context.handle(
        _providerContentMeta,
        providerContent.isAcceptableOrUnknown(
          data['provider_content']!,
          _providerContentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_providerContentMeta);
    }
    if (data.containsKey('cover_provider_type')) {
      context.handle(
        _coverProviderTypeMeta,
        coverProviderType.isAcceptableOrUnknown(
          data['cover_provider_type']!,
          _coverProviderTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_coverProviderTypeMeta);
    }
    if (data.containsKey('cover_provider_content')) {
      context.handle(
        _coverProviderContentMeta,
        coverProviderContent.isAcceptableOrUnknown(
          data['cover_provider_content']!,
          _coverProviderContentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_coverProviderContentMeta);
    }
    if (data.containsKey('sort_provider_type')) {
      context.handle(
        _sortProviderTypeMeta,
        sortProviderType.isAcceptableOrUnknown(
          data['sort_provider_type']!,
          _sortProviderTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sortProviderTypeMeta);
    }
    if (data.containsKey('sort_provider_content')) {
      context.handle(
        _sortProviderContentMeta,
        sortProviderContent.isAcceptableOrUnknown(
          data['sort_provider_content']!,
          _sortProviderContentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sortProviderContentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  Album map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Album(
      rowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}row_id'],
          )!,
      file:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}file'],
          )!,
      fileEtag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_etag'],
      ),
      version:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}version'],
          )!,
      lastUpdated: $AlbumsTable.$converterlastUpdated.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_updated'],
        )!,
      ),
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      providerType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}provider_type'],
          )!,
      providerContent:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}provider_content'],
          )!,
      coverProviderType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}cover_provider_type'],
          )!,
      coverProviderContent:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}cover_provider_content'],
          )!,
      sortProviderType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sort_provider_type'],
          )!,
      sortProviderContent:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sort_provider_content'],
          )!,
    );
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, DateTime> $converterlastUpdated =
      const SqliteDateTimeConverter();
}

class Album extends DataClass implements Insertable<Album> {
  final int rowId;
  final int file;
  final String? fileEtag;
  final int version;
  final DateTime lastUpdated;
  final String name;
  final String providerType;
  final String providerContent;
  final String coverProviderType;
  final String coverProviderContent;
  final String sortProviderType;
  final String sortProviderContent;
  const Album({
    required this.rowId,
    required this.file,
    this.fileEtag,
    required this.version,
    required this.lastUpdated,
    required this.name,
    required this.providerType,
    required this.providerContent,
    required this.coverProviderType,
    required this.coverProviderContent,
    required this.sortProviderType,
    required this.sortProviderContent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['file'] = Variable<int>(file);
    if (!nullToAbsent || fileEtag != null) {
      map['file_etag'] = Variable<String>(fileEtag);
    }
    map['version'] = Variable<int>(version);
    {
      map['last_updated'] = Variable<DateTime>(
        $AlbumsTable.$converterlastUpdated.toSql(lastUpdated),
      );
    }
    map['name'] = Variable<String>(name);
    map['provider_type'] = Variable<String>(providerType);
    map['provider_content'] = Variable<String>(providerContent);
    map['cover_provider_type'] = Variable<String>(coverProviderType);
    map['cover_provider_content'] = Variable<String>(coverProviderContent);
    map['sort_provider_type'] = Variable<String>(sortProviderType);
    map['sort_provider_content'] = Variable<String>(sortProviderContent);
    return map;
  }

  AlbumsCompanion toCompanion(bool nullToAbsent) {
    return AlbumsCompanion(
      rowId: Value(rowId),
      file: Value(file),
      fileEtag:
          fileEtag == null && nullToAbsent
              ? const Value.absent()
              : Value(fileEtag),
      version: Value(version),
      lastUpdated: Value(lastUpdated),
      name: Value(name),
      providerType: Value(providerType),
      providerContent: Value(providerContent),
      coverProviderType: Value(coverProviderType),
      coverProviderContent: Value(coverProviderContent),
      sortProviderType: Value(sortProviderType),
      sortProviderContent: Value(sortProviderContent),
    );
  }

  factory Album.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Album(
      rowId: serializer.fromJson<int>(json['rowId']),
      file: serializer.fromJson<int>(json['file']),
      fileEtag: serializer.fromJson<String?>(json['fileEtag']),
      version: serializer.fromJson<int>(json['version']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      name: serializer.fromJson<String>(json['name']),
      providerType: serializer.fromJson<String>(json['providerType']),
      providerContent: serializer.fromJson<String>(json['providerContent']),
      coverProviderType: serializer.fromJson<String>(json['coverProviderType']),
      coverProviderContent: serializer.fromJson<String>(
        json['coverProviderContent'],
      ),
      sortProviderType: serializer.fromJson<String>(json['sortProviderType']),
      sortProviderContent: serializer.fromJson<String>(
        json['sortProviderContent'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'file': serializer.toJson<int>(file),
      'fileEtag': serializer.toJson<String?>(fileEtag),
      'version': serializer.toJson<int>(version),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'name': serializer.toJson<String>(name),
      'providerType': serializer.toJson<String>(providerType),
      'providerContent': serializer.toJson<String>(providerContent),
      'coverProviderType': serializer.toJson<String>(coverProviderType),
      'coverProviderContent': serializer.toJson<String>(coverProviderContent),
      'sortProviderType': serializer.toJson<String>(sortProviderType),
      'sortProviderContent': serializer.toJson<String>(sortProviderContent),
    };
  }

  Album copyWith({
    int? rowId,
    int? file,
    Value<String?> fileEtag = const Value.absent(),
    int? version,
    DateTime? lastUpdated,
    String? name,
    String? providerType,
    String? providerContent,
    String? coverProviderType,
    String? coverProviderContent,
    String? sortProviderType,
    String? sortProviderContent,
  }) => Album(
    rowId: rowId ?? this.rowId,
    file: file ?? this.file,
    fileEtag: fileEtag.present ? fileEtag.value : this.fileEtag,
    version: version ?? this.version,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    name: name ?? this.name,
    providerType: providerType ?? this.providerType,
    providerContent: providerContent ?? this.providerContent,
    coverProviderType: coverProviderType ?? this.coverProviderType,
    coverProviderContent: coverProviderContent ?? this.coverProviderContent,
    sortProviderType: sortProviderType ?? this.sortProviderType,
    sortProviderContent: sortProviderContent ?? this.sortProviderContent,
  );
  Album copyWithCompanion(AlbumsCompanion data) {
    return Album(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      file: data.file.present ? data.file.value : this.file,
      fileEtag: data.fileEtag.present ? data.fileEtag.value : this.fileEtag,
      version: data.version.present ? data.version.value : this.version,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      name: data.name.present ? data.name.value : this.name,
      providerType:
          data.providerType.present
              ? data.providerType.value
              : this.providerType,
      providerContent:
          data.providerContent.present
              ? data.providerContent.value
              : this.providerContent,
      coverProviderType:
          data.coverProviderType.present
              ? data.coverProviderType.value
              : this.coverProviderType,
      coverProviderContent:
          data.coverProviderContent.present
              ? data.coverProviderContent.value
              : this.coverProviderContent,
      sortProviderType:
          data.sortProviderType.present
              ? data.sortProviderType.value
              : this.sortProviderType,
      sortProviderContent:
          data.sortProviderContent.present
              ? data.sortProviderContent.value
              : this.sortProviderContent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Album(')
          ..write('rowId: $rowId, ')
          ..write('file: $file, ')
          ..write('fileEtag: $fileEtag, ')
          ..write('version: $version, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('name: $name, ')
          ..write('providerType: $providerType, ')
          ..write('providerContent: $providerContent, ')
          ..write('coverProviderType: $coverProviderType, ')
          ..write('coverProviderContent: $coverProviderContent, ')
          ..write('sortProviderType: $sortProviderType, ')
          ..write('sortProviderContent: $sortProviderContent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    file,
    fileEtag,
    version,
    lastUpdated,
    name,
    providerType,
    providerContent,
    coverProviderType,
    coverProviderContent,
    sortProviderType,
    sortProviderContent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Album &&
          other.rowId == this.rowId &&
          other.file == this.file &&
          other.fileEtag == this.fileEtag &&
          other.version == this.version &&
          other.lastUpdated == this.lastUpdated &&
          other.name == this.name &&
          other.providerType == this.providerType &&
          other.providerContent == this.providerContent &&
          other.coverProviderType == this.coverProviderType &&
          other.coverProviderContent == this.coverProviderContent &&
          other.sortProviderType == this.sortProviderType &&
          other.sortProviderContent == this.sortProviderContent);
}

class AlbumsCompanion extends UpdateCompanion<Album> {
  final Value<int> rowId;
  final Value<int> file;
  final Value<String?> fileEtag;
  final Value<int> version;
  final Value<DateTime> lastUpdated;
  final Value<String> name;
  final Value<String> providerType;
  final Value<String> providerContent;
  final Value<String> coverProviderType;
  final Value<String> coverProviderContent;
  final Value<String> sortProviderType;
  final Value<String> sortProviderContent;
  const AlbumsCompanion({
    this.rowId = const Value.absent(),
    this.file = const Value.absent(),
    this.fileEtag = const Value.absent(),
    this.version = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.name = const Value.absent(),
    this.providerType = const Value.absent(),
    this.providerContent = const Value.absent(),
    this.coverProviderType = const Value.absent(),
    this.coverProviderContent = const Value.absent(),
    this.sortProviderType = const Value.absent(),
    this.sortProviderContent = const Value.absent(),
  });
  AlbumsCompanion.insert({
    this.rowId = const Value.absent(),
    required int file,
    this.fileEtag = const Value.absent(),
    required int version,
    required DateTime lastUpdated,
    required String name,
    required String providerType,
    required String providerContent,
    required String coverProviderType,
    required String coverProviderContent,
    required String sortProviderType,
    required String sortProviderContent,
  }) : file = Value(file),
       version = Value(version),
       lastUpdated = Value(lastUpdated),
       name = Value(name),
       providerType = Value(providerType),
       providerContent = Value(providerContent),
       coverProviderType = Value(coverProviderType),
       coverProviderContent = Value(coverProviderContent),
       sortProviderType = Value(sortProviderType),
       sortProviderContent = Value(sortProviderContent);
  static Insertable<Album> custom({
    Expression<int>? rowId,
    Expression<int>? file,
    Expression<String>? fileEtag,
    Expression<int>? version,
    Expression<DateTime>? lastUpdated,
    Expression<String>? name,
    Expression<String>? providerType,
    Expression<String>? providerContent,
    Expression<String>? coverProviderType,
    Expression<String>? coverProviderContent,
    Expression<String>? sortProviderType,
    Expression<String>? sortProviderContent,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (file != null) 'file': file,
      if (fileEtag != null) 'file_etag': fileEtag,
      if (version != null) 'version': version,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (name != null) 'name': name,
      if (providerType != null) 'provider_type': providerType,
      if (providerContent != null) 'provider_content': providerContent,
      if (coverProviderType != null) 'cover_provider_type': coverProviderType,
      if (coverProviderContent != null)
        'cover_provider_content': coverProviderContent,
      if (sortProviderType != null) 'sort_provider_type': sortProviderType,
      if (sortProviderContent != null)
        'sort_provider_content': sortProviderContent,
    });
  }

  AlbumsCompanion copyWith({
    Value<int>? rowId,
    Value<int>? file,
    Value<String?>? fileEtag,
    Value<int>? version,
    Value<DateTime>? lastUpdated,
    Value<String>? name,
    Value<String>? providerType,
    Value<String>? providerContent,
    Value<String>? coverProviderType,
    Value<String>? coverProviderContent,
    Value<String>? sortProviderType,
    Value<String>? sortProviderContent,
  }) {
    return AlbumsCompanion(
      rowId: rowId ?? this.rowId,
      file: file ?? this.file,
      fileEtag: fileEtag ?? this.fileEtag,
      version: version ?? this.version,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      name: name ?? this.name,
      providerType: providerType ?? this.providerType,
      providerContent: providerContent ?? this.providerContent,
      coverProviderType: coverProviderType ?? this.coverProviderType,
      coverProviderContent: coverProviderContent ?? this.coverProviderContent,
      sortProviderType: sortProviderType ?? this.sortProviderType,
      sortProviderContent: sortProviderContent ?? this.sortProviderContent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (file.present) {
      map['file'] = Variable<int>(file.value);
    }
    if (fileEtag.present) {
      map['file_etag'] = Variable<String>(fileEtag.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(
        $AlbumsTable.$converterlastUpdated.toSql(lastUpdated.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (providerType.present) {
      map['provider_type'] = Variable<String>(providerType.value);
    }
    if (providerContent.present) {
      map['provider_content'] = Variable<String>(providerContent.value);
    }
    if (coverProviderType.present) {
      map['cover_provider_type'] = Variable<String>(coverProviderType.value);
    }
    if (coverProviderContent.present) {
      map['cover_provider_content'] = Variable<String>(
        coverProviderContent.value,
      );
    }
    if (sortProviderType.present) {
      map['sort_provider_type'] = Variable<String>(sortProviderType.value);
    }
    if (sortProviderContent.present) {
      map['sort_provider_content'] = Variable<String>(
        sortProviderContent.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('file: $file, ')
          ..write('fileEtag: $fileEtag, ')
          ..write('version: $version, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('name: $name, ')
          ..write('providerType: $providerType, ')
          ..write('providerContent: $providerContent, ')
          ..write('coverProviderType: $coverProviderType, ')
          ..write('coverProviderContent: $coverProviderContent, ')
          ..write('sortProviderType: $sortProviderType, ')
          ..write('sortProviderContent: $sortProviderContent')
          ..write(')'))
        .toString();
  }
}

class $AlbumSharesTable extends AlbumShares
    with TableInfo<$AlbumSharesTable, AlbumShare> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumSharesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _albumMeta = const VerificationMeta('album');
  @override
  late final GeneratedColumn<int> album = GeneratedColumn<int>(
    'album',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES albums (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sharedAtMeta = const VerificationMeta(
    'sharedAt',
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, DateTime> sharedAt =
      GeneratedColumn<DateTime>(
        'shared_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($AlbumSharesTable.$convertersharedAt);
  @override
  List<GeneratedColumn> get $columns => [album, userId, displayName, sharedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'album_shares';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlbumShare> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('album')) {
      context.handle(
        _albumMeta,
        album.isAcceptableOrUnknown(data['album']!, _albumMeta),
      );
    } else if (isInserting) {
      context.missing(_albumMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    context.handle(_sharedAtMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {album, userId};
  @override
  AlbumShare map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlbumShare(
      album:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}album'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      sharedAt: $AlbumSharesTable.$convertersharedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}shared_at'],
        )!,
      ),
    );
  }

  @override
  $AlbumSharesTable createAlias(String alias) {
    return $AlbumSharesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, DateTime> $convertersharedAt =
      const SqliteDateTimeConverter();
}

class AlbumShare extends DataClass implements Insertable<AlbumShare> {
  final int album;
  final String userId;
  final String? displayName;
  final DateTime sharedAt;
  const AlbumShare({
    required this.album,
    required this.userId,
    this.displayName,
    required this.sharedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['album'] = Variable<int>(album);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    {
      map['shared_at'] = Variable<DateTime>(
        $AlbumSharesTable.$convertersharedAt.toSql(sharedAt),
      );
    }
    return map;
  }

  AlbumSharesCompanion toCompanion(bool nullToAbsent) {
    return AlbumSharesCompanion(
      album: Value(album),
      userId: Value(userId),
      displayName:
          displayName == null && nullToAbsent
              ? const Value.absent()
              : Value(displayName),
      sharedAt: Value(sharedAt),
    );
  }

  factory AlbumShare.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlbumShare(
      album: serializer.fromJson<int>(json['album']),
      userId: serializer.fromJson<String>(json['userId']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      sharedAt: serializer.fromJson<DateTime>(json['sharedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'album': serializer.toJson<int>(album),
      'userId': serializer.toJson<String>(userId),
      'displayName': serializer.toJson<String?>(displayName),
      'sharedAt': serializer.toJson<DateTime>(sharedAt),
    };
  }

  AlbumShare copyWith({
    int? album,
    String? userId,
    Value<String?> displayName = const Value.absent(),
    DateTime? sharedAt,
  }) => AlbumShare(
    album: album ?? this.album,
    userId: userId ?? this.userId,
    displayName: displayName.present ? displayName.value : this.displayName,
    sharedAt: sharedAt ?? this.sharedAt,
  );
  AlbumShare copyWithCompanion(AlbumSharesCompanion data) {
    return AlbumShare(
      album: data.album.present ? data.album.value : this.album,
      userId: data.userId.present ? data.userId.value : this.userId,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      sharedAt: data.sharedAt.present ? data.sharedAt.value : this.sharedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlbumShare(')
          ..write('album: $album, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('sharedAt: $sharedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(album, userId, displayName, sharedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlbumShare &&
          other.album == this.album &&
          other.userId == this.userId &&
          other.displayName == this.displayName &&
          other.sharedAt == this.sharedAt);
}

class AlbumSharesCompanion extends UpdateCompanion<AlbumShare> {
  final Value<int> album;
  final Value<String> userId;
  final Value<String?> displayName;
  final Value<DateTime> sharedAt;
  final Value<int> rowid;
  const AlbumSharesCompanion({
    this.album = const Value.absent(),
    this.userId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.sharedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlbumSharesCompanion.insert({
    required int album,
    required String userId,
    this.displayName = const Value.absent(),
    required DateTime sharedAt,
    this.rowid = const Value.absent(),
  }) : album = Value(album),
       userId = Value(userId),
       sharedAt = Value(sharedAt);
  static Insertable<AlbumShare> custom({
    Expression<int>? album,
    Expression<String>? userId,
    Expression<String>? displayName,
    Expression<DateTime>? sharedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (album != null) 'album': album,
      if (userId != null) 'user_id': userId,
      if (displayName != null) 'display_name': displayName,
      if (sharedAt != null) 'shared_at': sharedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlbumSharesCompanion copyWith({
    Value<int>? album,
    Value<String>? userId,
    Value<String?>? displayName,
    Value<DateTime>? sharedAt,
    Value<int>? rowid,
  }) {
    return AlbumSharesCompanion(
      album: album ?? this.album,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      sharedAt: sharedAt ?? this.sharedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (album.present) {
      map['album'] = Variable<int>(album.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (sharedAt.present) {
      map['shared_at'] = Variable<DateTime>(
        $AlbumSharesTable.$convertersharedAt.toSql(sharedAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumSharesCompanion(')
          ..write('album: $album, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('sharedAt: $sharedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverMeta = const VerificationMeta('server');
  @override
  late final GeneratedColumn<int> server = GeneratedColumn<int>(
    'server',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES servers (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userVisibleMeta = const VerificationMeta(
    'userVisible',
  );
  @override
  late final GeneratedColumn<bool> userVisible = GeneratedColumn<bool>(
    'user_visible',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_visible" IN (0, 1))',
    ),
  );
  static const VerificationMeta _userAssignableMeta = const VerificationMeta(
    'userAssignable',
  );
  @override
  late final GeneratedColumn<bool> userAssignable = GeneratedColumn<bool>(
    'user_assignable',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("user_assignable" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    server,
    tagId,
    displayName,
    userVisible,
    userAssignable,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('server')) {
      context.handle(
        _serverMeta,
        server.isAcceptableOrUnknown(data['server']!, _serverMeta),
      );
    } else if (isInserting) {
      context.missing(_serverMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('user_visible')) {
      context.handle(
        _userVisibleMeta,
        userVisible.isAcceptableOrUnknown(
          data['user_visible']!,
          _userVisibleMeta,
        ),
      );
    }
    if (data.containsKey('user_assignable')) {
      context.handle(
        _userAssignableMeta,
        userAssignable.isAcceptableOrUnknown(
          data['user_assignable']!,
          _userAssignableMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {server, tagId},
  ];
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      rowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}row_id'],
          )!,
      server:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}server'],
          )!,
      tagId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}tag_id'],
          )!,
      displayName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}display_name'],
          )!,
      userVisible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}user_visible'],
      ),
      userAssignable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}user_assignable'],
      ),
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int rowId;
  final int server;
  final int tagId;
  final String displayName;
  final bool? userVisible;
  final bool? userAssignable;
  const Tag({
    required this.rowId,
    required this.server,
    required this.tagId,
    required this.displayName,
    this.userVisible,
    this.userAssignable,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['server'] = Variable<int>(server);
    map['tag_id'] = Variable<int>(tagId);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || userVisible != null) {
      map['user_visible'] = Variable<bool>(userVisible);
    }
    if (!nullToAbsent || userAssignable != null) {
      map['user_assignable'] = Variable<bool>(userAssignable);
    }
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      rowId: Value(rowId),
      server: Value(server),
      tagId: Value(tagId),
      displayName: Value(displayName),
      userVisible:
          userVisible == null && nullToAbsent
              ? const Value.absent()
              : Value(userVisible),
      userAssignable:
          userAssignable == null && nullToAbsent
              ? const Value.absent()
              : Value(userAssignable),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      rowId: serializer.fromJson<int>(json['rowId']),
      server: serializer.fromJson<int>(json['server']),
      tagId: serializer.fromJson<int>(json['tagId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      userVisible: serializer.fromJson<bool?>(json['userVisible']),
      userAssignable: serializer.fromJson<bool?>(json['userAssignable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'server': serializer.toJson<int>(server),
      'tagId': serializer.toJson<int>(tagId),
      'displayName': serializer.toJson<String>(displayName),
      'userVisible': serializer.toJson<bool?>(userVisible),
      'userAssignable': serializer.toJson<bool?>(userAssignable),
    };
  }

  Tag copyWith({
    int? rowId,
    int? server,
    int? tagId,
    String? displayName,
    Value<bool?> userVisible = const Value.absent(),
    Value<bool?> userAssignable = const Value.absent(),
  }) => Tag(
    rowId: rowId ?? this.rowId,
    server: server ?? this.server,
    tagId: tagId ?? this.tagId,
    displayName: displayName ?? this.displayName,
    userVisible: userVisible.present ? userVisible.value : this.userVisible,
    userAssignable:
        userAssignable.present ? userAssignable.value : this.userAssignable,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      server: data.server.present ? data.server.value : this.server,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      userVisible:
          data.userVisible.present ? data.userVisible.value : this.userVisible,
      userAssignable:
          data.userAssignable.present
              ? data.userAssignable.value
              : this.userAssignable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('rowId: $rowId, ')
          ..write('server: $server, ')
          ..write('tagId: $tagId, ')
          ..write('displayName: $displayName, ')
          ..write('userVisible: $userVisible, ')
          ..write('userAssignable: $userAssignable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    server,
    tagId,
    displayName,
    userVisible,
    userAssignable,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.rowId == this.rowId &&
          other.server == this.server &&
          other.tagId == this.tagId &&
          other.displayName == this.displayName &&
          other.userVisible == this.userVisible &&
          other.userAssignable == this.userAssignable);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> rowId;
  final Value<int> server;
  final Value<int> tagId;
  final Value<String> displayName;
  final Value<bool?> userVisible;
  final Value<bool?> userAssignable;
  const TagsCompanion({
    this.rowId = const Value.absent(),
    this.server = const Value.absent(),
    this.tagId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.userVisible = const Value.absent(),
    this.userAssignable = const Value.absent(),
  });
  TagsCompanion.insert({
    this.rowId = const Value.absent(),
    required int server,
    required int tagId,
    required String displayName,
    this.userVisible = const Value.absent(),
    this.userAssignable = const Value.absent(),
  }) : server = Value(server),
       tagId = Value(tagId),
       displayName = Value(displayName);
  static Insertable<Tag> custom({
    Expression<int>? rowId,
    Expression<int>? server,
    Expression<int>? tagId,
    Expression<String>? displayName,
    Expression<bool>? userVisible,
    Expression<bool>? userAssignable,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (server != null) 'server': server,
      if (tagId != null) 'tag_id': tagId,
      if (displayName != null) 'display_name': displayName,
      if (userVisible != null) 'user_visible': userVisible,
      if (userAssignable != null) 'user_assignable': userAssignable,
    });
  }

  TagsCompanion copyWith({
    Value<int>? rowId,
    Value<int>? server,
    Value<int>? tagId,
    Value<String>? displayName,
    Value<bool?>? userVisible,
    Value<bool?>? userAssignable,
  }) {
    return TagsCompanion(
      rowId: rowId ?? this.rowId,
      server: server ?? this.server,
      tagId: tagId ?? this.tagId,
      displayName: displayName ?? this.displayName,
      userVisible: userVisible ?? this.userVisible,
      userAssignable: userAssignable ?? this.userAssignable,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (server.present) {
      map['server'] = Variable<int>(server.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (userVisible.present) {
      map['user_visible'] = Variable<bool>(userVisible.value);
    }
    if (userAssignable.present) {
      map['user_assignable'] = Variable<bool>(userAssignable.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('server: $server, ')
          ..write('tagId: $tagId, ')
          ..write('displayName: $displayName, ')
          ..write('userVisible: $userVisible, ')
          ..write('userAssignable: $userAssignable')
          ..write(')'))
        .toString();
  }
}

class $FaceRecognitionPersonsTable extends FaceRecognitionPersons
    with TableInfo<$FaceRecognitionPersonsTable, FaceRecognitionPerson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FaceRecognitionPersonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountMeta = const VerificationMeta(
    'account',
  );
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
    'account',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbFaceIdMeta = const VerificationMeta(
    'thumbFaceId',
  );
  @override
  late final GeneratedColumn<int> thumbFaceId = GeneratedColumn<int>(
    'thumb_face_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    account,
    name,
    thumbFaceId,
    count,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'face_recognition_persons';
  @override
  VerificationContext validateIntegrity(
    Insertable<FaceRecognitionPerson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('account')) {
      context.handle(
        _accountMeta,
        account.isAcceptableOrUnknown(data['account']!, _accountMeta),
      );
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('thumb_face_id')) {
      context.handle(
        _thumbFaceIdMeta,
        thumbFaceId.isAcceptableOrUnknown(
          data['thumb_face_id']!,
          _thumbFaceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_thumbFaceIdMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {account, name},
  ];
  @override
  FaceRecognitionPerson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FaceRecognitionPerson(
      rowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}row_id'],
          )!,
      account:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}account'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      thumbFaceId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}thumb_face_id'],
          )!,
      count:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}count'],
          )!,
    );
  }

  @override
  $FaceRecognitionPersonsTable createAlias(String alias) {
    return $FaceRecognitionPersonsTable(attachedDatabase, alias);
  }
}

class FaceRecognitionPerson extends DataClass
    implements Insertable<FaceRecognitionPerson> {
  final int rowId;
  final int account;
  final String name;
  final int thumbFaceId;
  final int count;
  const FaceRecognitionPerson({
    required this.rowId,
    required this.account,
    required this.name,
    required this.thumbFaceId,
    required this.count,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['account'] = Variable<int>(account);
    map['name'] = Variable<String>(name);
    map['thumb_face_id'] = Variable<int>(thumbFaceId);
    map['count'] = Variable<int>(count);
    return map;
  }

  FaceRecognitionPersonsCompanion toCompanion(bool nullToAbsent) {
    return FaceRecognitionPersonsCompanion(
      rowId: Value(rowId),
      account: Value(account),
      name: Value(name),
      thumbFaceId: Value(thumbFaceId),
      count: Value(count),
    );
  }

  factory FaceRecognitionPerson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FaceRecognitionPerson(
      rowId: serializer.fromJson<int>(json['rowId']),
      account: serializer.fromJson<int>(json['account']),
      name: serializer.fromJson<String>(json['name']),
      thumbFaceId: serializer.fromJson<int>(json['thumbFaceId']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'account': serializer.toJson<int>(account),
      'name': serializer.toJson<String>(name),
      'thumbFaceId': serializer.toJson<int>(thumbFaceId),
      'count': serializer.toJson<int>(count),
    };
  }

  FaceRecognitionPerson copyWith({
    int? rowId,
    int? account,
    String? name,
    int? thumbFaceId,
    int? count,
  }) => FaceRecognitionPerson(
    rowId: rowId ?? this.rowId,
    account: account ?? this.account,
    name: name ?? this.name,
    thumbFaceId: thumbFaceId ?? this.thumbFaceId,
    count: count ?? this.count,
  );
  FaceRecognitionPerson copyWithCompanion(
    FaceRecognitionPersonsCompanion data,
  ) {
    return FaceRecognitionPerson(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      account: data.account.present ? data.account.value : this.account,
      name: data.name.present ? data.name.value : this.name,
      thumbFaceId:
          data.thumbFaceId.present ? data.thumbFaceId.value : this.thumbFaceId,
      count: data.count.present ? data.count.value : this.count,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FaceRecognitionPerson(')
          ..write('rowId: $rowId, ')
          ..write('account: $account, ')
          ..write('name: $name, ')
          ..write('thumbFaceId: $thumbFaceId, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, account, name, thumbFaceId, count);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FaceRecognitionPerson &&
          other.rowId == this.rowId &&
          other.account == this.account &&
          other.name == this.name &&
          other.thumbFaceId == this.thumbFaceId &&
          other.count == this.count);
}

class FaceRecognitionPersonsCompanion
    extends UpdateCompanion<FaceRecognitionPerson> {
  final Value<int> rowId;
  final Value<int> account;
  final Value<String> name;
  final Value<int> thumbFaceId;
  final Value<int> count;
  const FaceRecognitionPersonsCompanion({
    this.rowId = const Value.absent(),
    this.account = const Value.absent(),
    this.name = const Value.absent(),
    this.thumbFaceId = const Value.absent(),
    this.count = const Value.absent(),
  });
  FaceRecognitionPersonsCompanion.insert({
    this.rowId = const Value.absent(),
    required int account,
    required String name,
    required int thumbFaceId,
    required int count,
  }) : account = Value(account),
       name = Value(name),
       thumbFaceId = Value(thumbFaceId),
       count = Value(count);
  static Insertable<FaceRecognitionPerson> custom({
    Expression<int>? rowId,
    Expression<int>? account,
    Expression<String>? name,
    Expression<int>? thumbFaceId,
    Expression<int>? count,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (account != null) 'account': account,
      if (name != null) 'name': name,
      if (thumbFaceId != null) 'thumb_face_id': thumbFaceId,
      if (count != null) 'count': count,
    });
  }

  FaceRecognitionPersonsCompanion copyWith({
    Value<int>? rowId,
    Value<int>? account,
    Value<String>? name,
    Value<int>? thumbFaceId,
    Value<int>? count,
  }) {
    return FaceRecognitionPersonsCompanion(
      rowId: rowId ?? this.rowId,
      account: account ?? this.account,
      name: name ?? this.name,
      thumbFaceId: thumbFaceId ?? this.thumbFaceId,
      count: count ?? this.count,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (thumbFaceId.present) {
      map['thumb_face_id'] = Variable<int>(thumbFaceId.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FaceRecognitionPersonsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('account: $account, ')
          ..write('name: $name, ')
          ..write('thumbFaceId: $thumbFaceId, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }
}

class $NcAlbumsTable extends NcAlbums with TableInfo<$NcAlbumsTable, NcAlbum> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NcAlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountMeta = const VerificationMeta(
    'account',
  );
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
    'account',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPhotoMeta = const VerificationMeta(
    'lastPhoto',
  );
  @override
  late final GeneratedColumn<int> lastPhoto = GeneratedColumn<int>(
    'last_photo',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nbItemsMeta = const VerificationMeta(
    'nbItems',
  );
  @override
  late final GeneratedColumn<int> nbItems = GeneratedColumn<int>(
    'nb_items',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateStartMeta = const VerificationMeta(
    'dateStart',
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, DateTime> dateStart =
      GeneratedColumn<DateTime>(
        'date_start',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($NcAlbumsTable.$converterdateStartn);
  static const VerificationMeta _dateEndMeta = const VerificationMeta(
    'dateEnd',
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, DateTime> dateEnd =
      GeneratedColumn<DateTime>(
        'date_end',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($NcAlbumsTable.$converterdateEndn);
  static const VerificationMeta _collaboratorsMeta = const VerificationMeta(
    'collaborators',
  );
  @override
  late final GeneratedColumn<String> collaborators = GeneratedColumn<String>(
    'collaborators',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isOwnedMeta = const VerificationMeta(
    'isOwned',
  );
  @override
  late final GeneratedColumn<bool> isOwned = GeneratedColumn<bool>(
    'is_owned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_owned" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    account,
    relativePath,
    lastPhoto,
    nbItems,
    location,
    dateStart,
    dateEnd,
    collaborators,
    isOwned,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nc_albums';
  @override
  VerificationContext validateIntegrity(
    Insertable<NcAlbum> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('account')) {
      context.handle(
        _accountMeta,
        account.isAcceptableOrUnknown(data['account']!, _accountMeta),
      );
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('last_photo')) {
      context.handle(
        _lastPhotoMeta,
        lastPhoto.isAcceptableOrUnknown(data['last_photo']!, _lastPhotoMeta),
      );
    }
    if (data.containsKey('nb_items')) {
      context.handle(
        _nbItemsMeta,
        nbItems.isAcceptableOrUnknown(data['nb_items']!, _nbItemsMeta),
      );
    } else if (isInserting) {
      context.missing(_nbItemsMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    context.handle(_dateStartMeta, const VerificationResult.success());
    context.handle(_dateEndMeta, const VerificationResult.success());
    if (data.containsKey('collaborators')) {
      context.handle(
        _collaboratorsMeta,
        collaborators.isAcceptableOrUnknown(
          data['collaborators']!,
          _collaboratorsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collaboratorsMeta);
    }
    if (data.containsKey('is_owned')) {
      context.handle(
        _isOwnedMeta,
        isOwned.isAcceptableOrUnknown(data['is_owned']!, _isOwnedMeta),
      );
    } else if (isInserting) {
      context.missing(_isOwnedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {account, relativePath},
  ];
  @override
  NcAlbum map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NcAlbum(
      rowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}row_id'],
          )!,
      account:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}account'],
          )!,
      relativePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}relative_path'],
          )!,
      lastPhoto: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_photo'],
      ),
      nbItems:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}nb_items'],
          )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      dateStart: $NcAlbumsTable.$converterdateStartn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}date_start'],
        ),
      ),
      dateEnd: $NcAlbumsTable.$converterdateEndn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}date_end'],
        ),
      ),
      collaborators:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}collaborators'],
          )!,
      isOwned:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_owned'],
          )!,
    );
  }

  @override
  $NcAlbumsTable createAlias(String alias) {
    return $NcAlbumsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, DateTime> $converterdateStart =
      const SqliteDateTimeConverter();
  static TypeConverter<DateTime?, DateTime?> $converterdateStartn =
      NullAwareTypeConverter.wrap($converterdateStart);
  static TypeConverter<DateTime, DateTime> $converterdateEnd =
      const SqliteDateTimeConverter();
  static TypeConverter<DateTime?, DateTime?> $converterdateEndn =
      NullAwareTypeConverter.wrap($converterdateEnd);
}

class NcAlbum extends DataClass implements Insertable<NcAlbum> {
  final int rowId;
  final int account;
  final String relativePath;
  final int? lastPhoto;
  final int nbItems;
  final String? location;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final String collaborators;
  final bool isOwned;
  const NcAlbum({
    required this.rowId,
    required this.account,
    required this.relativePath,
    this.lastPhoto,
    required this.nbItems,
    this.location,
    this.dateStart,
    this.dateEnd,
    required this.collaborators,
    required this.isOwned,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['account'] = Variable<int>(account);
    map['relative_path'] = Variable<String>(relativePath);
    if (!nullToAbsent || lastPhoto != null) {
      map['last_photo'] = Variable<int>(lastPhoto);
    }
    map['nb_items'] = Variable<int>(nbItems);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || dateStart != null) {
      map['date_start'] = Variable<DateTime>(
        $NcAlbumsTable.$converterdateStartn.toSql(dateStart),
      );
    }
    if (!nullToAbsent || dateEnd != null) {
      map['date_end'] = Variable<DateTime>(
        $NcAlbumsTable.$converterdateEndn.toSql(dateEnd),
      );
    }
    map['collaborators'] = Variable<String>(collaborators);
    map['is_owned'] = Variable<bool>(isOwned);
    return map;
  }

  NcAlbumsCompanion toCompanion(bool nullToAbsent) {
    return NcAlbumsCompanion(
      rowId: Value(rowId),
      account: Value(account),
      relativePath: Value(relativePath),
      lastPhoto:
          lastPhoto == null && nullToAbsent
              ? const Value.absent()
              : Value(lastPhoto),
      nbItems: Value(nbItems),
      location:
          location == null && nullToAbsent
              ? const Value.absent()
              : Value(location),
      dateStart:
          dateStart == null && nullToAbsent
              ? const Value.absent()
              : Value(dateStart),
      dateEnd:
          dateEnd == null && nullToAbsent
              ? const Value.absent()
              : Value(dateEnd),
      collaborators: Value(collaborators),
      isOwned: Value(isOwned),
    );
  }

  factory NcAlbum.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NcAlbum(
      rowId: serializer.fromJson<int>(json['rowId']),
      account: serializer.fromJson<int>(json['account']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      lastPhoto: serializer.fromJson<int?>(json['lastPhoto']),
      nbItems: serializer.fromJson<int>(json['nbItems']),
      location: serializer.fromJson<String?>(json['location']),
      dateStart: serializer.fromJson<DateTime?>(json['dateStart']),
      dateEnd: serializer.fromJson<DateTime?>(json['dateEnd']),
      collaborators: serializer.fromJson<String>(json['collaborators']),
      isOwned: serializer.fromJson<bool>(json['isOwned']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'account': serializer.toJson<int>(account),
      'relativePath': serializer.toJson<String>(relativePath),
      'lastPhoto': serializer.toJson<int?>(lastPhoto),
      'nbItems': serializer.toJson<int>(nbItems),
      'location': serializer.toJson<String?>(location),
      'dateStart': serializer.toJson<DateTime?>(dateStart),
      'dateEnd': serializer.toJson<DateTime?>(dateEnd),
      'collaborators': serializer.toJson<String>(collaborators),
      'isOwned': serializer.toJson<bool>(isOwned),
    };
  }

  NcAlbum copyWith({
    int? rowId,
    int? account,
    String? relativePath,
    Value<int?> lastPhoto = const Value.absent(),
    int? nbItems,
    Value<String?> location = const Value.absent(),
    Value<DateTime?> dateStart = const Value.absent(),
    Value<DateTime?> dateEnd = const Value.absent(),
    String? collaborators,
    bool? isOwned,
  }) => NcAlbum(
    rowId: rowId ?? this.rowId,
    account: account ?? this.account,
    relativePath: relativePath ?? this.relativePath,
    lastPhoto: lastPhoto.present ? lastPhoto.value : this.lastPhoto,
    nbItems: nbItems ?? this.nbItems,
    location: location.present ? location.value : this.location,
    dateStart: dateStart.present ? dateStart.value : this.dateStart,
    dateEnd: dateEnd.present ? dateEnd.value : this.dateEnd,
    collaborators: collaborators ?? this.collaborators,
    isOwned: isOwned ?? this.isOwned,
  );
  NcAlbum copyWithCompanion(NcAlbumsCompanion data) {
    return NcAlbum(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      account: data.account.present ? data.account.value : this.account,
      relativePath:
          data.relativePath.present
              ? data.relativePath.value
              : this.relativePath,
      lastPhoto: data.lastPhoto.present ? data.lastPhoto.value : this.lastPhoto,
      nbItems: data.nbItems.present ? data.nbItems.value : this.nbItems,
      location: data.location.present ? data.location.value : this.location,
      dateStart: data.dateStart.present ? data.dateStart.value : this.dateStart,
      dateEnd: data.dateEnd.present ? data.dateEnd.value : this.dateEnd,
      collaborators:
          data.collaborators.present
              ? data.collaborators.value
              : this.collaborators,
      isOwned: data.isOwned.present ? data.isOwned.value : this.isOwned,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NcAlbum(')
          ..write('rowId: $rowId, ')
          ..write('account: $account, ')
          ..write('relativePath: $relativePath, ')
          ..write('lastPhoto: $lastPhoto, ')
          ..write('nbItems: $nbItems, ')
          ..write('location: $location, ')
          ..write('dateStart: $dateStart, ')
          ..write('dateEnd: $dateEnd, ')
          ..write('collaborators: $collaborators, ')
          ..write('isOwned: $isOwned')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    account,
    relativePath,
    lastPhoto,
    nbItems,
    location,
    dateStart,
    dateEnd,
    collaborators,
    isOwned,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NcAlbum &&
          other.rowId == this.rowId &&
          other.account == this.account &&
          other.relativePath == this.relativePath &&
          other.lastPhoto == this.lastPhoto &&
          other.nbItems == this.nbItems &&
          other.location == this.location &&
          other.dateStart == this.dateStart &&
          other.dateEnd == this.dateEnd &&
          other.collaborators == this.collaborators &&
          other.isOwned == this.isOwned);
}

class NcAlbumsCompanion extends UpdateCompanion<NcAlbum> {
  final Value<int> rowId;
  final Value<int> account;
  final Value<String> relativePath;
  final Value<int?> lastPhoto;
  final Value<int> nbItems;
  final Value<String?> location;
  final Value<DateTime?> dateStart;
  final Value<DateTime?> dateEnd;
  final Value<String> collaborators;
  final Value<bool> isOwned;
  const NcAlbumsCompanion({
    this.rowId = const Value.absent(),
    this.account = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.lastPhoto = const Value.absent(),
    this.nbItems = const Value.absent(),
    this.location = const Value.absent(),
    this.dateStart = const Value.absent(),
    this.dateEnd = const Value.absent(),
    this.collaborators = const Value.absent(),
    this.isOwned = const Value.absent(),
  });
  NcAlbumsCompanion.insert({
    this.rowId = const Value.absent(),
    required int account,
    required String relativePath,
    this.lastPhoto = const Value.absent(),
    required int nbItems,
    this.location = const Value.absent(),
    this.dateStart = const Value.absent(),
    this.dateEnd = const Value.absent(),
    required String collaborators,
    required bool isOwned,
  }) : account = Value(account),
       relativePath = Value(relativePath),
       nbItems = Value(nbItems),
       collaborators = Value(collaborators),
       isOwned = Value(isOwned);
  static Insertable<NcAlbum> custom({
    Expression<int>? rowId,
    Expression<int>? account,
    Expression<String>? relativePath,
    Expression<int>? lastPhoto,
    Expression<int>? nbItems,
    Expression<String>? location,
    Expression<DateTime>? dateStart,
    Expression<DateTime>? dateEnd,
    Expression<String>? collaborators,
    Expression<bool>? isOwned,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (account != null) 'account': account,
      if (relativePath != null) 'relative_path': relativePath,
      if (lastPhoto != null) 'last_photo': lastPhoto,
      if (nbItems != null) 'nb_items': nbItems,
      if (location != null) 'location': location,
      if (dateStart != null) 'date_start': dateStart,
      if (dateEnd != null) 'date_end': dateEnd,
      if (collaborators != null) 'collaborators': collaborators,
      if (isOwned != null) 'is_owned': isOwned,
    });
  }

  NcAlbumsCompanion copyWith({
    Value<int>? rowId,
    Value<int>? account,
    Value<String>? relativePath,
    Value<int?>? lastPhoto,
    Value<int>? nbItems,
    Value<String?>? location,
    Value<DateTime?>? dateStart,
    Value<DateTime?>? dateEnd,
    Value<String>? collaborators,
    Value<bool>? isOwned,
  }) {
    return NcAlbumsCompanion(
      rowId: rowId ?? this.rowId,
      account: account ?? this.account,
      relativePath: relativePath ?? this.relativePath,
      lastPhoto: lastPhoto ?? this.lastPhoto,
      nbItems: nbItems ?? this.nbItems,
      location: location ?? this.location,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      collaborators: collaborators ?? this.collaborators,
      isOwned: isOwned ?? this.isOwned,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (lastPhoto.present) {
      map['last_photo'] = Variable<int>(lastPhoto.value);
    }
    if (nbItems.present) {
      map['nb_items'] = Variable<int>(nbItems.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (dateStart.present) {
      map['date_start'] = Variable<DateTime>(
        $NcAlbumsTable.$converterdateStartn.toSql(dateStart.value),
      );
    }
    if (dateEnd.present) {
      map['date_end'] = Variable<DateTime>(
        $NcAlbumsTable.$converterdateEndn.toSql(dateEnd.value),
      );
    }
    if (collaborators.present) {
      map['collaborators'] = Variable<String>(collaborators.value);
    }
    if (isOwned.present) {
      map['is_owned'] = Variable<bool>(isOwned.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NcAlbumsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('account: $account, ')
          ..write('relativePath: $relativePath, ')
          ..write('lastPhoto: $lastPhoto, ')
          ..write('nbItems: $nbItems, ')
          ..write('location: $location, ')
          ..write('dateStart: $dateStart, ')
          ..write('dateEnd: $dateEnd, ')
          ..write('collaborators: $collaborators, ')
          ..write('isOwned: $isOwned')
          ..write(')'))
        .toString();
  }
}

class $NcAlbumItemsTable extends NcAlbumItems
    with TableInfo<$NcAlbumItemsTable, NcAlbumItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NcAlbumItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _parentMeta = const VerificationMeta('parent');
  @override
  late final GeneratedColumn<int> parent = GeneratedColumn<int>(
    'parent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES nc_albums (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<int> fileId = GeneratedColumn<int>(
    'file_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentLengthMeta = const VerificationMeta(
    'contentLength',
  );
  @override
  late final GeneratedColumn<int> contentLength = GeneratedColumn<int>(
    'content_length',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, DateTime>
  lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  ).withConverter<DateTime?>($NcAlbumItemsTable.$converterlastModifiedn);
  static const VerificationMeta _hasPreviewMeta = const VerificationMeta(
    'hasPreview',
  );
  @override
  late final GeneratedColumn<bool> hasPreview = GeneratedColumn<bool>(
    'has_preview',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_preview" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
  );
  static const VerificationMeta _fileMetadataWidthMeta = const VerificationMeta(
    'fileMetadataWidth',
  );
  @override
  late final GeneratedColumn<int> fileMetadataWidth = GeneratedColumn<int>(
    'file_metadata_width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileMetadataHeightMeta =
      const VerificationMeta('fileMetadataHeight');
  @override
  late final GeneratedColumn<int> fileMetadataHeight = GeneratedColumn<int>(
    'file_metadata_height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    parent,
    relativePath,
    fileId,
    contentLength,
    contentType,
    etag,
    lastModified,
    hasPreview,
    isFavorite,
    fileMetadataWidth,
    fileMetadataHeight,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nc_album_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<NcAlbumItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('parent')) {
      context.handle(
        _parentMeta,
        parent.isAcceptableOrUnknown(data['parent']!, _parentMeta),
      );
    } else if (isInserting) {
      context.missing(_parentMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fileIdMeta);
    }
    if (data.containsKey('content_length')) {
      context.handle(
        _contentLengthMeta,
        contentLength.isAcceptableOrUnknown(
          data['content_length']!,
          _contentLengthMeta,
        ),
      );
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    context.handle(_lastModifiedMeta, const VerificationResult.success());
    if (data.containsKey('has_preview')) {
      context.handle(
        _hasPreviewMeta,
        hasPreview.isAcceptableOrUnknown(data['has_preview']!, _hasPreviewMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('file_metadata_width')) {
      context.handle(
        _fileMetadataWidthMeta,
        fileMetadataWidth.isAcceptableOrUnknown(
          data['file_metadata_width']!,
          _fileMetadataWidthMeta,
        ),
      );
    }
    if (data.containsKey('file_metadata_height')) {
      context.handle(
        _fileMetadataHeightMeta,
        fileMetadataHeight.isAcceptableOrUnknown(
          data['file_metadata_height']!,
          _fileMetadataHeightMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {parent, fileId},
  ];
  @override
  NcAlbumItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NcAlbumItem(
      rowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}row_id'],
          )!,
      parent:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}parent'],
          )!,
      relativePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}relative_path'],
          )!,
      fileId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}file_id'],
          )!,
      contentLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_length'],
      ),
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      ),
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      lastModified: $NcAlbumItemsTable.$converterlastModifiedn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_modified'],
        ),
      ),
      hasPreview: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_preview'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      ),
      fileMetadataWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_metadata_width'],
      ),
      fileMetadataHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_metadata_height'],
      ),
    );
  }

  @override
  $NcAlbumItemsTable createAlias(String alias) {
    return $NcAlbumItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, DateTime> $converterlastModified =
      const SqliteDateTimeConverter();
  static TypeConverter<DateTime?, DateTime?> $converterlastModifiedn =
      NullAwareTypeConverter.wrap($converterlastModified);
}

class NcAlbumItem extends DataClass implements Insertable<NcAlbumItem> {
  final int rowId;
  final int parent;
  final String relativePath;
  final int fileId;
  final int? contentLength;
  final String? contentType;
  final String? etag;
  final DateTime? lastModified;
  final bool? hasPreview;
  final bool? isFavorite;
  final int? fileMetadataWidth;
  final int? fileMetadataHeight;
  const NcAlbumItem({
    required this.rowId,
    required this.parent,
    required this.relativePath,
    required this.fileId,
    this.contentLength,
    this.contentType,
    this.etag,
    this.lastModified,
    this.hasPreview,
    this.isFavorite,
    this.fileMetadataWidth,
    this.fileMetadataHeight,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['parent'] = Variable<int>(parent);
    map['relative_path'] = Variable<String>(relativePath);
    map['file_id'] = Variable<int>(fileId);
    if (!nullToAbsent || contentLength != null) {
      map['content_length'] = Variable<int>(contentLength);
    }
    if (!nullToAbsent || contentType != null) {
      map['content_type'] = Variable<String>(contentType);
    }
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    if (!nullToAbsent || lastModified != null) {
      map['last_modified'] = Variable<DateTime>(
        $NcAlbumItemsTable.$converterlastModifiedn.toSql(lastModified),
      );
    }
    if (!nullToAbsent || hasPreview != null) {
      map['has_preview'] = Variable<bool>(hasPreview);
    }
    if (!nullToAbsent || isFavorite != null) {
      map['is_favorite'] = Variable<bool>(isFavorite);
    }
    if (!nullToAbsent || fileMetadataWidth != null) {
      map['file_metadata_width'] = Variable<int>(fileMetadataWidth);
    }
    if (!nullToAbsent || fileMetadataHeight != null) {
      map['file_metadata_height'] = Variable<int>(fileMetadataHeight);
    }
    return map;
  }

  NcAlbumItemsCompanion toCompanion(bool nullToAbsent) {
    return NcAlbumItemsCompanion(
      rowId: Value(rowId),
      parent: Value(parent),
      relativePath: Value(relativePath),
      fileId: Value(fileId),
      contentLength:
          contentLength == null && nullToAbsent
              ? const Value.absent()
              : Value(contentLength),
      contentType:
          contentType == null && nullToAbsent
              ? const Value.absent()
              : Value(contentType),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      lastModified:
          lastModified == null && nullToAbsent
              ? const Value.absent()
              : Value(lastModified),
      hasPreview:
          hasPreview == null && nullToAbsent
              ? const Value.absent()
              : Value(hasPreview),
      isFavorite:
          isFavorite == null && nullToAbsent
              ? const Value.absent()
              : Value(isFavorite),
      fileMetadataWidth:
          fileMetadataWidth == null && nullToAbsent
              ? const Value.absent()
              : Value(fileMetadataWidth),
      fileMetadataHeight:
          fileMetadataHeight == null && nullToAbsent
              ? const Value.absent()
              : Value(fileMetadataHeight),
    );
  }

  factory NcAlbumItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NcAlbumItem(
      rowId: serializer.fromJson<int>(json['rowId']),
      parent: serializer.fromJson<int>(json['parent']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      fileId: serializer.fromJson<int>(json['fileId']),
      contentLength: serializer.fromJson<int?>(json['contentLength']),
      contentType: serializer.fromJson<String?>(json['contentType']),
      etag: serializer.fromJson<String?>(json['etag']),
      lastModified: serializer.fromJson<DateTime?>(json['lastModified']),
      hasPreview: serializer.fromJson<bool?>(json['hasPreview']),
      isFavorite: serializer.fromJson<bool?>(json['isFavorite']),
      fileMetadataWidth: serializer.fromJson<int?>(json['fileMetadataWidth']),
      fileMetadataHeight: serializer.fromJson<int?>(json['fileMetadataHeight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'parent': serializer.toJson<int>(parent),
      'relativePath': serializer.toJson<String>(relativePath),
      'fileId': serializer.toJson<int>(fileId),
      'contentLength': serializer.toJson<int?>(contentLength),
      'contentType': serializer.toJson<String?>(contentType),
      'etag': serializer.toJson<String?>(etag),
      'lastModified': serializer.toJson<DateTime?>(lastModified),
      'hasPreview': serializer.toJson<bool?>(hasPreview),
      'isFavorite': serializer.toJson<bool?>(isFavorite),
      'fileMetadataWidth': serializer.toJson<int?>(fileMetadataWidth),
      'fileMetadataHeight': serializer.toJson<int?>(fileMetadataHeight),
    };
  }

  NcAlbumItem copyWith({
    int? rowId,
    int? parent,
    String? relativePath,
    int? fileId,
    Value<int?> contentLength = const Value.absent(),
    Value<String?> contentType = const Value.absent(),
    Value<String?> etag = const Value.absent(),
    Value<DateTime?> lastModified = const Value.absent(),
    Value<bool?> hasPreview = const Value.absent(),
    Value<bool?> isFavorite = const Value.absent(),
    Value<int?> fileMetadataWidth = const Value.absent(),
    Value<int?> fileMetadataHeight = const Value.absent(),
  }) => NcAlbumItem(
    rowId: rowId ?? this.rowId,
    parent: parent ?? this.parent,
    relativePath: relativePath ?? this.relativePath,
    fileId: fileId ?? this.fileId,
    contentLength:
        contentLength.present ? contentLength.value : this.contentLength,
    contentType: contentType.present ? contentType.value : this.contentType,
    etag: etag.present ? etag.value : this.etag,
    lastModified: lastModified.present ? lastModified.value : this.lastModified,
    hasPreview: hasPreview.present ? hasPreview.value : this.hasPreview,
    isFavorite: isFavorite.present ? isFavorite.value : this.isFavorite,
    fileMetadataWidth:
        fileMetadataWidth.present
            ? fileMetadataWidth.value
            : this.fileMetadataWidth,
    fileMetadataHeight:
        fileMetadataHeight.present
            ? fileMetadataHeight.value
            : this.fileMetadataHeight,
  );
  NcAlbumItem copyWithCompanion(NcAlbumItemsCompanion data) {
    return NcAlbumItem(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      parent: data.parent.present ? data.parent.value : this.parent,
      relativePath:
          data.relativePath.present
              ? data.relativePath.value
              : this.relativePath,
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      contentLength:
          data.contentLength.present
              ? data.contentLength.value
              : this.contentLength,
      contentType:
          data.contentType.present ? data.contentType.value : this.contentType,
      etag: data.etag.present ? data.etag.value : this.etag,
      lastModified:
          data.lastModified.present
              ? data.lastModified.value
              : this.lastModified,
      hasPreview:
          data.hasPreview.present ? data.hasPreview.value : this.hasPreview,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      fileMetadataWidth:
          data.fileMetadataWidth.present
              ? data.fileMetadataWidth.value
              : this.fileMetadataWidth,
      fileMetadataHeight:
          data.fileMetadataHeight.present
              ? data.fileMetadataHeight.value
              : this.fileMetadataHeight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NcAlbumItem(')
          ..write('rowId: $rowId, ')
          ..write('parent: $parent, ')
          ..write('relativePath: $relativePath, ')
          ..write('fileId: $fileId, ')
          ..write('contentLength: $contentLength, ')
          ..write('contentType: $contentType, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('hasPreview: $hasPreview, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('fileMetadataWidth: $fileMetadataWidth, ')
          ..write('fileMetadataHeight: $fileMetadataHeight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    parent,
    relativePath,
    fileId,
    contentLength,
    contentType,
    etag,
    lastModified,
    hasPreview,
    isFavorite,
    fileMetadataWidth,
    fileMetadataHeight,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NcAlbumItem &&
          other.rowId == this.rowId &&
          other.parent == this.parent &&
          other.relativePath == this.relativePath &&
          other.fileId == this.fileId &&
          other.contentLength == this.contentLength &&
          other.contentType == this.contentType &&
          other.etag == this.etag &&
          other.lastModified == this.lastModified &&
          other.hasPreview == this.hasPreview &&
          other.isFavorite == this.isFavorite &&
          other.fileMetadataWidth == this.fileMetadataWidth &&
          other.fileMetadataHeight == this.fileMetadataHeight);
}

class NcAlbumItemsCompanion extends UpdateCompanion<NcAlbumItem> {
  final Value<int> rowId;
  final Value<int> parent;
  final Value<String> relativePath;
  final Value<int> fileId;
  final Value<int?> contentLength;
  final Value<String?> contentType;
  final Value<String?> etag;
  final Value<DateTime?> lastModified;
  final Value<bool?> hasPreview;
  final Value<bool?> isFavorite;
  final Value<int?> fileMetadataWidth;
  final Value<int?> fileMetadataHeight;
  const NcAlbumItemsCompanion({
    this.rowId = const Value.absent(),
    this.parent = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.fileId = const Value.absent(),
    this.contentLength = const Value.absent(),
    this.contentType = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.hasPreview = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.fileMetadataWidth = const Value.absent(),
    this.fileMetadataHeight = const Value.absent(),
  });
  NcAlbumItemsCompanion.insert({
    this.rowId = const Value.absent(),
    required int parent,
    required String relativePath,
    required int fileId,
    this.contentLength = const Value.absent(),
    this.contentType = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.hasPreview = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.fileMetadataWidth = const Value.absent(),
    this.fileMetadataHeight = const Value.absent(),
  }) : parent = Value(parent),
       relativePath = Value(relativePath),
       fileId = Value(fileId);
  static Insertable<NcAlbumItem> custom({
    Expression<int>? rowId,
    Expression<int>? parent,
    Expression<String>? relativePath,
    Expression<int>? fileId,
    Expression<int>? contentLength,
    Expression<String>? contentType,
    Expression<String>? etag,
    Expression<DateTime>? lastModified,
    Expression<bool>? hasPreview,
    Expression<bool>? isFavorite,
    Expression<int>? fileMetadataWidth,
    Expression<int>? fileMetadataHeight,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (parent != null) 'parent': parent,
      if (relativePath != null) 'relative_path': relativePath,
      if (fileId != null) 'file_id': fileId,
      if (contentLength != null) 'content_length': contentLength,
      if (contentType != null) 'content_type': contentType,
      if (etag != null) 'etag': etag,
      if (lastModified != null) 'last_modified': lastModified,
      if (hasPreview != null) 'has_preview': hasPreview,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (fileMetadataWidth != null) 'file_metadata_width': fileMetadataWidth,
      if (fileMetadataHeight != null)
        'file_metadata_height': fileMetadataHeight,
    });
  }

  NcAlbumItemsCompanion copyWith({
    Value<int>? rowId,
    Value<int>? parent,
    Value<String>? relativePath,
    Value<int>? fileId,
    Value<int?>? contentLength,
    Value<String?>? contentType,
    Value<String?>? etag,
    Value<DateTime?>? lastModified,
    Value<bool?>? hasPreview,
    Value<bool?>? isFavorite,
    Value<int?>? fileMetadataWidth,
    Value<int?>? fileMetadataHeight,
  }) {
    return NcAlbumItemsCompanion(
      rowId: rowId ?? this.rowId,
      parent: parent ?? this.parent,
      relativePath: relativePath ?? this.relativePath,
      fileId: fileId ?? this.fileId,
      contentLength: contentLength ?? this.contentLength,
      contentType: contentType ?? this.contentType,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      hasPreview: hasPreview ?? this.hasPreview,
      isFavorite: isFavorite ?? this.isFavorite,
      fileMetadataWidth: fileMetadataWidth ?? this.fileMetadataWidth,
      fileMetadataHeight: fileMetadataHeight ?? this.fileMetadataHeight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (parent.present) {
      map['parent'] = Variable<int>(parent.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (fileId.present) {
      map['file_id'] = Variable<int>(fileId.value);
    }
    if (contentLength.present) {
      map['content_length'] = Variable<int>(contentLength.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(
        $NcAlbumItemsTable.$converterlastModifiedn.toSql(lastModified.value),
      );
    }
    if (hasPreview.present) {
      map['has_preview'] = Variable<bool>(hasPreview.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (fileMetadataWidth.present) {
      map['file_metadata_width'] = Variable<int>(fileMetadataWidth.value);
    }
    if (fileMetadataHeight.present) {
      map['file_metadata_height'] = Variable<int>(fileMetadataHeight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NcAlbumItemsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('parent: $parent, ')
          ..write('relativePath: $relativePath, ')
          ..write('fileId: $fileId, ')
          ..write('contentLength: $contentLength, ')
          ..write('contentType: $contentType, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('hasPreview: $hasPreview, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('fileMetadataWidth: $fileMetadataWidth, ')
          ..write('fileMetadataHeight: $fileMetadataHeight')
          ..write(')'))
        .toString();
  }
}

class $RecognizeFacesTable extends RecognizeFaces
    with TableInfo<$RecognizeFacesTable, RecognizeFace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecognizeFacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountMeta = const VerificationMeta(
    'account',
  );
  @override
  late final GeneratedColumn<int> account = GeneratedColumn<int>(
    'account',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [rowId, account, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recognize_faces';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecognizeFace> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('account')) {
      context.handle(
        _accountMeta,
        account.isAcceptableOrUnknown(data['account']!, _accountMeta),
      );
    } else if (isInserting) {
      context.missing(_accountMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {account, label},
  ];
  @override
  RecognizeFace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecognizeFace(
      rowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}row_id'],
          )!,
      account:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}account'],
          )!,
      label:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}label'],
          )!,
    );
  }

  @override
  $RecognizeFacesTable createAlias(String alias) {
    return $RecognizeFacesTable(attachedDatabase, alias);
  }
}

class RecognizeFace extends DataClass implements Insertable<RecognizeFace> {
  final int rowId;
  final int account;
  final String label;
  const RecognizeFace({
    required this.rowId,
    required this.account,
    required this.label,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['account'] = Variable<int>(account);
    map['label'] = Variable<String>(label);
    return map;
  }

  RecognizeFacesCompanion toCompanion(bool nullToAbsent) {
    return RecognizeFacesCompanion(
      rowId: Value(rowId),
      account: Value(account),
      label: Value(label),
    );
  }

  factory RecognizeFace.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecognizeFace(
      rowId: serializer.fromJson<int>(json['rowId']),
      account: serializer.fromJson<int>(json['account']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'account': serializer.toJson<int>(account),
      'label': serializer.toJson<String>(label),
    };
  }

  RecognizeFace copyWith({int? rowId, int? account, String? label}) =>
      RecognizeFace(
        rowId: rowId ?? this.rowId,
        account: account ?? this.account,
        label: label ?? this.label,
      );
  RecognizeFace copyWithCompanion(RecognizeFacesCompanion data) {
    return RecognizeFace(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      account: data.account.present ? data.account.value : this.account,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecognizeFace(')
          ..write('rowId: $rowId, ')
          ..write('account: $account, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(rowId, account, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecognizeFace &&
          other.rowId == this.rowId &&
          other.account == this.account &&
          other.label == this.label);
}

class RecognizeFacesCompanion extends UpdateCompanion<RecognizeFace> {
  final Value<int> rowId;
  final Value<int> account;
  final Value<String> label;
  const RecognizeFacesCompanion({
    this.rowId = const Value.absent(),
    this.account = const Value.absent(),
    this.label = const Value.absent(),
  });
  RecognizeFacesCompanion.insert({
    this.rowId = const Value.absent(),
    required int account,
    required String label,
  }) : account = Value(account),
       label = Value(label);
  static Insertable<RecognizeFace> custom({
    Expression<int>? rowId,
    Expression<int>? account,
    Expression<String>? label,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (account != null) 'account': account,
      if (label != null) 'label': label,
    });
  }

  RecognizeFacesCompanion copyWith({
    Value<int>? rowId,
    Value<int>? account,
    Value<String>? label,
  }) {
    return RecognizeFacesCompanion(
      rowId: rowId ?? this.rowId,
      account: account ?? this.account,
      label: label ?? this.label,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (account.present) {
      map['account'] = Variable<int>(account.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecognizeFacesCompanion(')
          ..write('rowId: $rowId, ')
          ..write('account: $account, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }
}

class $RecognizeFaceItemsTable extends RecognizeFaceItems
    with TableInfo<$RecognizeFaceItemsTable, RecognizeFaceItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecognizeFaceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<int> rowId = GeneratedColumn<int>(
    'row_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _parentMeta = const VerificationMeta('parent');
  @override
  late final GeneratedColumn<int> parent = GeneratedColumn<int>(
    'parent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recognize_faces (row_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _relativePathMeta = const VerificationMeta(
    'relativePath',
  );
  @override
  late final GeneratedColumn<String> relativePath = GeneratedColumn<String>(
    'relative_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileIdMeta = const VerificationMeta('fileId');
  @override
  late final GeneratedColumn<int> fileId = GeneratedColumn<int>(
    'file_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentLengthMeta = const VerificationMeta(
    'contentLength',
  );
  @override
  late final GeneratedColumn<int> contentLength = GeneratedColumn<int>(
    'content_length',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, DateTime>
  lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  ).withConverter<DateTime?>($RecognizeFaceItemsTable.$converterlastModifiedn);
  static const VerificationMeta _hasPreviewMeta = const VerificationMeta(
    'hasPreview',
  );
  @override
  late final GeneratedColumn<bool> hasPreview = GeneratedColumn<bool>(
    'has_preview',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_preview" IN (0, 1))',
    ),
  );
  static const VerificationMeta _realPathMeta = const VerificationMeta(
    'realPath',
  );
  @override
  late final GeneratedColumn<String> realPath = GeneratedColumn<String>(
    'real_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
  );
  static const VerificationMeta _fileMetadataWidthMeta = const VerificationMeta(
    'fileMetadataWidth',
  );
  @override
  late final GeneratedColumn<int> fileMetadataWidth = GeneratedColumn<int>(
    'file_metadata_width',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileMetadataHeightMeta =
      const VerificationMeta('fileMetadataHeight');
  @override
  late final GeneratedColumn<int> fileMetadataHeight = GeneratedColumn<int>(
    'file_metadata_height',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _faceDetectionsMeta = const VerificationMeta(
    'faceDetections',
  );
  @override
  late final GeneratedColumn<String> faceDetections = GeneratedColumn<String>(
    'face_detections',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    rowId,
    parent,
    relativePath,
    fileId,
    contentLength,
    contentType,
    etag,
    lastModified,
    hasPreview,
    realPath,
    isFavorite,
    fileMetadataWidth,
    fileMetadataHeight,
    faceDetections,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recognize_face_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecognizeFaceItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    }
    if (data.containsKey('parent')) {
      context.handle(
        _parentMeta,
        parent.isAcceptableOrUnknown(data['parent']!, _parentMeta),
      );
    } else if (isInserting) {
      context.missing(_parentMeta);
    }
    if (data.containsKey('relative_path')) {
      context.handle(
        _relativePathMeta,
        relativePath.isAcceptableOrUnknown(
          data['relative_path']!,
          _relativePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_relativePathMeta);
    }
    if (data.containsKey('file_id')) {
      context.handle(
        _fileIdMeta,
        fileId.isAcceptableOrUnknown(data['file_id']!, _fileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fileIdMeta);
    }
    if (data.containsKey('content_length')) {
      context.handle(
        _contentLengthMeta,
        contentLength.isAcceptableOrUnknown(
          data['content_length']!,
          _contentLengthMeta,
        ),
      );
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    context.handle(_lastModifiedMeta, const VerificationResult.success());
    if (data.containsKey('has_preview')) {
      context.handle(
        _hasPreviewMeta,
        hasPreview.isAcceptableOrUnknown(data['has_preview']!, _hasPreviewMeta),
      );
    }
    if (data.containsKey('real_path')) {
      context.handle(
        _realPathMeta,
        realPath.isAcceptableOrUnknown(data['real_path']!, _realPathMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('file_metadata_width')) {
      context.handle(
        _fileMetadataWidthMeta,
        fileMetadataWidth.isAcceptableOrUnknown(
          data['file_metadata_width']!,
          _fileMetadataWidthMeta,
        ),
      );
    }
    if (data.containsKey('file_metadata_height')) {
      context.handle(
        _fileMetadataHeightMeta,
        fileMetadataHeight.isAcceptableOrUnknown(
          data['file_metadata_height']!,
          _fileMetadataHeightMeta,
        ),
      );
    }
    if (data.containsKey('face_detections')) {
      context.handle(
        _faceDetectionsMeta,
        faceDetections.isAcceptableOrUnknown(
          data['face_detections']!,
          _faceDetectionsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rowId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {parent, fileId},
  ];
  @override
  RecognizeFaceItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecognizeFaceItem(
      rowId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}row_id'],
          )!,
      parent:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}parent'],
          )!,
      relativePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}relative_path'],
          )!,
      fileId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}file_id'],
          )!,
      contentLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_length'],
      ),
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      ),
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      lastModified: $RecognizeFaceItemsTable.$converterlastModifiedn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_modified'],
        ),
      ),
      hasPreview: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_preview'],
      ),
      realPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}real_path'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      ),
      fileMetadataWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_metadata_width'],
      ),
      fileMetadataHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_metadata_height'],
      ),
      faceDetections: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}face_detections'],
      ),
    );
  }

  @override
  $RecognizeFaceItemsTable createAlias(String alias) {
    return $RecognizeFaceItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, DateTime> $converterlastModified =
      const SqliteDateTimeConverter();
  static TypeConverter<DateTime?, DateTime?> $converterlastModifiedn =
      NullAwareTypeConverter.wrap($converterlastModified);
}

class RecognizeFaceItem extends DataClass
    implements Insertable<RecognizeFaceItem> {
  final int rowId;
  final int parent;
  final String relativePath;
  final int fileId;
  final int? contentLength;
  final String? contentType;
  final String? etag;
  final DateTime? lastModified;
  final bool? hasPreview;
  final String? realPath;
  final bool? isFavorite;
  final int? fileMetadataWidth;
  final int? fileMetadataHeight;
  final String? faceDetections;
  const RecognizeFaceItem({
    required this.rowId,
    required this.parent,
    required this.relativePath,
    required this.fileId,
    this.contentLength,
    this.contentType,
    this.etag,
    this.lastModified,
    this.hasPreview,
    this.realPath,
    this.isFavorite,
    this.fileMetadataWidth,
    this.fileMetadataHeight,
    this.faceDetections,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['row_id'] = Variable<int>(rowId);
    map['parent'] = Variable<int>(parent);
    map['relative_path'] = Variable<String>(relativePath);
    map['file_id'] = Variable<int>(fileId);
    if (!nullToAbsent || contentLength != null) {
      map['content_length'] = Variable<int>(contentLength);
    }
    if (!nullToAbsent || contentType != null) {
      map['content_type'] = Variable<String>(contentType);
    }
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    if (!nullToAbsent || lastModified != null) {
      map['last_modified'] = Variable<DateTime>(
        $RecognizeFaceItemsTable.$converterlastModifiedn.toSql(lastModified),
      );
    }
    if (!nullToAbsent || hasPreview != null) {
      map['has_preview'] = Variable<bool>(hasPreview);
    }
    if (!nullToAbsent || realPath != null) {
      map['real_path'] = Variable<String>(realPath);
    }
    if (!nullToAbsent || isFavorite != null) {
      map['is_favorite'] = Variable<bool>(isFavorite);
    }
    if (!nullToAbsent || fileMetadataWidth != null) {
      map['file_metadata_width'] = Variable<int>(fileMetadataWidth);
    }
    if (!nullToAbsent || fileMetadataHeight != null) {
      map['file_metadata_height'] = Variable<int>(fileMetadataHeight);
    }
    if (!nullToAbsent || faceDetections != null) {
      map['face_detections'] = Variable<String>(faceDetections);
    }
    return map;
  }

  RecognizeFaceItemsCompanion toCompanion(bool nullToAbsent) {
    return RecognizeFaceItemsCompanion(
      rowId: Value(rowId),
      parent: Value(parent),
      relativePath: Value(relativePath),
      fileId: Value(fileId),
      contentLength:
          contentLength == null && nullToAbsent
              ? const Value.absent()
              : Value(contentLength),
      contentType:
          contentType == null && nullToAbsent
              ? const Value.absent()
              : Value(contentType),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      lastModified:
          lastModified == null && nullToAbsent
              ? const Value.absent()
              : Value(lastModified),
      hasPreview:
          hasPreview == null && nullToAbsent
              ? const Value.absent()
              : Value(hasPreview),
      realPath:
          realPath == null && nullToAbsent
              ? const Value.absent()
              : Value(realPath),
      isFavorite:
          isFavorite == null && nullToAbsent
              ? const Value.absent()
              : Value(isFavorite),
      fileMetadataWidth:
          fileMetadataWidth == null && nullToAbsent
              ? const Value.absent()
              : Value(fileMetadataWidth),
      fileMetadataHeight:
          fileMetadataHeight == null && nullToAbsent
              ? const Value.absent()
              : Value(fileMetadataHeight),
      faceDetections:
          faceDetections == null && nullToAbsent
              ? const Value.absent()
              : Value(faceDetections),
    );
  }

  factory RecognizeFaceItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecognizeFaceItem(
      rowId: serializer.fromJson<int>(json['rowId']),
      parent: serializer.fromJson<int>(json['parent']),
      relativePath: serializer.fromJson<String>(json['relativePath']),
      fileId: serializer.fromJson<int>(json['fileId']),
      contentLength: serializer.fromJson<int?>(json['contentLength']),
      contentType: serializer.fromJson<String?>(json['contentType']),
      etag: serializer.fromJson<String?>(json['etag']),
      lastModified: serializer.fromJson<DateTime?>(json['lastModified']),
      hasPreview: serializer.fromJson<bool?>(json['hasPreview']),
      realPath: serializer.fromJson<String?>(json['realPath']),
      isFavorite: serializer.fromJson<bool?>(json['isFavorite']),
      fileMetadataWidth: serializer.fromJson<int?>(json['fileMetadataWidth']),
      fileMetadataHeight: serializer.fromJson<int?>(json['fileMetadataHeight']),
      faceDetections: serializer.fromJson<String?>(json['faceDetections']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'rowId': serializer.toJson<int>(rowId),
      'parent': serializer.toJson<int>(parent),
      'relativePath': serializer.toJson<String>(relativePath),
      'fileId': serializer.toJson<int>(fileId),
      'contentLength': serializer.toJson<int?>(contentLength),
      'contentType': serializer.toJson<String?>(contentType),
      'etag': serializer.toJson<String?>(etag),
      'lastModified': serializer.toJson<DateTime?>(lastModified),
      'hasPreview': serializer.toJson<bool?>(hasPreview),
      'realPath': serializer.toJson<String?>(realPath),
      'isFavorite': serializer.toJson<bool?>(isFavorite),
      'fileMetadataWidth': serializer.toJson<int?>(fileMetadataWidth),
      'fileMetadataHeight': serializer.toJson<int?>(fileMetadataHeight),
      'faceDetections': serializer.toJson<String?>(faceDetections),
    };
  }

  RecognizeFaceItem copyWith({
    int? rowId,
    int? parent,
    String? relativePath,
    int? fileId,
    Value<int?> contentLength = const Value.absent(),
    Value<String?> contentType = const Value.absent(),
    Value<String?> etag = const Value.absent(),
    Value<DateTime?> lastModified = const Value.absent(),
    Value<bool?> hasPreview = const Value.absent(),
    Value<String?> realPath = const Value.absent(),
    Value<bool?> isFavorite = const Value.absent(),
    Value<int?> fileMetadataWidth = const Value.absent(),
    Value<int?> fileMetadataHeight = const Value.absent(),
    Value<String?> faceDetections = const Value.absent(),
  }) => RecognizeFaceItem(
    rowId: rowId ?? this.rowId,
    parent: parent ?? this.parent,
    relativePath: relativePath ?? this.relativePath,
    fileId: fileId ?? this.fileId,
    contentLength:
        contentLength.present ? contentLength.value : this.contentLength,
    contentType: contentType.present ? contentType.value : this.contentType,
    etag: etag.present ? etag.value : this.etag,
    lastModified: lastModified.present ? lastModified.value : this.lastModified,
    hasPreview: hasPreview.present ? hasPreview.value : this.hasPreview,
    realPath: realPath.present ? realPath.value : this.realPath,
    isFavorite: isFavorite.present ? isFavorite.value : this.isFavorite,
    fileMetadataWidth:
        fileMetadataWidth.present
            ? fileMetadataWidth.value
            : this.fileMetadataWidth,
    fileMetadataHeight:
        fileMetadataHeight.present
            ? fileMetadataHeight.value
            : this.fileMetadataHeight,
    faceDetections:
        faceDetections.present ? faceDetections.value : this.faceDetections,
  );
  RecognizeFaceItem copyWithCompanion(RecognizeFaceItemsCompanion data) {
    return RecognizeFaceItem(
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      parent: data.parent.present ? data.parent.value : this.parent,
      relativePath:
          data.relativePath.present
              ? data.relativePath.value
              : this.relativePath,
      fileId: data.fileId.present ? data.fileId.value : this.fileId,
      contentLength:
          data.contentLength.present
              ? data.contentLength.value
              : this.contentLength,
      contentType:
          data.contentType.present ? data.contentType.value : this.contentType,
      etag: data.etag.present ? data.etag.value : this.etag,
      lastModified:
          data.lastModified.present
              ? data.lastModified.value
              : this.lastModified,
      hasPreview:
          data.hasPreview.present ? data.hasPreview.value : this.hasPreview,
      realPath: data.realPath.present ? data.realPath.value : this.realPath,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      fileMetadataWidth:
          data.fileMetadataWidth.present
              ? data.fileMetadataWidth.value
              : this.fileMetadataWidth,
      fileMetadataHeight:
          data.fileMetadataHeight.present
              ? data.fileMetadataHeight.value
              : this.fileMetadataHeight,
      faceDetections:
          data.faceDetections.present
              ? data.faceDetections.value
              : this.faceDetections,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecognizeFaceItem(')
          ..write('rowId: $rowId, ')
          ..write('parent: $parent, ')
          ..write('relativePath: $relativePath, ')
          ..write('fileId: $fileId, ')
          ..write('contentLength: $contentLength, ')
          ..write('contentType: $contentType, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('hasPreview: $hasPreview, ')
          ..write('realPath: $realPath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('fileMetadataWidth: $fileMetadataWidth, ')
          ..write('fileMetadataHeight: $fileMetadataHeight, ')
          ..write('faceDetections: $faceDetections')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rowId,
    parent,
    relativePath,
    fileId,
    contentLength,
    contentType,
    etag,
    lastModified,
    hasPreview,
    realPath,
    isFavorite,
    fileMetadataWidth,
    fileMetadataHeight,
    faceDetections,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecognizeFaceItem &&
          other.rowId == this.rowId &&
          other.parent == this.parent &&
          other.relativePath == this.relativePath &&
          other.fileId == this.fileId &&
          other.contentLength == this.contentLength &&
          other.contentType == this.contentType &&
          other.etag == this.etag &&
          other.lastModified == this.lastModified &&
          other.hasPreview == this.hasPreview &&
          other.realPath == this.realPath &&
          other.isFavorite == this.isFavorite &&
          other.fileMetadataWidth == this.fileMetadataWidth &&
          other.fileMetadataHeight == this.fileMetadataHeight &&
          other.faceDetections == this.faceDetections);
}

class RecognizeFaceItemsCompanion extends UpdateCompanion<RecognizeFaceItem> {
  final Value<int> rowId;
  final Value<int> parent;
  final Value<String> relativePath;
  final Value<int> fileId;
  final Value<int?> contentLength;
  final Value<String?> contentType;
  final Value<String?> etag;
  final Value<DateTime?> lastModified;
  final Value<bool?> hasPreview;
  final Value<String?> realPath;
  final Value<bool?> isFavorite;
  final Value<int?> fileMetadataWidth;
  final Value<int?> fileMetadataHeight;
  final Value<String?> faceDetections;
  const RecognizeFaceItemsCompanion({
    this.rowId = const Value.absent(),
    this.parent = const Value.absent(),
    this.relativePath = const Value.absent(),
    this.fileId = const Value.absent(),
    this.contentLength = const Value.absent(),
    this.contentType = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.hasPreview = const Value.absent(),
    this.realPath = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.fileMetadataWidth = const Value.absent(),
    this.fileMetadataHeight = const Value.absent(),
    this.faceDetections = const Value.absent(),
  });
  RecognizeFaceItemsCompanion.insert({
    this.rowId = const Value.absent(),
    required int parent,
    required String relativePath,
    required int fileId,
    this.contentLength = const Value.absent(),
    this.contentType = const Value.absent(),
    this.etag = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.hasPreview = const Value.absent(),
    this.realPath = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.fileMetadataWidth = const Value.absent(),
    this.fileMetadataHeight = const Value.absent(),
    this.faceDetections = const Value.absent(),
  }) : parent = Value(parent),
       relativePath = Value(relativePath),
       fileId = Value(fileId);
  static Insertable<RecognizeFaceItem> custom({
    Expression<int>? rowId,
    Expression<int>? parent,
    Expression<String>? relativePath,
    Expression<int>? fileId,
    Expression<int>? contentLength,
    Expression<String>? contentType,
    Expression<String>? etag,
    Expression<DateTime>? lastModified,
    Expression<bool>? hasPreview,
    Expression<String>? realPath,
    Expression<bool>? isFavorite,
    Expression<int>? fileMetadataWidth,
    Expression<int>? fileMetadataHeight,
    Expression<String>? faceDetections,
  }) {
    return RawValuesInsertable({
      if (rowId != null) 'row_id': rowId,
      if (parent != null) 'parent': parent,
      if (relativePath != null) 'relative_path': relativePath,
      if (fileId != null) 'file_id': fileId,
      if (contentLength != null) 'content_length': contentLength,
      if (contentType != null) 'content_type': contentType,
      if (etag != null) 'etag': etag,
      if (lastModified != null) 'last_modified': lastModified,
      if (hasPreview != null) 'has_preview': hasPreview,
      if (realPath != null) 'real_path': realPath,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (fileMetadataWidth != null) 'file_metadata_width': fileMetadataWidth,
      if (fileMetadataHeight != null)
        'file_metadata_height': fileMetadataHeight,
      if (faceDetections != null) 'face_detections': faceDetections,
    });
  }

  RecognizeFaceItemsCompanion copyWith({
    Value<int>? rowId,
    Value<int>? parent,
    Value<String>? relativePath,
    Value<int>? fileId,
    Value<int?>? contentLength,
    Value<String?>? contentType,
    Value<String?>? etag,
    Value<DateTime?>? lastModified,
    Value<bool?>? hasPreview,
    Value<String?>? realPath,
    Value<bool?>? isFavorite,
    Value<int?>? fileMetadataWidth,
    Value<int?>? fileMetadataHeight,
    Value<String?>? faceDetections,
  }) {
    return RecognizeFaceItemsCompanion(
      rowId: rowId ?? this.rowId,
      parent: parent ?? this.parent,
      relativePath: relativePath ?? this.relativePath,
      fileId: fileId ?? this.fileId,
      contentLength: contentLength ?? this.contentLength,
      contentType: contentType ?? this.contentType,
      etag: etag ?? this.etag,
      lastModified: lastModified ?? this.lastModified,
      hasPreview: hasPreview ?? this.hasPreview,
      realPath: realPath ?? this.realPath,
      isFavorite: isFavorite ?? this.isFavorite,
      fileMetadataWidth: fileMetadataWidth ?? this.fileMetadataWidth,
      fileMetadataHeight: fileMetadataHeight ?? this.fileMetadataHeight,
      faceDetections: faceDetections ?? this.faceDetections,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rowId.present) {
      map['row_id'] = Variable<int>(rowId.value);
    }
    if (parent.present) {
      map['parent'] = Variable<int>(parent.value);
    }
    if (relativePath.present) {
      map['relative_path'] = Variable<String>(relativePath.value);
    }
    if (fileId.present) {
      map['file_id'] = Variable<int>(fileId.value);
    }
    if (contentLength.present) {
      map['content_length'] = Variable<int>(contentLength.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(
        $RecognizeFaceItemsTable.$converterlastModifiedn.toSql(
          lastModified.value,
        ),
      );
    }
    if (hasPreview.present) {
      map['has_preview'] = Variable<bool>(hasPreview.value);
    }
    if (realPath.present) {
      map['real_path'] = Variable<String>(realPath.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (fileMetadataWidth.present) {
      map['file_metadata_width'] = Variable<int>(fileMetadataWidth.value);
    }
    if (fileMetadataHeight.present) {
      map['file_metadata_height'] = Variable<int>(fileMetadataHeight.value);
    }
    if (faceDetections.present) {
      map['face_detections'] = Variable<String>(faceDetections.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecognizeFaceItemsCompanion(')
          ..write('rowId: $rowId, ')
          ..write('parent: $parent, ')
          ..write('relativePath: $relativePath, ')
          ..write('fileId: $fileId, ')
          ..write('contentLength: $contentLength, ')
          ..write('contentType: $contentType, ')
          ..write('etag: $etag, ')
          ..write('lastModified: $lastModified, ')
          ..write('hasPreview: $hasPreview, ')
          ..write('realPath: $realPath, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('fileMetadataWidth: $fileMetadataWidth, ')
          ..write('fileMetadataHeight: $fileMetadataHeight, ')
          ..write('faceDetections: $faceDetections')
          ..write(')'))
        .toString();
  }
}

abstract class _$SqliteDb extends GeneratedDatabase {
  _$SqliteDb(QueryExecutor e) : super(e);
  $SqliteDbManager get managers => $SqliteDbManager(this);
  late final $ServersTable servers = $ServersTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $FilesTable files = $FilesTable(this);
  late final $AccountFilesTable accountFiles = $AccountFilesTable(this);
  late final $ImagesTable images = $ImagesTable(this);
  late final $ImageLocationsTable imageLocations = $ImageLocationsTable(this);
  late final $TrashesTable trashes = $TrashesTable(this);
  late final $DirFilesTable dirFiles = $DirFilesTable(this);
  late final $AlbumsTable albums = $AlbumsTable(this);
  late final $AlbumSharesTable albumShares = $AlbumSharesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $FaceRecognitionPersonsTable faceRecognitionPersons =
      $FaceRecognitionPersonsTable(this);
  late final $NcAlbumsTable ncAlbums = $NcAlbumsTable(this);
  late final $NcAlbumItemsTable ncAlbumItems = $NcAlbumItemsTable(this);
  late final $RecognizeFacesTable recognizeFaces = $RecognizeFacesTable(this);
  late final $RecognizeFaceItemsTable recognizeFaceItems =
      $RecognizeFaceItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    servers,
    accounts,
    files,
    accountFiles,
    images,
    imageLocations,
    trashes,
    dirFiles,
    albums,
    albumShares,
    tags,
    faceRecognitionPersons,
    ncAlbums,
    ncAlbumItems,
    recognizeFaces,
    recognizeFaceItems,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'servers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('accounts', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'servers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('files', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('account_files', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'files',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('account_files', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'account_files',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('images', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'account_files',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('image_locations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'files',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('trashes', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'files',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dir_files', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'files',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('dir_files', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'files',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('albums', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'albums',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('album_shares', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'servers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('face_recognition_persons', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('nc_albums', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'nc_albums',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('nc_album_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recognize_faces', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recognize_faces',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recognize_face_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ServersTableCreateCompanionBuilder =
    ServersCompanion Function({Value<int> rowId, required String address});
typedef $$ServersTableUpdateCompanionBuilder =
    ServersCompanion Function({Value<int> rowId, Value<String> address});

final class $$ServersTableReferences
    extends BaseReferences<_$SqliteDb, $ServersTable, Server> {
  $$ServersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AccountsTable, List<Account>> _accountsRefsTable(
    _$SqliteDb db,
  ) => MultiTypedResultKey.fromTable(
    db.accounts,
    aliasName: $_aliasNameGenerator(db.servers.rowId, db.accounts.server),
  );

  $$AccountsTableProcessedTableManager get accountsRefs {
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.server.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FilesTable, List<File>> _filesRefsTable(
    _$SqliteDb db,
  ) => MultiTypedResultKey.fromTable(
    db.files,
    aliasName: $_aliasNameGenerator(db.servers.rowId, db.files.server),
  );

  $$FilesTableProcessedTableManager get filesRefs {
    final manager = $$FilesTableTableManager(
      $_db,
      $_db.files,
    ).filter((f) => f.server.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_filesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TagsTable, List<Tag>> _tagsRefsTable(
    _$SqliteDb db,
  ) => MultiTypedResultKey.fromTable(
    db.tags,
    aliasName: $_aliasNameGenerator(db.servers.rowId, db.tags.server),
  );

  $$TagsTableProcessedTableManager get tagsRefs {
    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.server.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_tagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServersTableFilterComposer extends Composer<_$SqliteDb, $ServersTable> {
  $$ServersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> accountsRefs(
    Expression<bool> Function($$AccountsTableFilterComposer f) f,
  ) {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.server,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> filesRefs(
    Expression<bool> Function($$FilesTableFilterComposer f) f,
  ) {
    final $$FilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.server,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableFilterComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tagsRefs(
    Expression<bool> Function($$TagsTableFilterComposer f) f,
  ) {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.server,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServersTableOrderingComposer
    extends Composer<_$SqliteDb, $ServersTable> {
  $$ServersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServersTableAnnotationComposer
    extends Composer<_$SqliteDb, $ServersTable> {
  $$ServersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  Expression<T> accountsRefs<T extends Object>(
    Expression<T> Function($$AccountsTableAnnotationComposer a) f,
  ) {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.server,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> filesRefs<T extends Object>(
    Expression<T> Function($$FilesTableAnnotationComposer a) f,
  ) {
    final $$FilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.server,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableAnnotationComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tagsRefs<T extends Object>(
    Expression<T> Function($$TagsTableAnnotationComposer a) f,
  ) {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.server,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServersTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $ServersTable,
          Server,
          $$ServersTableFilterComposer,
          $$ServersTableOrderingComposer,
          $$ServersTableAnnotationComposer,
          $$ServersTableCreateCompanionBuilder,
          $$ServersTableUpdateCompanionBuilder,
          (Server, $$ServersTableReferences),
          Server,
          PrefetchHooks Function({
            bool accountsRefs,
            bool filesRefs,
            bool tagsRefs,
          })
        > {
  $$ServersTableTableManager(_$SqliteDb db, $ServersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ServersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ServersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ServersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<String> address = const Value.absent(),
              }) => ServersCompanion(rowId: rowId, address: address),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required String address,
              }) => ServersCompanion.insert(rowId: rowId, address: address),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ServersTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            accountsRefs = false,
            filesRefs = false,
            tagsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (accountsRefs) db.accounts,
                if (filesRefs) db.files,
                if (tagsRefs) db.tags,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountsRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$ServersTableReferences
                          ._accountsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ServersTableReferences(
                                db,
                                table,
                                p0,
                              ).accountsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.server == item.rowId,
                          ),
                      typedResults: items,
                    ),
                  if (filesRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$ServersTableReferences._filesRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$ServersTableReferences(db, table, p0).filesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.server == item.rowId,
                          ),
                      typedResults: items,
                    ),
                  if (tagsRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$ServersTableReferences._tagsRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$ServersTableReferences(db, table, p0).tagsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.server == item.rowId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ServersTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $ServersTable,
      Server,
      $$ServersTableFilterComposer,
      $$ServersTableOrderingComposer,
      $$ServersTableAnnotationComposer,
      $$ServersTableCreateCompanionBuilder,
      $$ServersTableUpdateCompanionBuilder,
      (Server, $$ServersTableReferences),
      Server,
      PrefetchHooks Function({bool accountsRefs, bool filesRefs, bool tagsRefs})
    >;
typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> rowId,
      required int server,
      required String userId,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> rowId,
      Value<int> server,
      Value<String> userId,
    });

final class $$AccountsTableReferences
    extends BaseReferences<_$SqliteDb, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServersTable _serverTable(_$SqliteDb db) => db.servers.createAlias(
    $_aliasNameGenerator(db.accounts.server, db.servers.rowId),
  );

  $$ServersTableProcessedTableManager get server {
    final manager = $$ServersTableTableManager(
      $_db,
      $_db.servers,
    ).filter((f) => f.rowId($_item.server!));
    final item = $_typedResult.readTableOrNull(_serverTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AccountFilesTable, List<AccountFile>>
  _accountFilesRefsTable(_$SqliteDb db) => MultiTypedResultKey.fromTable(
    db.accountFiles,
    aliasName: $_aliasNameGenerator(db.accounts.rowId, db.accountFiles.account),
  );

  $$AccountFilesTableProcessedTableManager get accountFilesRefs {
    final manager = $$AccountFilesTableTableManager(
      $_db,
      $_db.accountFiles,
    ).filter((f) => f.account.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_accountFilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FaceRecognitionPersonsTable,
    List<FaceRecognitionPerson>
  >
  _faceRecognitionPersonsRefsTable(_$SqliteDb db) =>
      MultiTypedResultKey.fromTable(
        db.faceRecognitionPersons,
        aliasName: $_aliasNameGenerator(
          db.accounts.rowId,
          db.faceRecognitionPersons.account,
        ),
      );

  $$FaceRecognitionPersonsTableProcessedTableManager
  get faceRecognitionPersonsRefs {
    final manager = $$FaceRecognitionPersonsTableTableManager(
      $_db,
      $_db.faceRecognitionPersons,
    ).filter((f) => f.account.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(
      _faceRecognitionPersonsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NcAlbumsTable, List<NcAlbum>> _ncAlbumsRefsTable(
    _$SqliteDb db,
  ) => MultiTypedResultKey.fromTable(
    db.ncAlbums,
    aliasName: $_aliasNameGenerator(db.accounts.rowId, db.ncAlbums.account),
  );

  $$NcAlbumsTableProcessedTableManager get ncAlbumsRefs {
    final manager = $$NcAlbumsTableTableManager(
      $_db,
      $_db.ncAlbums,
    ).filter((f) => f.account.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_ncAlbumsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecognizeFacesTable, List<RecognizeFace>>
  _recognizeFacesRefsTable(_$SqliteDb db) => MultiTypedResultKey.fromTable(
    db.recognizeFaces,
    aliasName: $_aliasNameGenerator(
      db.accounts.rowId,
      db.recognizeFaces.account,
    ),
  );

  $$RecognizeFacesTableProcessedTableManager get recognizeFacesRefs {
    final manager = $$RecognizeFacesTableTableManager(
      $_db,
      $_db.recognizeFaces,
    ).filter((f) => f.account.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_recognizeFacesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$SqliteDb, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  $$ServersTableFilterComposer get server {
    final $$ServersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.server,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableFilterComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> accountFilesRefs(
    Expression<bool> Function($$AccountFilesTableFilterComposer f) f,
  ) {
    final $$AccountFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.accountFiles,
      getReferencedColumn: (t) => t.account,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountFilesTableFilterComposer(
            $db: $db,
            $table: $db.accountFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> faceRecognitionPersonsRefs(
    Expression<bool> Function($$FaceRecognitionPersonsTableFilterComposer f) f,
  ) {
    final $$FaceRecognitionPersonsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.rowId,
          referencedTable: $db.faceRecognitionPersons,
          getReferencedColumn: (t) => t.account,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FaceRecognitionPersonsTableFilterComposer(
                $db: $db,
                $table: $db.faceRecognitionPersons,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> ncAlbumsRefs(
    Expression<bool> Function($$NcAlbumsTableFilterComposer f) f,
  ) {
    final $$NcAlbumsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.ncAlbums,
      getReferencedColumn: (t) => t.account,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NcAlbumsTableFilterComposer(
            $db: $db,
            $table: $db.ncAlbums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recognizeFacesRefs(
    Expression<bool> Function($$RecognizeFacesTableFilterComposer f) f,
  ) {
    final $$RecognizeFacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.recognizeFaces,
      getReferencedColumn: (t) => t.account,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecognizeFacesTableFilterComposer(
            $db: $db,
            $table: $db.recognizeFaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$SqliteDb, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServersTableOrderingComposer get server {
    final $$ServersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.server,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableOrderingComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$SqliteDb, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  $$ServersTableAnnotationComposer get server {
    final $$ServersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.server,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableAnnotationComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> accountFilesRefs<T extends Object>(
    Expression<T> Function($$AccountFilesTableAnnotationComposer a) f,
  ) {
    final $$AccountFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.accountFiles,
      getReferencedColumn: (t) => t.account,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.accountFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> faceRecognitionPersonsRefs<T extends Object>(
    Expression<T> Function($$FaceRecognitionPersonsTableAnnotationComposer a) f,
  ) {
    final $$FaceRecognitionPersonsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.rowId,
          referencedTable: $db.faceRecognitionPersons,
          getReferencedColumn: (t) => t.account,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FaceRecognitionPersonsTableAnnotationComposer(
                $db: $db,
                $table: $db.faceRecognitionPersons,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> ncAlbumsRefs<T extends Object>(
    Expression<T> Function($$NcAlbumsTableAnnotationComposer a) f,
  ) {
    final $$NcAlbumsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.ncAlbums,
      getReferencedColumn: (t) => t.account,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NcAlbumsTableAnnotationComposer(
            $db: $db,
            $table: $db.ncAlbums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recognizeFacesRefs<T extends Object>(
    Expression<T> Function($$RecognizeFacesTableAnnotationComposer a) f,
  ) {
    final $$RecognizeFacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.recognizeFaces,
      getReferencedColumn: (t) => t.account,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecognizeFacesTableAnnotationComposer(
            $db: $db,
            $table: $db.recognizeFaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({
            bool server,
            bool accountFilesRefs,
            bool faceRecognitionPersonsRefs,
            bool ncAlbumsRefs,
            bool recognizeFacesRefs,
          })
        > {
  $$AccountsTableTableManager(_$SqliteDb db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<int> server = const Value.absent(),
                Value<String> userId = const Value.absent(),
              }) => AccountsCompanion(
                rowId: rowId,
                server: server,
                userId: userId,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required int server,
                required String userId,
              }) => AccountsCompanion.insert(
                rowId: rowId,
                server: server,
                userId: userId,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AccountsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            server = false,
            accountFilesRefs = false,
            faceRecognitionPersonsRefs = false,
            ncAlbumsRefs = false,
            recognizeFacesRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (accountFilesRefs) db.accountFiles,
                if (faceRecognitionPersonsRefs) db.faceRecognitionPersons,
                if (ncAlbumsRefs) db.ncAlbums,
                if (recognizeFacesRefs) db.recognizeFaces,
              ],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (server) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.server,
                            referencedTable: $$AccountsTableReferences
                                ._serverTable(db),
                            referencedColumn:
                                $$AccountsTableReferences
                                    ._serverTable(db)
                                    .rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountFilesRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$AccountsTableReferences
                          ._accountFilesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).accountFilesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.account == item.rowId,
                          ),
                      typedResults: items,
                    ),
                  if (faceRecognitionPersonsRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$AccountsTableReferences
                          ._faceRecognitionPersonsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).faceRecognitionPersonsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.account == item.rowId,
                          ),
                      typedResults: items,
                    ),
                  if (ncAlbumsRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$AccountsTableReferences
                          ._ncAlbumsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).ncAlbumsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.account == item.rowId,
                          ),
                      typedResults: items,
                    ),
                  if (recognizeFacesRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$AccountsTableReferences
                          ._recognizeFacesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).recognizeFacesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.account == item.rowId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({
        bool server,
        bool accountFilesRefs,
        bool faceRecognitionPersonsRefs,
        bool ncAlbumsRefs,
        bool recognizeFacesRefs,
      })
    >;
typedef $$FilesTableCreateCompanionBuilder =
    FilesCompanion Function({
      Value<int> rowId,
      required int server,
      required int fileId,
      Value<int?> contentLength,
      Value<String?> contentType,
      Value<String?> etag,
      Value<DateTime?> lastModified,
      Value<bool?> isCollection,
      Value<int?> usedBytes,
      Value<bool?> hasPreview,
      Value<String?> ownerId,
      Value<String?> ownerDisplayName,
    });
typedef $$FilesTableUpdateCompanionBuilder =
    FilesCompanion Function({
      Value<int> rowId,
      Value<int> server,
      Value<int> fileId,
      Value<int?> contentLength,
      Value<String?> contentType,
      Value<String?> etag,
      Value<DateTime?> lastModified,
      Value<bool?> isCollection,
      Value<int?> usedBytes,
      Value<bool?> hasPreview,
      Value<String?> ownerId,
      Value<String?> ownerDisplayName,
    });

final class $$FilesTableReferences
    extends BaseReferences<_$SqliteDb, $FilesTable, File> {
  $$FilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServersTable _serverTable(_$SqliteDb db) => db.servers.createAlias(
    $_aliasNameGenerator(db.files.server, db.servers.rowId),
  );

  $$ServersTableProcessedTableManager get server {
    final manager = $$ServersTableTableManager(
      $_db,
      $_db.servers,
    ).filter((f) => f.rowId($_item.server!));
    final item = $_typedResult.readTableOrNull(_serverTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AccountFilesTable, List<AccountFile>>
  _accountFilesRefsTable(_$SqliteDb db) => MultiTypedResultKey.fromTable(
    db.accountFiles,
    aliasName: $_aliasNameGenerator(db.files.rowId, db.accountFiles.file),
  );

  $$AccountFilesTableProcessedTableManager get accountFilesRefs {
    final manager = $$AccountFilesTableTableManager(
      $_db,
      $_db.accountFiles,
    ).filter((f) => f.file.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_accountFilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrashesTable, List<Trash>> _trashesRefsTable(
    _$SqliteDb db,
  ) => MultiTypedResultKey.fromTable(
    db.trashes,
    aliasName: $_aliasNameGenerator(db.files.rowId, db.trashes.file),
  );

  $$TrashesTableProcessedTableManager get trashesRefs {
    final manager = $$TrashesTableTableManager(
      $_db,
      $_db.trashes,
    ).filter((f) => f.file.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_trashesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DirFilesTable, List<DirFile>> _dirFilesRefsTable(
    _$SqliteDb db,
  ) => MultiTypedResultKey.fromTable(
    db.dirFiles,
    aliasName: $_aliasNameGenerator(db.files.rowId, db.dirFiles.dir),
  );

  $$DirFilesTableProcessedTableManager get dirFilesRefs {
    final manager = $$DirFilesTableTableManager(
      $_db,
      $_db.dirFiles,
    ).filter((f) => f.dir.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_dirFilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DirFilesTable, List<DirFile>> _childTable(
    _$SqliteDb db,
  ) => MultiTypedResultKey.fromTable(
    db.dirFiles,
    aliasName: $_aliasNameGenerator(db.files.rowId, db.dirFiles.child),
  );

  $$DirFilesTableProcessedTableManager get child {
    final manager = $$DirFilesTableTableManager(
      $_db,
      $_db.dirFiles,
    ).filter((f) => f.child.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_childTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AlbumsTable, List<Album>> _albumsRefsTable(
    _$SqliteDb db,
  ) => MultiTypedResultKey.fromTable(
    db.albums,
    aliasName: $_aliasNameGenerator(db.files.rowId, db.albums.file),
  );

  $$AlbumsTableProcessedTableManager get albumsRefs {
    final manager = $$AlbumsTableTableManager(
      $_db,
      $_db.albums,
    ).filter((f) => f.file.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_albumsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FilesTableFilterComposer extends Composer<_$SqliteDb, $FilesTable> {
  $$FilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentLength => $composableBuilder(
    column: $table.contentLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, DateTime>
  get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isCollection => $composableBuilder(
    column: $table.isCollection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usedBytes => $composableBuilder(
    column: $table.usedBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasPreview => $composableBuilder(
    column: $table.hasPreview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerDisplayName => $composableBuilder(
    column: $table.ownerDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  $$ServersTableFilterComposer get server {
    final $$ServersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.server,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableFilterComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> accountFilesRefs(
    Expression<bool> Function($$AccountFilesTableFilterComposer f) f,
  ) {
    final $$AccountFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.accountFiles,
      getReferencedColumn: (t) => t.file,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountFilesTableFilterComposer(
            $db: $db,
            $table: $db.accountFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trashesRefs(
    Expression<bool> Function($$TrashesTableFilterComposer f) f,
  ) {
    final $$TrashesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.trashes,
      getReferencedColumn: (t) => t.file,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrashesTableFilterComposer(
            $db: $db,
            $table: $db.trashes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> dirFilesRefs(
    Expression<bool> Function($$DirFilesTableFilterComposer f) f,
  ) {
    final $$DirFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.dirFiles,
      getReferencedColumn: (t) => t.dir,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DirFilesTableFilterComposer(
            $db: $db,
            $table: $db.dirFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> child(
    Expression<bool> Function($$DirFilesTableFilterComposer f) f,
  ) {
    final $$DirFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.dirFiles,
      getReferencedColumn: (t) => t.child,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DirFilesTableFilterComposer(
            $db: $db,
            $table: $db.dirFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> albumsRefs(
    Expression<bool> Function($$AlbumsTableFilterComposer f) f,
  ) {
    final $$AlbumsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.albums,
      getReferencedColumn: (t) => t.file,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumsTableFilterComposer(
            $db: $db,
            $table: $db.albums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FilesTableOrderingComposer extends Composer<_$SqliteDb, $FilesTable> {
  $$FilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentLength => $composableBuilder(
    column: $table.contentLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCollection => $composableBuilder(
    column: $table.isCollection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usedBytes => $composableBuilder(
    column: $table.usedBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasPreview => $composableBuilder(
    column: $table.hasPreview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerDisplayName => $composableBuilder(
    column: $table.ownerDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServersTableOrderingComposer get server {
    final $$ServersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.server,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableOrderingComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FilesTableAnnotationComposer extends Composer<_$SqliteDb, $FilesTable> {
  $$FilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<int> get fileId =>
      $composableBuilder(column: $table.fileId, builder: (column) => column);

  GeneratedColumn<int> get contentLength => $composableBuilder(
    column: $table.contentLength,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, DateTime> get lastModified =>
      $composableBuilder(
        column: $table.lastModified,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isCollection => $composableBuilder(
    column: $table.isCollection,
    builder: (column) => column,
  );

  GeneratedColumn<int> get usedBytes =>
      $composableBuilder(column: $table.usedBytes, builder: (column) => column);

  GeneratedColumn<bool> get hasPreview => $composableBuilder(
    column: $table.hasPreview,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get ownerDisplayName => $composableBuilder(
    column: $table.ownerDisplayName,
    builder: (column) => column,
  );

  $$ServersTableAnnotationComposer get server {
    final $$ServersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.server,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableAnnotationComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> accountFilesRefs<T extends Object>(
    Expression<T> Function($$AccountFilesTableAnnotationComposer a) f,
  ) {
    final $$AccountFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.accountFiles,
      getReferencedColumn: (t) => t.file,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.accountFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trashesRefs<T extends Object>(
    Expression<T> Function($$TrashesTableAnnotationComposer a) f,
  ) {
    final $$TrashesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.trashes,
      getReferencedColumn: (t) => t.file,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrashesTableAnnotationComposer(
            $db: $db,
            $table: $db.trashes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> dirFilesRefs<T extends Object>(
    Expression<T> Function($$DirFilesTableAnnotationComposer a) f,
  ) {
    final $$DirFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.dirFiles,
      getReferencedColumn: (t) => t.dir,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DirFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.dirFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> child<T extends Object>(
    Expression<T> Function($$DirFilesTableAnnotationComposer a) f,
  ) {
    final $$DirFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.dirFiles,
      getReferencedColumn: (t) => t.child,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DirFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.dirFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> albumsRefs<T extends Object>(
    Expression<T> Function($$AlbumsTableAnnotationComposer a) f,
  ) {
    final $$AlbumsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.albums,
      getReferencedColumn: (t) => t.file,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumsTableAnnotationComposer(
            $db: $db,
            $table: $db.albums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FilesTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $FilesTable,
          File,
          $$FilesTableFilterComposer,
          $$FilesTableOrderingComposer,
          $$FilesTableAnnotationComposer,
          $$FilesTableCreateCompanionBuilder,
          $$FilesTableUpdateCompanionBuilder,
          (File, $$FilesTableReferences),
          File,
          PrefetchHooks Function({
            bool server,
            bool accountFilesRefs,
            bool trashesRefs,
            bool dirFilesRefs,
            bool child,
            bool albumsRefs,
          })
        > {
  $$FilesTableTableManager(_$SqliteDb db, $FilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$FilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$FilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$FilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<int> server = const Value.absent(),
                Value<int> fileId = const Value.absent(),
                Value<int?> contentLength = const Value.absent(),
                Value<String?> contentType = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<DateTime?> lastModified = const Value.absent(),
                Value<bool?> isCollection = const Value.absent(),
                Value<int?> usedBytes = const Value.absent(),
                Value<bool?> hasPreview = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> ownerDisplayName = const Value.absent(),
              }) => FilesCompanion(
                rowId: rowId,
                server: server,
                fileId: fileId,
                contentLength: contentLength,
                contentType: contentType,
                etag: etag,
                lastModified: lastModified,
                isCollection: isCollection,
                usedBytes: usedBytes,
                hasPreview: hasPreview,
                ownerId: ownerId,
                ownerDisplayName: ownerDisplayName,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required int server,
                required int fileId,
                Value<int?> contentLength = const Value.absent(),
                Value<String?> contentType = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<DateTime?> lastModified = const Value.absent(),
                Value<bool?> isCollection = const Value.absent(),
                Value<int?> usedBytes = const Value.absent(),
                Value<bool?> hasPreview = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<String?> ownerDisplayName = const Value.absent(),
              }) => FilesCompanion.insert(
                rowId: rowId,
                server: server,
                fileId: fileId,
                contentLength: contentLength,
                contentType: contentType,
                etag: etag,
                lastModified: lastModified,
                isCollection: isCollection,
                usedBytes: usedBytes,
                hasPreview: hasPreview,
                ownerId: ownerId,
                ownerDisplayName: ownerDisplayName,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$FilesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            server = false,
            accountFilesRefs = false,
            trashesRefs = false,
            dirFilesRefs = false,
            child = false,
            albumsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (accountFilesRefs) db.accountFiles,
                if (trashesRefs) db.trashes,
                if (dirFilesRefs) db.dirFiles,
                if (child) db.dirFiles,
                if (albumsRefs) db.albums,
              ],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (server) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.server,
                            referencedTable: $$FilesTableReferences
                                ._serverTable(db),
                            referencedColumn:
                                $$FilesTableReferences._serverTable(db).rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountFilesRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$FilesTableReferences
                          ._accountFilesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$FilesTableReferences(
                                db,
                                table,
                                p0,
                              ).accountFilesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.file == item.rowId,
                          ),
                      typedResults: items,
                    ),
                  if (trashesRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$FilesTableReferences._trashesRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$FilesTableReferences(db, table, p0).trashesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.file == item.rowId,
                          ),
                      typedResults: items,
                    ),
                  if (dirFilesRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$FilesTableReferences
                          ._dirFilesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$FilesTableReferences(
                                db,
                                table,
                                p0,
                              ).dirFilesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.dir == item.rowId),
                      typedResults: items,
                    ),
                  if (child)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$FilesTableReferences._childTable(db),
                      managerFromTypedResult:
                          (p0) => $$FilesTableReferences(db, table, p0).child,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.child == item.rowId,
                          ),
                      typedResults: items,
                    ),
                  if (albumsRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$FilesTableReferences._albumsRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$FilesTableReferences(db, table, p0).albumsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.file == item.rowId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FilesTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $FilesTable,
      File,
      $$FilesTableFilterComposer,
      $$FilesTableOrderingComposer,
      $$FilesTableAnnotationComposer,
      $$FilesTableCreateCompanionBuilder,
      $$FilesTableUpdateCompanionBuilder,
      (File, $$FilesTableReferences),
      File,
      PrefetchHooks Function({
        bool server,
        bool accountFilesRefs,
        bool trashesRefs,
        bool dirFilesRefs,
        bool child,
        bool albumsRefs,
      })
    >;
typedef $$AccountFilesTableCreateCompanionBuilder =
    AccountFilesCompanion Function({
      Value<int> rowId,
      required int account,
      required int file,
      required String relativePath,
      Value<bool?> isFavorite,
      Value<bool?> isArchived,
      Value<DateTime?> overrideDateTime,
      required DateTime bestDateTime,
    });
typedef $$AccountFilesTableUpdateCompanionBuilder =
    AccountFilesCompanion Function({
      Value<int> rowId,
      Value<int> account,
      Value<int> file,
      Value<String> relativePath,
      Value<bool?> isFavorite,
      Value<bool?> isArchived,
      Value<DateTime?> overrideDateTime,
      Value<DateTime> bestDateTime,
    });

final class $$AccountFilesTableReferences
    extends BaseReferences<_$SqliteDb, $AccountFilesTable, AccountFile> {
  $$AccountFilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountTable(_$SqliteDb db) => db.accounts.createAlias(
    $_aliasNameGenerator(db.accountFiles.account, db.accounts.rowId),
  );

  $$AccountsTableProcessedTableManager get account {
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.rowId($_item.account!));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FilesTable _fileTable(_$SqliteDb db) => db.files.createAlias(
    $_aliasNameGenerator(db.accountFiles.file, db.files.rowId),
  );

  $$FilesTableProcessedTableManager get file {
    final manager = $$FilesTableTableManager(
      $_db,
      $_db.files,
    ).filter((f) => f.rowId($_item.file!));
    final item = $_typedResult.readTableOrNull(_fileTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ImagesTable, List<Image>> _imagesRefsTable(
    _$SqliteDb db,
  ) => MultiTypedResultKey.fromTable(
    db.images,
    aliasName: $_aliasNameGenerator(
      db.accountFiles.rowId,
      db.images.accountFile,
    ),
  );

  $$ImagesTableProcessedTableManager get imagesRefs {
    final manager = $$ImagesTableTableManager(
      $_db,
      $_db.images,
    ).filter((f) => f.accountFile.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_imagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ImageLocationsTable, List<ImageLocation>>
  _imageLocationsRefsTable(_$SqliteDb db) => MultiTypedResultKey.fromTable(
    db.imageLocations,
    aliasName: $_aliasNameGenerator(
      db.accountFiles.rowId,
      db.imageLocations.accountFile,
    ),
  );

  $$ImageLocationsTableProcessedTableManager get imageLocationsRefs {
    final manager = $$ImageLocationsTableTableManager(
      $_db,
      $_db.imageLocations,
    ).filter((f) => f.accountFile.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_imageLocationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountFilesTableFilterComposer
    extends Composer<_$SqliteDb, $AccountFilesTable> {
  $$AccountFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, DateTime>
  get overrideDateTime => $composableBuilder(
    column: $table.overrideDateTime,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime>
  get bestDateTime => $composableBuilder(
    column: $table.bestDateTime,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$AccountsTableFilterComposer get account {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FilesTableFilterComposer get file {
    final $$FilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.file,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableFilterComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> imagesRefs(
    Expression<bool> Function($$ImagesTableFilterComposer f) f,
  ) {
    final $$ImagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.images,
      getReferencedColumn: (t) => t.accountFile,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImagesTableFilterComposer(
            $db: $db,
            $table: $db.images,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> imageLocationsRefs(
    Expression<bool> Function($$ImageLocationsTableFilterComposer f) f,
  ) {
    final $$ImageLocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.imageLocations,
      getReferencedColumn: (t) => t.accountFile,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImageLocationsTableFilterComposer(
            $db: $db,
            $table: $db.imageLocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountFilesTableOrderingComposer
    extends Composer<_$SqliteDb, $AccountFilesTable> {
  $$AccountFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get overrideDateTime => $composableBuilder(
    column: $table.overrideDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get bestDateTime => $composableBuilder(
    column: $table.bestDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get account {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FilesTableOrderingComposer get file {
    final $$FilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.file,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableOrderingComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountFilesTableAnnotationComposer
    extends Composer<_$SqliteDb, $AccountFilesTable> {
  $$AccountFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime?, DateTime> get overrideDateTime =>
      $composableBuilder(
        column: $table.overrideDateTime,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DateTime, DateTime> get bestDateTime =>
      $composableBuilder(
        column: $table.bestDateTime,
        builder: (column) => column,
      );

  $$AccountsTableAnnotationComposer get account {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FilesTableAnnotationComposer get file {
    final $$FilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.file,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableAnnotationComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> imagesRefs<T extends Object>(
    Expression<T> Function($$ImagesTableAnnotationComposer a) f,
  ) {
    final $$ImagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.images,
      getReferencedColumn: (t) => t.accountFile,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImagesTableAnnotationComposer(
            $db: $db,
            $table: $db.images,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> imageLocationsRefs<T extends Object>(
    Expression<T> Function($$ImageLocationsTableAnnotationComposer a) f,
  ) {
    final $$ImageLocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.imageLocations,
      getReferencedColumn: (t) => t.accountFile,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ImageLocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.imageLocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountFilesTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $AccountFilesTable,
          AccountFile,
          $$AccountFilesTableFilterComposer,
          $$AccountFilesTableOrderingComposer,
          $$AccountFilesTableAnnotationComposer,
          $$AccountFilesTableCreateCompanionBuilder,
          $$AccountFilesTableUpdateCompanionBuilder,
          (AccountFile, $$AccountFilesTableReferences),
          AccountFile,
          PrefetchHooks Function({
            bool account,
            bool file,
            bool imagesRefs,
            bool imageLocationsRefs,
          })
        > {
  $$AccountFilesTableTableManager(_$SqliteDb db, $AccountFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AccountFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AccountFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$AccountFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<int> account = const Value.absent(),
                Value<int> file = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<bool?> isFavorite = const Value.absent(),
                Value<bool?> isArchived = const Value.absent(),
                Value<DateTime?> overrideDateTime = const Value.absent(),
                Value<DateTime> bestDateTime = const Value.absent(),
              }) => AccountFilesCompanion(
                rowId: rowId,
                account: account,
                file: file,
                relativePath: relativePath,
                isFavorite: isFavorite,
                isArchived: isArchived,
                overrideDateTime: overrideDateTime,
                bestDateTime: bestDateTime,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required int account,
                required int file,
                required String relativePath,
                Value<bool?> isFavorite = const Value.absent(),
                Value<bool?> isArchived = const Value.absent(),
                Value<DateTime?> overrideDateTime = const Value.absent(),
                required DateTime bestDateTime,
              }) => AccountFilesCompanion.insert(
                rowId: rowId,
                account: account,
                file: file,
                relativePath: relativePath,
                isFavorite: isFavorite,
                isArchived: isArchived,
                overrideDateTime: overrideDateTime,
                bestDateTime: bestDateTime,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AccountFilesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            account = false,
            file = false,
            imagesRefs = false,
            imageLocationsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (imagesRefs) db.images,
                if (imageLocationsRefs) db.imageLocations,
              ],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (account) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.account,
                            referencedTable: $$AccountFilesTableReferences
                                ._accountTable(db),
                            referencedColumn:
                                $$AccountFilesTableReferences
                                    ._accountTable(db)
                                    .rowId,
                          )
                          as T;
                }
                if (file) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.file,
                            referencedTable: $$AccountFilesTableReferences
                                ._fileTable(db),
                            referencedColumn:
                                $$AccountFilesTableReferences
                                    ._fileTable(db)
                                    .rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (imagesRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$AccountFilesTableReferences
                          ._imagesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AccountFilesTableReferences(
                                db,
                                table,
                                p0,
                              ).imagesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.accountFile == item.rowId,
                          ),
                      typedResults: items,
                    ),
                  if (imageLocationsRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$AccountFilesTableReferences
                          ._imageLocationsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AccountFilesTableReferences(
                                db,
                                table,
                                p0,
                              ).imageLocationsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.accountFile == item.rowId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AccountFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $AccountFilesTable,
      AccountFile,
      $$AccountFilesTableFilterComposer,
      $$AccountFilesTableOrderingComposer,
      $$AccountFilesTableAnnotationComposer,
      $$AccountFilesTableCreateCompanionBuilder,
      $$AccountFilesTableUpdateCompanionBuilder,
      (AccountFile, $$AccountFilesTableReferences),
      AccountFile,
      PrefetchHooks Function({
        bool account,
        bool file,
        bool imagesRefs,
        bool imageLocationsRefs,
      })
    >;
typedef $$ImagesTableCreateCompanionBuilder =
    ImagesCompanion Function({
      Value<int> accountFile,
      required DateTime lastUpdated,
      Value<String?> fileEtag,
      Value<int?> width,
      Value<int?> height,
      Value<String?> exifRaw,
      Value<String?> xmpRaw,
      Value<int?> src,
      Value<DateTime?> dateTimeOriginal,
    });
typedef $$ImagesTableUpdateCompanionBuilder =
    ImagesCompanion Function({
      Value<int> accountFile,
      Value<DateTime> lastUpdated,
      Value<String?> fileEtag,
      Value<int?> width,
      Value<int?> height,
      Value<String?> exifRaw,
      Value<String?> xmpRaw,
      Value<int?> src,
      Value<DateTime?> dateTimeOriginal,
    });

final class $$ImagesTableReferences
    extends BaseReferences<_$SqliteDb, $ImagesTable, Image> {
  $$ImagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountFilesTable _accountFileTable(_$SqliteDb db) =>
      db.accountFiles.createAlias(
        $_aliasNameGenerator(db.images.accountFile, db.accountFiles.rowId),
      );

  $$AccountFilesTableProcessedTableManager get accountFile {
    final manager = $$AccountFilesTableTableManager(
      $_db,
      $_db.accountFiles,
    ).filter((f) => f.rowId($_item.accountFile!));
    final item = $_typedResult.readTableOrNull(_accountFileTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ImagesTableFilterComposer extends Composer<_$SqliteDb, $ImagesTable> {
  $$ImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime>
  get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get fileEtag => $composableBuilder(
    column: $table.fileEtag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exifRaw => $composableBuilder(
    column: $table.exifRaw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get xmpRaw => $composableBuilder(
    column: $table.xmpRaw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get src => $composableBuilder(
    column: $table.src,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, DateTime>
  get dateTimeOriginal => $composableBuilder(
    column: $table.dateTimeOriginal,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$AccountFilesTableFilterComposer get accountFile {
    final $$AccountFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountFile,
      referencedTable: $db.accountFiles,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountFilesTableFilterComposer(
            $db: $db,
            $table: $db.accountFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImagesTableOrderingComposer extends Composer<_$SqliteDb, $ImagesTable> {
  $$ImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileEtag => $composableBuilder(
    column: $table.fileEtag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exifRaw => $composableBuilder(
    column: $table.exifRaw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get xmpRaw => $composableBuilder(
    column: $table.xmpRaw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get src => $composableBuilder(
    column: $table.src,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateTimeOriginal => $composableBuilder(
    column: $table.dateTimeOriginal,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountFilesTableOrderingComposer get accountFile {
    final $$AccountFilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountFile,
      referencedTable: $db.accountFiles,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountFilesTableOrderingComposer(
            $db: $db,
            $table: $db.accountFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImagesTableAnnotationComposer
    extends Composer<_$SqliteDb, $ImagesTable> {
  $$ImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumnWithTypeConverter<DateTime, DateTime> get lastUpdated =>
      $composableBuilder(
        column: $table.lastUpdated,
        builder: (column) => column,
      );

  GeneratedColumn<String> get fileEtag =>
      $composableBuilder(column: $table.fileEtag, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get exifRaw =>
      $composableBuilder(column: $table.exifRaw, builder: (column) => column);

  GeneratedColumn<String> get xmpRaw =>
      $composableBuilder(column: $table.xmpRaw, builder: (column) => column);

  GeneratedColumn<int> get src =>
      $composableBuilder(column: $table.src, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, DateTime> get dateTimeOriginal =>
      $composableBuilder(
        column: $table.dateTimeOriginal,
        builder: (column) => column,
      );

  $$AccountFilesTableAnnotationComposer get accountFile {
    final $$AccountFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountFile,
      referencedTable: $db.accountFiles,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.accountFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImagesTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $ImagesTable,
          Image,
          $$ImagesTableFilterComposer,
          $$ImagesTableOrderingComposer,
          $$ImagesTableAnnotationComposer,
          $$ImagesTableCreateCompanionBuilder,
          $$ImagesTableUpdateCompanionBuilder,
          (Image, $$ImagesTableReferences),
          Image,
          PrefetchHooks Function({bool accountFile})
        > {
  $$ImagesTableTableManager(_$SqliteDb db, $ImagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> accountFile = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<String?> fileEtag = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<String?> exifRaw = const Value.absent(),
                Value<String?> xmpRaw = const Value.absent(),
                Value<int?> src = const Value.absent(),
                Value<DateTime?> dateTimeOriginal = const Value.absent(),
              }) => ImagesCompanion(
                accountFile: accountFile,
                lastUpdated: lastUpdated,
                fileEtag: fileEtag,
                width: width,
                height: height,
                exifRaw: exifRaw,
                xmpRaw: xmpRaw,
                src: src,
                dateTimeOriginal: dateTimeOriginal,
              ),
          createCompanionCallback:
              ({
                Value<int> accountFile = const Value.absent(),
                required DateTime lastUpdated,
                Value<String?> fileEtag = const Value.absent(),
                Value<int?> width = const Value.absent(),
                Value<int?> height = const Value.absent(),
                Value<String?> exifRaw = const Value.absent(),
                Value<String?> xmpRaw = const Value.absent(),
                Value<int?> src = const Value.absent(),
                Value<DateTime?> dateTimeOriginal = const Value.absent(),
              }) => ImagesCompanion.insert(
                accountFile: accountFile,
                lastUpdated: lastUpdated,
                fileEtag: fileEtag,
                width: width,
                height: height,
                exifRaw: exifRaw,
                xmpRaw: xmpRaw,
                src: src,
                dateTimeOriginal: dateTimeOriginal,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ImagesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({accountFile = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (accountFile) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountFile,
                            referencedTable: $$ImagesTableReferences
                                ._accountFileTable(db),
                            referencedColumn:
                                $$ImagesTableReferences
                                    ._accountFileTable(db)
                                    .rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $ImagesTable,
      Image,
      $$ImagesTableFilterComposer,
      $$ImagesTableOrderingComposer,
      $$ImagesTableAnnotationComposer,
      $$ImagesTableCreateCompanionBuilder,
      $$ImagesTableUpdateCompanionBuilder,
      (Image, $$ImagesTableReferences),
      Image,
      PrefetchHooks Function({bool accountFile})
    >;
typedef $$ImageLocationsTableCreateCompanionBuilder =
    ImageLocationsCompanion Function({
      Value<int> accountFile,
      required int version,
      Value<String?> name,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> countryCode,
      Value<String?> admin1,
      Value<String?> admin2,
    });
typedef $$ImageLocationsTableUpdateCompanionBuilder =
    ImageLocationsCompanion Function({
      Value<int> accountFile,
      Value<int> version,
      Value<String?> name,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> countryCode,
      Value<String?> admin1,
      Value<String?> admin2,
    });

final class $$ImageLocationsTableReferences
    extends BaseReferences<_$SqliteDb, $ImageLocationsTable, ImageLocation> {
  $$ImageLocationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountFilesTable _accountFileTable(_$SqliteDb db) =>
      db.accountFiles.createAlias(
        $_aliasNameGenerator(
          db.imageLocations.accountFile,
          db.accountFiles.rowId,
        ),
      );

  $$AccountFilesTableProcessedTableManager get accountFile {
    final manager = $$AccountFilesTableTableManager(
      $_db,
      $_db.accountFiles,
    ).filter((f) => f.rowId($_item.accountFile!));
    final item = $_typedResult.readTableOrNull(_accountFileTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ImageLocationsTableFilterComposer
    extends Composer<_$SqliteDb, $ImageLocationsTable> {
  $$ImageLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get admin1 => $composableBuilder(
    column: $table.admin1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get admin2 => $composableBuilder(
    column: $table.admin2,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountFilesTableFilterComposer get accountFile {
    final $$AccountFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountFile,
      referencedTable: $db.accountFiles,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountFilesTableFilterComposer(
            $db: $db,
            $table: $db.accountFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImageLocationsTableOrderingComposer
    extends Composer<_$SqliteDb, $ImageLocationsTable> {
  $$ImageLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get admin1 => $composableBuilder(
    column: $table.admin1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get admin2 => $composableBuilder(
    column: $table.admin2,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountFilesTableOrderingComposer get accountFile {
    final $$AccountFilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountFile,
      referencedTable: $db.accountFiles,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountFilesTableOrderingComposer(
            $db: $db,
            $table: $db.accountFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImageLocationsTableAnnotationComposer
    extends Composer<_$SqliteDb, $ImageLocationsTable> {
  $$ImageLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get admin1 =>
      $composableBuilder(column: $table.admin1, builder: (column) => column);

  GeneratedColumn<String> get admin2 =>
      $composableBuilder(column: $table.admin2, builder: (column) => column);

  $$AccountFilesTableAnnotationComposer get accountFile {
    final $$AccountFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountFile,
      referencedTable: $db.accountFiles,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.accountFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ImageLocationsTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $ImageLocationsTable,
          ImageLocation,
          $$ImageLocationsTableFilterComposer,
          $$ImageLocationsTableOrderingComposer,
          $$ImageLocationsTableAnnotationComposer,
          $$ImageLocationsTableCreateCompanionBuilder,
          $$ImageLocationsTableUpdateCompanionBuilder,
          (ImageLocation, $$ImageLocationsTableReferences),
          ImageLocation,
          PrefetchHooks Function({bool accountFile})
        > {
  $$ImageLocationsTableTableManager(_$SqliteDb db, $ImageLocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ImageLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ImageLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ImageLocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> accountFile = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
                Value<String?> admin1 = const Value.absent(),
                Value<String?> admin2 = const Value.absent(),
              }) => ImageLocationsCompanion(
                accountFile: accountFile,
                version: version,
                name: name,
                latitude: latitude,
                longitude: longitude,
                countryCode: countryCode,
                admin1: admin1,
                admin2: admin2,
              ),
          createCompanionCallback:
              ({
                Value<int> accountFile = const Value.absent(),
                required int version,
                Value<String?> name = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
                Value<String?> admin1 = const Value.absent(),
                Value<String?> admin2 = const Value.absent(),
              }) => ImageLocationsCompanion.insert(
                accountFile: accountFile,
                version: version,
                name: name,
                latitude: latitude,
                longitude: longitude,
                countryCode: countryCode,
                admin1: admin1,
                admin2: admin2,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ImageLocationsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({accountFile = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (accountFile) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountFile,
                            referencedTable: $$ImageLocationsTableReferences
                                ._accountFileTable(db),
                            referencedColumn:
                                $$ImageLocationsTableReferences
                                    ._accountFileTable(db)
                                    .rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ImageLocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $ImageLocationsTable,
      ImageLocation,
      $$ImageLocationsTableFilterComposer,
      $$ImageLocationsTableOrderingComposer,
      $$ImageLocationsTableAnnotationComposer,
      $$ImageLocationsTableCreateCompanionBuilder,
      $$ImageLocationsTableUpdateCompanionBuilder,
      (ImageLocation, $$ImageLocationsTableReferences),
      ImageLocation,
      PrefetchHooks Function({bool accountFile})
    >;
typedef $$TrashesTableCreateCompanionBuilder =
    TrashesCompanion Function({
      Value<int> file,
      required String filename,
      required String originalLocation,
      required DateTime deletionTime,
    });
typedef $$TrashesTableUpdateCompanionBuilder =
    TrashesCompanion Function({
      Value<int> file,
      Value<String> filename,
      Value<String> originalLocation,
      Value<DateTime> deletionTime,
    });

final class $$TrashesTableReferences
    extends BaseReferences<_$SqliteDb, $TrashesTable, Trash> {
  $$TrashesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FilesTable _fileTable(_$SqliteDb db) => db.files.createAlias(
    $_aliasNameGenerator(db.trashes.file, db.files.rowId),
  );

  $$FilesTableProcessedTableManager get file {
    final manager = $$FilesTableTableManager(
      $_db,
      $_db.files,
    ).filter((f) => f.rowId($_item.file!));
    final item = $_typedResult.readTableOrNull(_fileTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrashesTableFilterComposer extends Composer<_$SqliteDb, $TrashesTable> {
  $$TrashesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalLocation => $composableBuilder(
    column: $table.originalLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime>
  get deletionTime => $composableBuilder(
    column: $table.deletionTime,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$FilesTableFilterComposer get file {
    final $$FilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.file,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableFilterComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrashesTableOrderingComposer
    extends Composer<_$SqliteDb, $TrashesTable> {
  $$TrashesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalLocation => $composableBuilder(
    column: $table.originalLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletionTime => $composableBuilder(
    column: $table.deletionTime,
    builder: (column) => ColumnOrderings(column),
  );

  $$FilesTableOrderingComposer get file {
    final $$FilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.file,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableOrderingComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrashesTableAnnotationComposer
    extends Composer<_$SqliteDb, $TrashesTable> {
  $$TrashesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<String> get originalLocation => $composableBuilder(
    column: $table.originalLocation,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime, DateTime> get deletionTime =>
      $composableBuilder(
        column: $table.deletionTime,
        builder: (column) => column,
      );

  $$FilesTableAnnotationComposer get file {
    final $$FilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.file,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableAnnotationComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrashesTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $TrashesTable,
          Trash,
          $$TrashesTableFilterComposer,
          $$TrashesTableOrderingComposer,
          $$TrashesTableAnnotationComposer,
          $$TrashesTableCreateCompanionBuilder,
          $$TrashesTableUpdateCompanionBuilder,
          (Trash, $$TrashesTableReferences),
          Trash,
          PrefetchHooks Function({bool file})
        > {
  $$TrashesTableTableManager(_$SqliteDb db, $TrashesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TrashesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TrashesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TrashesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> file = const Value.absent(),
                Value<String> filename = const Value.absent(),
                Value<String> originalLocation = const Value.absent(),
                Value<DateTime> deletionTime = const Value.absent(),
              }) => TrashesCompanion(
                file: file,
                filename: filename,
                originalLocation: originalLocation,
                deletionTime: deletionTime,
              ),
          createCompanionCallback:
              ({
                Value<int> file = const Value.absent(),
                required String filename,
                required String originalLocation,
                required DateTime deletionTime,
              }) => TrashesCompanion.insert(
                file: file,
                filename: filename,
                originalLocation: originalLocation,
                deletionTime: deletionTime,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TrashesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({file = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (file) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.file,
                            referencedTable: $$TrashesTableReferences
                                ._fileTable(db),
                            referencedColumn:
                                $$TrashesTableReferences._fileTable(db).rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrashesTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $TrashesTable,
      Trash,
      $$TrashesTableFilterComposer,
      $$TrashesTableOrderingComposer,
      $$TrashesTableAnnotationComposer,
      $$TrashesTableCreateCompanionBuilder,
      $$TrashesTableUpdateCompanionBuilder,
      (Trash, $$TrashesTableReferences),
      Trash,
      PrefetchHooks Function({bool file})
    >;
typedef $$DirFilesTableCreateCompanionBuilder =
    DirFilesCompanion Function({
      required int dir,
      required int child,
      Value<int> rowid,
    });
typedef $$DirFilesTableUpdateCompanionBuilder =
    DirFilesCompanion Function({
      Value<int> dir,
      Value<int> child,
      Value<int> rowid,
    });

final class $$DirFilesTableReferences
    extends BaseReferences<_$SqliteDb, $DirFilesTable, DirFile> {
  $$DirFilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FilesTable _dirTable(_$SqliteDb db) => db.files.createAlias(
    $_aliasNameGenerator(db.dirFiles.dir, db.files.rowId),
  );

  $$FilesTableProcessedTableManager get dir {
    final manager = $$FilesTableTableManager(
      $_db,
      $_db.files,
    ).filter((f) => f.rowId($_item.dir!));
    final item = $_typedResult.readTableOrNull(_dirTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FilesTable _childTable(_$SqliteDb db) => db.files.createAlias(
    $_aliasNameGenerator(db.dirFiles.child, db.files.rowId),
  );

  $$FilesTableProcessedTableManager get child {
    final manager = $$FilesTableTableManager(
      $_db,
      $_db.files,
    ).filter((f) => f.rowId($_item.child!));
    final item = $_typedResult.readTableOrNull(_childTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DirFilesTableFilterComposer
    extends Composer<_$SqliteDb, $DirFilesTable> {
  $$DirFilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FilesTableFilterComposer get dir {
    final $$FilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dir,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableFilterComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FilesTableFilterComposer get child {
    final $$FilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.child,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableFilterComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DirFilesTableOrderingComposer
    extends Composer<_$SqliteDb, $DirFilesTable> {
  $$DirFilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FilesTableOrderingComposer get dir {
    final $$FilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dir,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableOrderingComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FilesTableOrderingComposer get child {
    final $$FilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.child,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableOrderingComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DirFilesTableAnnotationComposer
    extends Composer<_$SqliteDb, $DirFilesTable> {
  $$DirFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FilesTableAnnotationComposer get dir {
    final $$FilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dir,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableAnnotationComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FilesTableAnnotationComposer get child {
    final $$FilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.child,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableAnnotationComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DirFilesTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $DirFilesTable,
          DirFile,
          $$DirFilesTableFilterComposer,
          $$DirFilesTableOrderingComposer,
          $$DirFilesTableAnnotationComposer,
          $$DirFilesTableCreateCompanionBuilder,
          $$DirFilesTableUpdateCompanionBuilder,
          (DirFile, $$DirFilesTableReferences),
          DirFile,
          PrefetchHooks Function({bool dir, bool child})
        > {
  $$DirFilesTableTableManager(_$SqliteDb db, $DirFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DirFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$DirFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$DirFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> dir = const Value.absent(),
                Value<int> child = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DirFilesCompanion(dir: dir, child: child, rowid: rowid),
          createCompanionCallback:
              ({
                required int dir,
                required int child,
                Value<int> rowid = const Value.absent(),
              }) => DirFilesCompanion.insert(
                dir: dir,
                child: child,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$DirFilesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({dir = false, child = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (dir) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.dir,
                            referencedTable: $$DirFilesTableReferences
                                ._dirTable(db),
                            referencedColumn:
                                $$DirFilesTableReferences._dirTable(db).rowId,
                          )
                          as T;
                }
                if (child) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.child,
                            referencedTable: $$DirFilesTableReferences
                                ._childTable(db),
                            referencedColumn:
                                $$DirFilesTableReferences._childTable(db).rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DirFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $DirFilesTable,
      DirFile,
      $$DirFilesTableFilterComposer,
      $$DirFilesTableOrderingComposer,
      $$DirFilesTableAnnotationComposer,
      $$DirFilesTableCreateCompanionBuilder,
      $$DirFilesTableUpdateCompanionBuilder,
      (DirFile, $$DirFilesTableReferences),
      DirFile,
      PrefetchHooks Function({bool dir, bool child})
    >;
typedef $$AlbumsTableCreateCompanionBuilder =
    AlbumsCompanion Function({
      Value<int> rowId,
      required int file,
      Value<String?> fileEtag,
      required int version,
      required DateTime lastUpdated,
      required String name,
      required String providerType,
      required String providerContent,
      required String coverProviderType,
      required String coverProviderContent,
      required String sortProviderType,
      required String sortProviderContent,
    });
typedef $$AlbumsTableUpdateCompanionBuilder =
    AlbumsCompanion Function({
      Value<int> rowId,
      Value<int> file,
      Value<String?> fileEtag,
      Value<int> version,
      Value<DateTime> lastUpdated,
      Value<String> name,
      Value<String> providerType,
      Value<String> providerContent,
      Value<String> coverProviderType,
      Value<String> coverProviderContent,
      Value<String> sortProviderType,
      Value<String> sortProviderContent,
    });

final class $$AlbumsTableReferences
    extends BaseReferences<_$SqliteDb, $AlbumsTable, Album> {
  $$AlbumsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FilesTable _fileTable(_$SqliteDb db) => db.files.createAlias(
    $_aliasNameGenerator(db.albums.file, db.files.rowId),
  );

  $$FilesTableProcessedTableManager get file {
    final manager = $$FilesTableTableManager(
      $_db,
      $_db.files,
    ).filter((f) => f.rowId($_item.file!));
    final item = $_typedResult.readTableOrNull(_fileTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AlbumSharesTable, List<AlbumShare>>
  _albumSharesRefsTable(_$SqliteDb db) => MultiTypedResultKey.fromTable(
    db.albumShares,
    aliasName: $_aliasNameGenerator(db.albums.rowId, db.albumShares.album),
  );

  $$AlbumSharesTableProcessedTableManager get albumSharesRefs {
    final manager = $$AlbumSharesTableTableManager(
      $_db,
      $_db.albumShares,
    ).filter((f) => f.album.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_albumSharesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AlbumsTableFilterComposer extends Composer<_$SqliteDb, $AlbumsTable> {
  $$AlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileEtag => $composableBuilder(
    column: $table.fileEtag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime>
  get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get providerContent => $composableBuilder(
    column: $table.providerContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverProviderType => $composableBuilder(
    column: $table.coverProviderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverProviderContent => $composableBuilder(
    column: $table.coverProviderContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortProviderType => $composableBuilder(
    column: $table.sortProviderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortProviderContent => $composableBuilder(
    column: $table.sortProviderContent,
    builder: (column) => ColumnFilters(column),
  );

  $$FilesTableFilterComposer get file {
    final $$FilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.file,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableFilterComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> albumSharesRefs(
    Expression<bool> Function($$AlbumSharesTableFilterComposer f) f,
  ) {
    final $$AlbumSharesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.albumShares,
      getReferencedColumn: (t) => t.album,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumSharesTableFilterComposer(
            $db: $db,
            $table: $db.albumShares,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlbumsTableOrderingComposer extends Composer<_$SqliteDb, $AlbumsTable> {
  $$AlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileEtag => $composableBuilder(
    column: $table.fileEtag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get providerContent => $composableBuilder(
    column: $table.providerContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverProviderType => $composableBuilder(
    column: $table.coverProviderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverProviderContent => $composableBuilder(
    column: $table.coverProviderContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortProviderType => $composableBuilder(
    column: $table.sortProviderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortProviderContent => $composableBuilder(
    column: $table.sortProviderContent,
    builder: (column) => ColumnOrderings(column),
  );

  $$FilesTableOrderingComposer get file {
    final $$FilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.file,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableOrderingComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlbumsTableAnnotationComposer
    extends Composer<_$SqliteDb, $AlbumsTable> {
  $$AlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get fileEtag =>
      $composableBuilder(column: $table.fileEtag, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, DateTime> get lastUpdated =>
      $composableBuilder(
        column: $table.lastUpdated,
        builder: (column) => column,
      );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get providerType => $composableBuilder(
    column: $table.providerType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get providerContent => $composableBuilder(
    column: $table.providerContent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverProviderType => $composableBuilder(
    column: $table.coverProviderType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverProviderContent => $composableBuilder(
    column: $table.coverProviderContent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sortProviderType => $composableBuilder(
    column: $table.sortProviderType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sortProviderContent => $composableBuilder(
    column: $table.sortProviderContent,
    builder: (column) => column,
  );

  $$FilesTableAnnotationComposer get file {
    final $$FilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.file,
      referencedTable: $db.files,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FilesTableAnnotationComposer(
            $db: $db,
            $table: $db.files,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> albumSharesRefs<T extends Object>(
    Expression<T> Function($$AlbumSharesTableAnnotationComposer a) f,
  ) {
    final $$AlbumSharesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.albumShares,
      getReferencedColumn: (t) => t.album,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumSharesTableAnnotationComposer(
            $db: $db,
            $table: $db.albumShares,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlbumsTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $AlbumsTable,
          Album,
          $$AlbumsTableFilterComposer,
          $$AlbumsTableOrderingComposer,
          $$AlbumsTableAnnotationComposer,
          $$AlbumsTableCreateCompanionBuilder,
          $$AlbumsTableUpdateCompanionBuilder,
          (Album, $$AlbumsTableReferences),
          Album,
          PrefetchHooks Function({bool file, bool albumSharesRefs})
        > {
  $$AlbumsTableTableManager(_$SqliteDb db, $AlbumsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<int> file = const Value.absent(),
                Value<String?> fileEtag = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> providerType = const Value.absent(),
                Value<String> providerContent = const Value.absent(),
                Value<String> coverProviderType = const Value.absent(),
                Value<String> coverProviderContent = const Value.absent(),
                Value<String> sortProviderType = const Value.absent(),
                Value<String> sortProviderContent = const Value.absent(),
              }) => AlbumsCompanion(
                rowId: rowId,
                file: file,
                fileEtag: fileEtag,
                version: version,
                lastUpdated: lastUpdated,
                name: name,
                providerType: providerType,
                providerContent: providerContent,
                coverProviderType: coverProviderType,
                coverProviderContent: coverProviderContent,
                sortProviderType: sortProviderType,
                sortProviderContent: sortProviderContent,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required int file,
                Value<String?> fileEtag = const Value.absent(),
                required int version,
                required DateTime lastUpdated,
                required String name,
                required String providerType,
                required String providerContent,
                required String coverProviderType,
                required String coverProviderContent,
                required String sortProviderType,
                required String sortProviderContent,
              }) => AlbumsCompanion.insert(
                rowId: rowId,
                file: file,
                fileEtag: fileEtag,
                version: version,
                lastUpdated: lastUpdated,
                name: name,
                providerType: providerType,
                providerContent: providerContent,
                coverProviderType: coverProviderType,
                coverProviderContent: coverProviderContent,
                sortProviderType: sortProviderType,
                sortProviderContent: sortProviderContent,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AlbumsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({file = false, albumSharesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (albumSharesRefs) db.albumShares],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (file) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.file,
                            referencedTable: $$AlbumsTableReferences._fileTable(
                              db,
                            ),
                            referencedColumn:
                                $$AlbumsTableReferences._fileTable(db).rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (albumSharesRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$AlbumsTableReferences
                          ._albumSharesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AlbumsTableReferences(
                                db,
                                table,
                                p0,
                              ).albumSharesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.album == item.rowId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AlbumsTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $AlbumsTable,
      Album,
      $$AlbumsTableFilterComposer,
      $$AlbumsTableOrderingComposer,
      $$AlbumsTableAnnotationComposer,
      $$AlbumsTableCreateCompanionBuilder,
      $$AlbumsTableUpdateCompanionBuilder,
      (Album, $$AlbumsTableReferences),
      Album,
      PrefetchHooks Function({bool file, bool albumSharesRefs})
    >;
typedef $$AlbumSharesTableCreateCompanionBuilder =
    AlbumSharesCompanion Function({
      required int album,
      required String userId,
      Value<String?> displayName,
      required DateTime sharedAt,
      Value<int> rowid,
    });
typedef $$AlbumSharesTableUpdateCompanionBuilder =
    AlbumSharesCompanion Function({
      Value<int> album,
      Value<String> userId,
      Value<String?> displayName,
      Value<DateTime> sharedAt,
      Value<int> rowid,
    });

final class $$AlbumSharesTableReferences
    extends BaseReferences<_$SqliteDb, $AlbumSharesTable, AlbumShare> {
  $$AlbumSharesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AlbumsTable _albumTable(_$SqliteDb db) => db.albums.createAlias(
    $_aliasNameGenerator(db.albumShares.album, db.albums.rowId),
  );

  $$AlbumsTableProcessedTableManager get album {
    final manager = $$AlbumsTableTableManager(
      $_db,
      $_db.albums,
    ).filter((f) => f.rowId($_item.album!));
    final item = $_typedResult.readTableOrNull(_albumTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AlbumSharesTableFilterComposer
    extends Composer<_$SqliteDb, $AlbumSharesTable> {
  $$AlbumSharesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, DateTime> get sharedAt =>
      $composableBuilder(
        column: $table.sharedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$AlbumsTableFilterComposer get album {
    final $$AlbumsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.album,
      referencedTable: $db.albums,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumsTableFilterComposer(
            $db: $db,
            $table: $db.albums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlbumSharesTableOrderingComposer
    extends Composer<_$SqliteDb, $AlbumSharesTable> {
  $$AlbumSharesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sharedAt => $composableBuilder(
    column: $table.sharedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AlbumsTableOrderingComposer get album {
    final $$AlbumsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.album,
      referencedTable: $db.albums,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumsTableOrderingComposer(
            $db: $db,
            $table: $db.albums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlbumSharesTableAnnotationComposer
    extends Composer<_$SqliteDb, $AlbumSharesTable> {
  $$AlbumSharesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime, DateTime> get sharedAt =>
      $composableBuilder(column: $table.sharedAt, builder: (column) => column);

  $$AlbumsTableAnnotationComposer get album {
    final $$AlbumsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.album,
      referencedTable: $db.albums,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlbumsTableAnnotationComposer(
            $db: $db,
            $table: $db.albums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlbumSharesTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $AlbumSharesTable,
          AlbumShare,
          $$AlbumSharesTableFilterComposer,
          $$AlbumSharesTableOrderingComposer,
          $$AlbumSharesTableAnnotationComposer,
          $$AlbumSharesTableCreateCompanionBuilder,
          $$AlbumSharesTableUpdateCompanionBuilder,
          (AlbumShare, $$AlbumSharesTableReferences),
          AlbumShare,
          PrefetchHooks Function({bool album})
        > {
  $$AlbumSharesTableTableManager(_$SqliteDb db, $AlbumSharesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AlbumSharesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AlbumSharesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$AlbumSharesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> album = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<DateTime> sharedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlbumSharesCompanion(
                album: album,
                userId: userId,
                displayName: displayName,
                sharedAt: sharedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int album,
                required String userId,
                Value<String?> displayName = const Value.absent(),
                required DateTime sharedAt,
                Value<int> rowid = const Value.absent(),
              }) => AlbumSharesCompanion.insert(
                album: album,
                userId: userId,
                displayName: displayName,
                sharedAt: sharedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AlbumSharesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({album = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (album) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.album,
                            referencedTable: $$AlbumSharesTableReferences
                                ._albumTable(db),
                            referencedColumn:
                                $$AlbumSharesTableReferences
                                    ._albumTable(db)
                                    .rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AlbumSharesTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $AlbumSharesTable,
      AlbumShare,
      $$AlbumSharesTableFilterComposer,
      $$AlbumSharesTableOrderingComposer,
      $$AlbumSharesTableAnnotationComposer,
      $$AlbumSharesTableCreateCompanionBuilder,
      $$AlbumSharesTableUpdateCompanionBuilder,
      (AlbumShare, $$AlbumSharesTableReferences),
      AlbumShare,
      PrefetchHooks Function({bool album})
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      Value<int> rowId,
      required int server,
      required int tagId,
      required String displayName,
      Value<bool?> userVisible,
      Value<bool?> userAssignable,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<int> rowId,
      Value<int> server,
      Value<int> tagId,
      Value<String> displayName,
      Value<bool?> userVisible,
      Value<bool?> userAssignable,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$SqliteDb, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServersTable _serverTable(_$SqliteDb db) => db.servers.createAlias(
    $_aliasNameGenerator(db.tags.server, db.servers.rowId),
  );

  $$ServersTableProcessedTableManager get server {
    final manager = $$ServersTableTableManager(
      $_db,
      $_db.servers,
    ).filter((f) => f.rowId($_item.server!));
    final item = $_typedResult.readTableOrNull(_serverTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$SqliteDb, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userVisible => $composableBuilder(
    column: $table.userVisible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get userAssignable => $composableBuilder(
    column: $table.userAssignable,
    builder: (column) => ColumnFilters(column),
  );

  $$ServersTableFilterComposer get server {
    final $$ServersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.server,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableFilterComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagsTableOrderingComposer extends Composer<_$SqliteDb, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userVisible => $composableBuilder(
    column: $table.userVisible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get userAssignable => $composableBuilder(
    column: $table.userAssignable,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServersTableOrderingComposer get server {
    final $$ServersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.server,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableOrderingComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagsTableAnnotationComposer extends Composer<_$SqliteDb, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<int> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get userVisible => $composableBuilder(
    column: $table.userVisible,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get userAssignable => $composableBuilder(
    column: $table.userAssignable,
    builder: (column) => column,
  );

  $$ServersTableAnnotationComposer get server {
    final $$ServersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.server,
      referencedTable: $db.servers,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServersTableAnnotationComposer(
            $db: $db,
            $table: $db.servers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool server})
        > {
  $$TagsTableTableManager(_$SqliteDb db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<int> server = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<bool?> userVisible = const Value.absent(),
                Value<bool?> userAssignable = const Value.absent(),
              }) => TagsCompanion(
                rowId: rowId,
                server: server,
                tagId: tagId,
                displayName: displayName,
                userVisible: userVisible,
                userAssignable: userAssignable,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required int server,
                required int tagId,
                required String displayName,
                Value<bool?> userVisible = const Value.absent(),
                Value<bool?> userAssignable = const Value.absent(),
              }) => TagsCompanion.insert(
                rowId: rowId,
                server: server,
                tagId: tagId,
                displayName: displayName,
                userVisible: userVisible,
                userAssignable: userAssignable,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TagsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({server = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (server) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.server,
                            referencedTable: $$TagsTableReferences._serverTable(
                              db,
                            ),
                            referencedColumn:
                                $$TagsTableReferences._serverTable(db).rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool server})
    >;
typedef $$FaceRecognitionPersonsTableCreateCompanionBuilder =
    FaceRecognitionPersonsCompanion Function({
      Value<int> rowId,
      required int account,
      required String name,
      required int thumbFaceId,
      required int count,
    });
typedef $$FaceRecognitionPersonsTableUpdateCompanionBuilder =
    FaceRecognitionPersonsCompanion Function({
      Value<int> rowId,
      Value<int> account,
      Value<String> name,
      Value<int> thumbFaceId,
      Value<int> count,
    });

final class $$FaceRecognitionPersonsTableReferences
    extends
        BaseReferences<
          _$SqliteDb,
          $FaceRecognitionPersonsTable,
          FaceRecognitionPerson
        > {
  $$FaceRecognitionPersonsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountTable(_$SqliteDb db) => db.accounts.createAlias(
    $_aliasNameGenerator(db.faceRecognitionPersons.account, db.accounts.rowId),
  );

  $$AccountsTableProcessedTableManager get account {
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.rowId($_item.account!));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FaceRecognitionPersonsTableFilterComposer
    extends Composer<_$SqliteDb, $FaceRecognitionPersonsTable> {
  $$FaceRecognitionPersonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get thumbFaceId => $composableBuilder(
    column: $table.thumbFaceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get account {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FaceRecognitionPersonsTableOrderingComposer
    extends Composer<_$SqliteDb, $FaceRecognitionPersonsTable> {
  $$FaceRecognitionPersonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get thumbFaceId => $composableBuilder(
    column: $table.thumbFaceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get account {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FaceRecognitionPersonsTableAnnotationComposer
    extends Composer<_$SqliteDb, $FaceRecognitionPersonsTable> {
  $$FaceRecognitionPersonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get thumbFaceId => $composableBuilder(
    column: $table.thumbFaceId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  $$AccountsTableAnnotationComposer get account {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FaceRecognitionPersonsTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $FaceRecognitionPersonsTable,
          FaceRecognitionPerson,
          $$FaceRecognitionPersonsTableFilterComposer,
          $$FaceRecognitionPersonsTableOrderingComposer,
          $$FaceRecognitionPersonsTableAnnotationComposer,
          $$FaceRecognitionPersonsTableCreateCompanionBuilder,
          $$FaceRecognitionPersonsTableUpdateCompanionBuilder,
          (FaceRecognitionPerson, $$FaceRecognitionPersonsTableReferences),
          FaceRecognitionPerson,
          PrefetchHooks Function({bool account})
        > {
  $$FaceRecognitionPersonsTableTableManager(
    _$SqliteDb db,
    $FaceRecognitionPersonsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$FaceRecognitionPersonsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$FaceRecognitionPersonsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$FaceRecognitionPersonsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<int> account = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> thumbFaceId = const Value.absent(),
                Value<int> count = const Value.absent(),
              }) => FaceRecognitionPersonsCompanion(
                rowId: rowId,
                account: account,
                name: name,
                thumbFaceId: thumbFaceId,
                count: count,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required int account,
                required String name,
                required int thumbFaceId,
                required int count,
              }) => FaceRecognitionPersonsCompanion.insert(
                rowId: rowId,
                account: account,
                name: name,
                thumbFaceId: thumbFaceId,
                count: count,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$FaceRecognitionPersonsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({account = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (account) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.account,
                            referencedTable:
                                $$FaceRecognitionPersonsTableReferences
                                    ._accountTable(db),
                            referencedColumn:
                                $$FaceRecognitionPersonsTableReferences
                                    ._accountTable(db)
                                    .rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FaceRecognitionPersonsTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $FaceRecognitionPersonsTable,
      FaceRecognitionPerson,
      $$FaceRecognitionPersonsTableFilterComposer,
      $$FaceRecognitionPersonsTableOrderingComposer,
      $$FaceRecognitionPersonsTableAnnotationComposer,
      $$FaceRecognitionPersonsTableCreateCompanionBuilder,
      $$FaceRecognitionPersonsTableUpdateCompanionBuilder,
      (FaceRecognitionPerson, $$FaceRecognitionPersonsTableReferences),
      FaceRecognitionPerson,
      PrefetchHooks Function({bool account})
    >;
typedef $$NcAlbumsTableCreateCompanionBuilder =
    NcAlbumsCompanion Function({
      Value<int> rowId,
      required int account,
      required String relativePath,
      Value<int?> lastPhoto,
      required int nbItems,
      Value<String?> location,
      Value<DateTime?> dateStart,
      Value<DateTime?> dateEnd,
      required String collaborators,
      required bool isOwned,
    });
typedef $$NcAlbumsTableUpdateCompanionBuilder =
    NcAlbumsCompanion Function({
      Value<int> rowId,
      Value<int> account,
      Value<String> relativePath,
      Value<int?> lastPhoto,
      Value<int> nbItems,
      Value<String?> location,
      Value<DateTime?> dateStart,
      Value<DateTime?> dateEnd,
      Value<String> collaborators,
      Value<bool> isOwned,
    });

final class $$NcAlbumsTableReferences
    extends BaseReferences<_$SqliteDb, $NcAlbumsTable, NcAlbum> {
  $$NcAlbumsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountTable(_$SqliteDb db) => db.accounts.createAlias(
    $_aliasNameGenerator(db.ncAlbums.account, db.accounts.rowId),
  );

  $$AccountsTableProcessedTableManager get account {
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.rowId($_item.account!));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$NcAlbumItemsTable, List<NcAlbumItem>>
  _ncAlbumItemsRefsTable(_$SqliteDb db) => MultiTypedResultKey.fromTable(
    db.ncAlbumItems,
    aliasName: $_aliasNameGenerator(db.ncAlbums.rowId, db.ncAlbumItems.parent),
  );

  $$NcAlbumItemsTableProcessedTableManager get ncAlbumItemsRefs {
    final manager = $$NcAlbumItemsTableTableManager(
      $_db,
      $_db.ncAlbumItems,
    ).filter((f) => f.parent.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(_ncAlbumItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NcAlbumsTableFilterComposer
    extends Composer<_$SqliteDb, $NcAlbumsTable> {
  $$NcAlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPhoto => $composableBuilder(
    column: $table.lastPhoto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nbItems => $composableBuilder(
    column: $table.nbItems,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, DateTime> get dateStart =>
      $composableBuilder(
        column: $table.dateStart,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, DateTime> get dateEnd =>
      $composableBuilder(
        column: $table.dateEnd,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get collaborators => $composableBuilder(
    column: $table.collaborators,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOwned => $composableBuilder(
    column: $table.isOwned,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get account {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ncAlbumItemsRefs(
    Expression<bool> Function($$NcAlbumItemsTableFilterComposer f) f,
  ) {
    final $$NcAlbumItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.ncAlbumItems,
      getReferencedColumn: (t) => t.parent,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NcAlbumItemsTableFilterComposer(
            $db: $db,
            $table: $db.ncAlbumItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NcAlbumsTableOrderingComposer
    extends Composer<_$SqliteDb, $NcAlbumsTable> {
  $$NcAlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPhoto => $composableBuilder(
    column: $table.lastPhoto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nbItems => $composableBuilder(
    column: $table.nbItems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateStart => $composableBuilder(
    column: $table.dateStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateEnd => $composableBuilder(
    column: $table.dateEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collaborators => $composableBuilder(
    column: $table.collaborators,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOwned => $composableBuilder(
    column: $table.isOwned,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get account {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NcAlbumsTableAnnotationComposer
    extends Composer<_$SqliteDb, $NcAlbumsTable> {
  $$NcAlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastPhoto =>
      $composableBuilder(column: $table.lastPhoto, builder: (column) => column);

  GeneratedColumn<int> get nbItems =>
      $composableBuilder(column: $table.nbItems, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, DateTime> get dateStart =>
      $composableBuilder(column: $table.dateStart, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, DateTime> get dateEnd =>
      $composableBuilder(column: $table.dateEnd, builder: (column) => column);

  GeneratedColumn<String> get collaborators => $composableBuilder(
    column: $table.collaborators,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOwned =>
      $composableBuilder(column: $table.isOwned, builder: (column) => column);

  $$AccountsTableAnnotationComposer get account {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ncAlbumItemsRefs<T extends Object>(
    Expression<T> Function($$NcAlbumItemsTableAnnotationComposer a) f,
  ) {
    final $$NcAlbumItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.ncAlbumItems,
      getReferencedColumn: (t) => t.parent,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NcAlbumItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.ncAlbumItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NcAlbumsTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $NcAlbumsTable,
          NcAlbum,
          $$NcAlbumsTableFilterComposer,
          $$NcAlbumsTableOrderingComposer,
          $$NcAlbumsTableAnnotationComposer,
          $$NcAlbumsTableCreateCompanionBuilder,
          $$NcAlbumsTableUpdateCompanionBuilder,
          (NcAlbum, $$NcAlbumsTableReferences),
          NcAlbum,
          PrefetchHooks Function({bool account, bool ncAlbumItemsRefs})
        > {
  $$NcAlbumsTableTableManager(_$SqliteDb db, $NcAlbumsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$NcAlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$NcAlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$NcAlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<int> account = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<int?> lastPhoto = const Value.absent(),
                Value<int> nbItems = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<DateTime?> dateStart = const Value.absent(),
                Value<DateTime?> dateEnd = const Value.absent(),
                Value<String> collaborators = const Value.absent(),
                Value<bool> isOwned = const Value.absent(),
              }) => NcAlbumsCompanion(
                rowId: rowId,
                account: account,
                relativePath: relativePath,
                lastPhoto: lastPhoto,
                nbItems: nbItems,
                location: location,
                dateStart: dateStart,
                dateEnd: dateEnd,
                collaborators: collaborators,
                isOwned: isOwned,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required int account,
                required String relativePath,
                Value<int?> lastPhoto = const Value.absent(),
                required int nbItems,
                Value<String?> location = const Value.absent(),
                Value<DateTime?> dateStart = const Value.absent(),
                Value<DateTime?> dateEnd = const Value.absent(),
                required String collaborators,
                required bool isOwned,
              }) => NcAlbumsCompanion.insert(
                rowId: rowId,
                account: account,
                relativePath: relativePath,
                lastPhoto: lastPhoto,
                nbItems: nbItems,
                location: location,
                dateStart: dateStart,
                dateEnd: dateEnd,
                collaborators: collaborators,
                isOwned: isOwned,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$NcAlbumsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({account = false, ncAlbumItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ncAlbumItemsRefs) db.ncAlbumItems],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (account) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.account,
                            referencedTable: $$NcAlbumsTableReferences
                                ._accountTable(db),
                            referencedColumn:
                                $$NcAlbumsTableReferences
                                    ._accountTable(db)
                                    .rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ncAlbumItemsRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$NcAlbumsTableReferences
                          ._ncAlbumItemsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$NcAlbumsTableReferences(
                                db,
                                table,
                                p0,
                              ).ncAlbumItemsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.parent == item.rowId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$NcAlbumsTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $NcAlbumsTable,
      NcAlbum,
      $$NcAlbumsTableFilterComposer,
      $$NcAlbumsTableOrderingComposer,
      $$NcAlbumsTableAnnotationComposer,
      $$NcAlbumsTableCreateCompanionBuilder,
      $$NcAlbumsTableUpdateCompanionBuilder,
      (NcAlbum, $$NcAlbumsTableReferences),
      NcAlbum,
      PrefetchHooks Function({bool account, bool ncAlbumItemsRefs})
    >;
typedef $$NcAlbumItemsTableCreateCompanionBuilder =
    NcAlbumItemsCompanion Function({
      Value<int> rowId,
      required int parent,
      required String relativePath,
      required int fileId,
      Value<int?> contentLength,
      Value<String?> contentType,
      Value<String?> etag,
      Value<DateTime?> lastModified,
      Value<bool?> hasPreview,
      Value<bool?> isFavorite,
      Value<int?> fileMetadataWidth,
      Value<int?> fileMetadataHeight,
    });
typedef $$NcAlbumItemsTableUpdateCompanionBuilder =
    NcAlbumItemsCompanion Function({
      Value<int> rowId,
      Value<int> parent,
      Value<String> relativePath,
      Value<int> fileId,
      Value<int?> contentLength,
      Value<String?> contentType,
      Value<String?> etag,
      Value<DateTime?> lastModified,
      Value<bool?> hasPreview,
      Value<bool?> isFavorite,
      Value<int?> fileMetadataWidth,
      Value<int?> fileMetadataHeight,
    });

final class $$NcAlbumItemsTableReferences
    extends BaseReferences<_$SqliteDb, $NcAlbumItemsTable, NcAlbumItem> {
  $$NcAlbumItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NcAlbumsTable _parentTable(_$SqliteDb db) => db.ncAlbums.createAlias(
    $_aliasNameGenerator(db.ncAlbumItems.parent, db.ncAlbums.rowId),
  );

  $$NcAlbumsTableProcessedTableManager get parent {
    final manager = $$NcAlbumsTableTableManager(
      $_db,
      $_db.ncAlbums,
    ).filter((f) => f.rowId($_item.parent!));
    final item = $_typedResult.readTableOrNull(_parentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NcAlbumItemsTableFilterComposer
    extends Composer<_$SqliteDb, $NcAlbumItemsTable> {
  $$NcAlbumItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentLength => $composableBuilder(
    column: $table.contentLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, DateTime>
  get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get hasPreview => $composableBuilder(
    column: $table.hasPreview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileMetadataWidth => $composableBuilder(
    column: $table.fileMetadataWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileMetadataHeight => $composableBuilder(
    column: $table.fileMetadataHeight,
    builder: (column) => ColumnFilters(column),
  );

  $$NcAlbumsTableFilterComposer get parent {
    final $$NcAlbumsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parent,
      referencedTable: $db.ncAlbums,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NcAlbumsTableFilterComposer(
            $db: $db,
            $table: $db.ncAlbums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NcAlbumItemsTableOrderingComposer
    extends Composer<_$SqliteDb, $NcAlbumItemsTable> {
  $$NcAlbumItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentLength => $composableBuilder(
    column: $table.contentLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasPreview => $composableBuilder(
    column: $table.hasPreview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileMetadataWidth => $composableBuilder(
    column: $table.fileMetadataWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileMetadataHeight => $composableBuilder(
    column: $table.fileMetadataHeight,
    builder: (column) => ColumnOrderings(column),
  );

  $$NcAlbumsTableOrderingComposer get parent {
    final $$NcAlbumsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parent,
      referencedTable: $db.ncAlbums,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NcAlbumsTableOrderingComposer(
            $db: $db,
            $table: $db.ncAlbums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NcAlbumItemsTableAnnotationComposer
    extends Composer<_$SqliteDb, $NcAlbumItemsTable> {
  $$NcAlbumItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileId =>
      $composableBuilder(column: $table.fileId, builder: (column) => column);

  GeneratedColumn<int> get contentLength => $composableBuilder(
    column: $table.contentLength,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, DateTime> get lastModified =>
      $composableBuilder(
        column: $table.lastModified,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get hasPreview => $composableBuilder(
    column: $table.hasPreview,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileMetadataWidth => $composableBuilder(
    column: $table.fileMetadataWidth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileMetadataHeight => $composableBuilder(
    column: $table.fileMetadataHeight,
    builder: (column) => column,
  );

  $$NcAlbumsTableAnnotationComposer get parent {
    final $$NcAlbumsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parent,
      referencedTable: $db.ncAlbums,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NcAlbumsTableAnnotationComposer(
            $db: $db,
            $table: $db.ncAlbums,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NcAlbumItemsTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $NcAlbumItemsTable,
          NcAlbumItem,
          $$NcAlbumItemsTableFilterComposer,
          $$NcAlbumItemsTableOrderingComposer,
          $$NcAlbumItemsTableAnnotationComposer,
          $$NcAlbumItemsTableCreateCompanionBuilder,
          $$NcAlbumItemsTableUpdateCompanionBuilder,
          (NcAlbumItem, $$NcAlbumItemsTableReferences),
          NcAlbumItem,
          PrefetchHooks Function({bool parent})
        > {
  $$NcAlbumItemsTableTableManager(_$SqliteDb db, $NcAlbumItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$NcAlbumItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$NcAlbumItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$NcAlbumItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<int> parent = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<int> fileId = const Value.absent(),
                Value<int?> contentLength = const Value.absent(),
                Value<String?> contentType = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<DateTime?> lastModified = const Value.absent(),
                Value<bool?> hasPreview = const Value.absent(),
                Value<bool?> isFavorite = const Value.absent(),
                Value<int?> fileMetadataWidth = const Value.absent(),
                Value<int?> fileMetadataHeight = const Value.absent(),
              }) => NcAlbumItemsCompanion(
                rowId: rowId,
                parent: parent,
                relativePath: relativePath,
                fileId: fileId,
                contentLength: contentLength,
                contentType: contentType,
                etag: etag,
                lastModified: lastModified,
                hasPreview: hasPreview,
                isFavorite: isFavorite,
                fileMetadataWidth: fileMetadataWidth,
                fileMetadataHeight: fileMetadataHeight,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required int parent,
                required String relativePath,
                required int fileId,
                Value<int?> contentLength = const Value.absent(),
                Value<String?> contentType = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<DateTime?> lastModified = const Value.absent(),
                Value<bool?> hasPreview = const Value.absent(),
                Value<bool?> isFavorite = const Value.absent(),
                Value<int?> fileMetadataWidth = const Value.absent(),
                Value<int?> fileMetadataHeight = const Value.absent(),
              }) => NcAlbumItemsCompanion.insert(
                rowId: rowId,
                parent: parent,
                relativePath: relativePath,
                fileId: fileId,
                contentLength: contentLength,
                contentType: contentType,
                etag: etag,
                lastModified: lastModified,
                hasPreview: hasPreview,
                isFavorite: isFavorite,
                fileMetadataWidth: fileMetadataWidth,
                fileMetadataHeight: fileMetadataHeight,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$NcAlbumItemsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({parent = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (parent) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.parent,
                            referencedTable: $$NcAlbumItemsTableReferences
                                ._parentTable(db),
                            referencedColumn:
                                $$NcAlbumItemsTableReferences
                                    ._parentTable(db)
                                    .rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NcAlbumItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $NcAlbumItemsTable,
      NcAlbumItem,
      $$NcAlbumItemsTableFilterComposer,
      $$NcAlbumItemsTableOrderingComposer,
      $$NcAlbumItemsTableAnnotationComposer,
      $$NcAlbumItemsTableCreateCompanionBuilder,
      $$NcAlbumItemsTableUpdateCompanionBuilder,
      (NcAlbumItem, $$NcAlbumItemsTableReferences),
      NcAlbumItem,
      PrefetchHooks Function({bool parent})
    >;
typedef $$RecognizeFacesTableCreateCompanionBuilder =
    RecognizeFacesCompanion Function({
      Value<int> rowId,
      required int account,
      required String label,
    });
typedef $$RecognizeFacesTableUpdateCompanionBuilder =
    RecognizeFacesCompanion Function({
      Value<int> rowId,
      Value<int> account,
      Value<String> label,
    });

final class $$RecognizeFacesTableReferences
    extends BaseReferences<_$SqliteDb, $RecognizeFacesTable, RecognizeFace> {
  $$RecognizeFacesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountTable(_$SqliteDb db) => db.accounts.createAlias(
    $_aliasNameGenerator(db.recognizeFaces.account, db.accounts.rowId),
  );

  $$AccountsTableProcessedTableManager get account {
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.rowId($_item.account!));
    final item = $_typedResult.readTableOrNull(_accountTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RecognizeFaceItemsTable, List<RecognizeFaceItem>>
  _recognizeFaceItemsRefsTable(_$SqliteDb db) => MultiTypedResultKey.fromTable(
    db.recognizeFaceItems,
    aliasName: $_aliasNameGenerator(
      db.recognizeFaces.rowId,
      db.recognizeFaceItems.parent,
    ),
  );

  $$RecognizeFaceItemsTableProcessedTableManager get recognizeFaceItemsRefs {
    final manager = $$RecognizeFaceItemsTableTableManager(
      $_db,
      $_db.recognizeFaceItems,
    ).filter((f) => f.parent.rowId($_item.rowId));

    final cache = $_typedResult.readTableOrNull(
      _recognizeFaceItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecognizeFacesTableFilterComposer
    extends Composer<_$SqliteDb, $RecognizeFacesTable> {
  $$RecognizeFacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get account {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recognizeFaceItemsRefs(
    Expression<bool> Function($$RecognizeFaceItemsTableFilterComposer f) f,
  ) {
    final $$RecognizeFaceItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rowId,
      referencedTable: $db.recognizeFaceItems,
      getReferencedColumn: (t) => t.parent,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecognizeFaceItemsTableFilterComposer(
            $db: $db,
            $table: $db.recognizeFaceItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecognizeFacesTableOrderingComposer
    extends Composer<_$SqliteDb, $RecognizeFacesTable> {
  $$RecognizeFacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get account {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecognizeFacesTableAnnotationComposer
    extends Composer<_$SqliteDb, $RecognizeFacesTable> {
  $$RecognizeFacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  $$AccountsTableAnnotationComposer get account {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.account,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recognizeFaceItemsRefs<T extends Object>(
    Expression<T> Function($$RecognizeFaceItemsTableAnnotationComposer a) f,
  ) {
    final $$RecognizeFaceItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.rowId,
          referencedTable: $db.recognizeFaceItems,
          getReferencedColumn: (t) => t.parent,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecognizeFaceItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.recognizeFaceItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RecognizeFacesTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $RecognizeFacesTable,
          RecognizeFace,
          $$RecognizeFacesTableFilterComposer,
          $$RecognizeFacesTableOrderingComposer,
          $$RecognizeFacesTableAnnotationComposer,
          $$RecognizeFacesTableCreateCompanionBuilder,
          $$RecognizeFacesTableUpdateCompanionBuilder,
          (RecognizeFace, $$RecognizeFacesTableReferences),
          RecognizeFace,
          PrefetchHooks Function({bool account, bool recognizeFaceItemsRefs})
        > {
  $$RecognizeFacesTableTableManager(_$SqliteDb db, $RecognizeFacesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RecognizeFacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$RecognizeFacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$RecognizeFacesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<int> account = const Value.absent(),
                Value<String> label = const Value.absent(),
              }) => RecognizeFacesCompanion(
                rowId: rowId,
                account: account,
                label: label,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required int account,
                required String label,
              }) => RecognizeFacesCompanion.insert(
                rowId: rowId,
                account: account,
                label: label,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$RecognizeFacesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            account = false,
            recognizeFaceItemsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recognizeFaceItemsRefs) db.recognizeFaceItems,
              ],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (account) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.account,
                            referencedTable: $$RecognizeFacesTableReferences
                                ._accountTable(db),
                            referencedColumn:
                                $$RecognizeFacesTableReferences
                                    ._accountTable(db)
                                    .rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recognizeFaceItemsRefs)
                    await $_getPrefetchedData(
                      currentTable: table,
                      referencedTable: $$RecognizeFacesTableReferences
                          ._recognizeFaceItemsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$RecognizeFacesTableReferences(
                                db,
                                table,
                                p0,
                              ).recognizeFaceItemsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.parent == item.rowId,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RecognizeFacesTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $RecognizeFacesTable,
      RecognizeFace,
      $$RecognizeFacesTableFilterComposer,
      $$RecognizeFacesTableOrderingComposer,
      $$RecognizeFacesTableAnnotationComposer,
      $$RecognizeFacesTableCreateCompanionBuilder,
      $$RecognizeFacesTableUpdateCompanionBuilder,
      (RecognizeFace, $$RecognizeFacesTableReferences),
      RecognizeFace,
      PrefetchHooks Function({bool account, bool recognizeFaceItemsRefs})
    >;
typedef $$RecognizeFaceItemsTableCreateCompanionBuilder =
    RecognizeFaceItemsCompanion Function({
      Value<int> rowId,
      required int parent,
      required String relativePath,
      required int fileId,
      Value<int?> contentLength,
      Value<String?> contentType,
      Value<String?> etag,
      Value<DateTime?> lastModified,
      Value<bool?> hasPreview,
      Value<String?> realPath,
      Value<bool?> isFavorite,
      Value<int?> fileMetadataWidth,
      Value<int?> fileMetadataHeight,
      Value<String?> faceDetections,
    });
typedef $$RecognizeFaceItemsTableUpdateCompanionBuilder =
    RecognizeFaceItemsCompanion Function({
      Value<int> rowId,
      Value<int> parent,
      Value<String> relativePath,
      Value<int> fileId,
      Value<int?> contentLength,
      Value<String?> contentType,
      Value<String?> etag,
      Value<DateTime?> lastModified,
      Value<bool?> hasPreview,
      Value<String?> realPath,
      Value<bool?> isFavorite,
      Value<int?> fileMetadataWidth,
      Value<int?> fileMetadataHeight,
      Value<String?> faceDetections,
    });

final class $$RecognizeFaceItemsTableReferences
    extends
        BaseReferences<
          _$SqliteDb,
          $RecognizeFaceItemsTable,
          RecognizeFaceItem
        > {
  $$RecognizeFaceItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecognizeFacesTable _parentTable(_$SqliteDb db) =>
      db.recognizeFaces.createAlias(
        $_aliasNameGenerator(
          db.recognizeFaceItems.parent,
          db.recognizeFaces.rowId,
        ),
      );

  $$RecognizeFacesTableProcessedTableManager get parent {
    final manager = $$RecognizeFacesTableTableManager(
      $_db,
      $_db.recognizeFaces,
    ).filter((f) => f.rowId($_item.parent!));
    final item = $_typedResult.readTableOrNull(_parentTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecognizeFaceItemsTableFilterComposer
    extends Composer<_$SqliteDb, $RecognizeFaceItemsTable> {
  $$RecognizeFaceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentLength => $composableBuilder(
    column: $table.contentLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, DateTime>
  get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get hasPreview => $composableBuilder(
    column: $table.hasPreview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get realPath => $composableBuilder(
    column: $table.realPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileMetadataWidth => $composableBuilder(
    column: $table.fileMetadataWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileMetadataHeight => $composableBuilder(
    column: $table.fileMetadataHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get faceDetections => $composableBuilder(
    column: $table.faceDetections,
    builder: (column) => ColumnFilters(column),
  );

  $$RecognizeFacesTableFilterComposer get parent {
    final $$RecognizeFacesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parent,
      referencedTable: $db.recognizeFaces,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecognizeFacesTableFilterComposer(
            $db: $db,
            $table: $db.recognizeFaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecognizeFaceItemsTableOrderingComposer
    extends Composer<_$SqliteDb, $RecognizeFaceItemsTable> {
  $$RecognizeFaceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileId => $composableBuilder(
    column: $table.fileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentLength => $composableBuilder(
    column: $table.contentLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasPreview => $composableBuilder(
    column: $table.hasPreview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get realPath => $composableBuilder(
    column: $table.realPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileMetadataWidth => $composableBuilder(
    column: $table.fileMetadataWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileMetadataHeight => $composableBuilder(
    column: $table.fileMetadataHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get faceDetections => $composableBuilder(
    column: $table.faceDetections,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecognizeFacesTableOrderingComposer get parent {
    final $$RecognizeFacesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parent,
      referencedTable: $db.recognizeFaces,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecognizeFacesTableOrderingComposer(
            $db: $db,
            $table: $db.recognizeFaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecognizeFaceItemsTableAnnotationComposer
    extends Composer<_$SqliteDb, $RecognizeFaceItemsTable> {
  $$RecognizeFaceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get relativePath => $composableBuilder(
    column: $table.relativePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileId =>
      $composableBuilder(column: $table.fileId, builder: (column) => column);

  GeneratedColumn<int> get contentLength => $composableBuilder(
    column: $table.contentLength,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, DateTime> get lastModified =>
      $composableBuilder(
        column: $table.lastModified,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get hasPreview => $composableBuilder(
    column: $table.hasPreview,
    builder: (column) => column,
  );

  GeneratedColumn<String> get realPath =>
      $composableBuilder(column: $table.realPath, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileMetadataWidth => $composableBuilder(
    column: $table.fileMetadataWidth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileMetadataHeight => $composableBuilder(
    column: $table.fileMetadataHeight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get faceDetections => $composableBuilder(
    column: $table.faceDetections,
    builder: (column) => column,
  );

  $$RecognizeFacesTableAnnotationComposer get parent {
    final $$RecognizeFacesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parent,
      referencedTable: $db.recognizeFaces,
      getReferencedColumn: (t) => t.rowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecognizeFacesTableAnnotationComposer(
            $db: $db,
            $table: $db.recognizeFaces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecognizeFaceItemsTableTableManager
    extends
        RootTableManager<
          _$SqliteDb,
          $RecognizeFaceItemsTable,
          RecognizeFaceItem,
          $$RecognizeFaceItemsTableFilterComposer,
          $$RecognizeFaceItemsTableOrderingComposer,
          $$RecognizeFaceItemsTableAnnotationComposer,
          $$RecognizeFaceItemsTableCreateCompanionBuilder,
          $$RecognizeFaceItemsTableUpdateCompanionBuilder,
          (RecognizeFaceItem, $$RecognizeFaceItemsTableReferences),
          RecognizeFaceItem,
          PrefetchHooks Function({bool parent})
        > {
  $$RecognizeFaceItemsTableTableManager(
    _$SqliteDb db,
    $RecognizeFaceItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RecognizeFaceItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$RecognizeFaceItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$RecognizeFaceItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                Value<int> parent = const Value.absent(),
                Value<String> relativePath = const Value.absent(),
                Value<int> fileId = const Value.absent(),
                Value<int?> contentLength = const Value.absent(),
                Value<String?> contentType = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<DateTime?> lastModified = const Value.absent(),
                Value<bool?> hasPreview = const Value.absent(),
                Value<String?> realPath = const Value.absent(),
                Value<bool?> isFavorite = const Value.absent(),
                Value<int?> fileMetadataWidth = const Value.absent(),
                Value<int?> fileMetadataHeight = const Value.absent(),
                Value<String?> faceDetections = const Value.absent(),
              }) => RecognizeFaceItemsCompanion(
                rowId: rowId,
                parent: parent,
                relativePath: relativePath,
                fileId: fileId,
                contentLength: contentLength,
                contentType: contentType,
                etag: etag,
                lastModified: lastModified,
                hasPreview: hasPreview,
                realPath: realPath,
                isFavorite: isFavorite,
                fileMetadataWidth: fileMetadataWidth,
                fileMetadataHeight: fileMetadataHeight,
                faceDetections: faceDetections,
              ),
          createCompanionCallback:
              ({
                Value<int> rowId = const Value.absent(),
                required int parent,
                required String relativePath,
                required int fileId,
                Value<int?> contentLength = const Value.absent(),
                Value<String?> contentType = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<DateTime?> lastModified = const Value.absent(),
                Value<bool?> hasPreview = const Value.absent(),
                Value<String?> realPath = const Value.absent(),
                Value<bool?> isFavorite = const Value.absent(),
                Value<int?> fileMetadataWidth = const Value.absent(),
                Value<int?> fileMetadataHeight = const Value.absent(),
                Value<String?> faceDetections = const Value.absent(),
              }) => RecognizeFaceItemsCompanion.insert(
                rowId: rowId,
                parent: parent,
                relativePath: relativePath,
                fileId: fileId,
                contentLength: contentLength,
                contentType: contentType,
                etag: etag,
                lastModified: lastModified,
                hasPreview: hasPreview,
                realPath: realPath,
                isFavorite: isFavorite,
                fileMetadataWidth: fileMetadataWidth,
                fileMetadataHeight: fileMetadataHeight,
                faceDetections: faceDetections,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$RecognizeFaceItemsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({parent = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (parent) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.parent,
                            referencedTable: $$RecognizeFaceItemsTableReferences
                                ._parentTable(db),
                            referencedColumn:
                                $$RecognizeFaceItemsTableReferences
                                    ._parentTable(db)
                                    .rowId,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecognizeFaceItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$SqliteDb,
      $RecognizeFaceItemsTable,
      RecognizeFaceItem,
      $$RecognizeFaceItemsTableFilterComposer,
      $$RecognizeFaceItemsTableOrderingComposer,
      $$RecognizeFaceItemsTableAnnotationComposer,
      $$RecognizeFaceItemsTableCreateCompanionBuilder,
      $$RecognizeFaceItemsTableUpdateCompanionBuilder,
      (RecognizeFaceItem, $$RecognizeFaceItemsTableReferences),
      RecognizeFaceItem,
      PrefetchHooks Function({bool parent})
    >;

class $SqliteDbManager {
  final _$SqliteDb _db;
  $SqliteDbManager(this._db);
  $$ServersTableTableManager get servers =>
      $$ServersTableTableManager(_db, _db.servers);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$FilesTableTableManager get files =>
      $$FilesTableTableManager(_db, _db.files);
  $$AccountFilesTableTableManager get accountFiles =>
      $$AccountFilesTableTableManager(_db, _db.accountFiles);
  $$ImagesTableTableManager get images =>
      $$ImagesTableTableManager(_db, _db.images);
  $$ImageLocationsTableTableManager get imageLocations =>
      $$ImageLocationsTableTableManager(_db, _db.imageLocations);
  $$TrashesTableTableManager get trashes =>
      $$TrashesTableTableManager(_db, _db.trashes);
  $$DirFilesTableTableManager get dirFiles =>
      $$DirFilesTableTableManager(_db, _db.dirFiles);
  $$AlbumsTableTableManager get albums =>
      $$AlbumsTableTableManager(_db, _db.albums);
  $$AlbumSharesTableTableManager get albumShares =>
      $$AlbumSharesTableTableManager(_db, _db.albumShares);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$FaceRecognitionPersonsTableTableManager get faceRecognitionPersons =>
      $$FaceRecognitionPersonsTableTableManager(
        _db,
        _db.faceRecognitionPersons,
      );
  $$NcAlbumsTableTableManager get ncAlbums =>
      $$NcAlbumsTableTableManager(_db, _db.ncAlbums);
  $$NcAlbumItemsTableTableManager get ncAlbumItems =>
      $$NcAlbumItemsTableTableManager(_db, _db.ncAlbumItems);
  $$RecognizeFacesTableTableManager get recognizeFaces =>
      $$RecognizeFacesTableTableManager(_db, _db.recognizeFaces);
  $$RecognizeFaceItemsTableTableManager get recognizeFaceItems =>
      $$RecognizeFaceItemsTableTableManager(_db, _db.recognizeFaceItems);
}

// **************************************************************************
// NpLogGenerator
// **************************************************************************

extension _$SqliteDbNpLog on SqliteDb {
  // ignore: unused_element
  Logger get _log => log;

  static final log = Logger("src.database.SqliteDb");
}
