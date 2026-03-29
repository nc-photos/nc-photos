part of '../database_extension.dart';

class ImageLocationGroup {
  const ImageLocationGroup({
    required this.name,
    required this.type,
    required this.countryCode,
    required this.count,
    required this.latestFileId,
    required this.latestDateTime,
    required this.latestFileMime,
    required this.latestFileRelativePath,
  });

  final LocalizedString name;
  final ImageLocationType type;
  final String countryCode;
  final int count;
  final int latestFileId;
  final DateTime latestDateTime;
  final String? latestFileMime;
  final String latestFileRelativePath;
}

class ImageLatLng {
  const ImageLatLng({
    required this.lat,
    required this.lng,
    required this.fileId,
    required this.fileRelativePath,
    required this.mime,
  });

  final double lat;
  final double lng;
  final int fileId;
  final String fileRelativePath;
  final String? mime;
}

enum ImageLocationType {
  city(0),
  admin1(1),
  admin2(2),
  country(3);

  const ImageLocationType(this.value);

  final int value;
}

extension SqliteDbImageLocationExtension on SqliteDb {
  Future<List<ImageLatLng>> queryImageLatLngWithFileIds({
    required ByAccount account,
    TimeRange? timeRange,
    List<String>? includeRelativeRoots,
    List<String>? includeRelativeDirs,
    List<String>? excludeRelativeRoots,
    List<String>? mimes,
  }) async {
    _log.info("[queryImageLatLngWithFileIds] timeRange: $timeRange");
    final query = _queryFiles().let((q) {
      q
        ..setQueryMode(
          FilesQueryMode.expression,
          expressions: [files.fileId, files.contentType],
        )
        ..setExtraJoins([
          innerJoin(
            imageLocations,
            imageLocations.accountFile.equalsExp(accountFiles.rowId),
          ),
        ])
        ..setAccount(account);
      if (includeRelativeRoots != null) {
        if (includeRelativeRoots.none((p) => p.isEmpty)) {
          for (final r in includeRelativeRoots) {
            q.byOrRelativePathPattern("$r/%");
          }
        }
      }
      return q.build();
    });
    query.addColumns([
      accountFiles.relativePath,
      imageLocations.latitude,
      imageLocations.longitude,
    ]);
    if (excludeRelativeRoots != null) {
      for (final r in excludeRelativeRoots) {
        query.where(accountFiles.relativePath.like("$r/%").not());
      }
    }
    if (mimes != null) {
      query.where(files.contentType.isIn(mimes));
    } else {
      query.where(files.isCollection.isNotValue(true));
    }
    if (timeRange != null) {
      accountFiles.bestDateTime
          .isBetweenTimeRange(timeRange)
          ?.let((e) => query.where(e));
    }
    query
      ..where(
        imageLocations.latitude.isNotNull() &
            imageLocations.longitude.isNotNull(),
      )
      ..orderBy([OrderingTerm.desc(accountFiles.bestDateTime)]);
    return query
        .map(
          (r) => ImageLatLng(
            lat: r.read(imageLocations.latitude)!,
            lng: r.read(imageLocations.longitude)!,
            fileId: r.read(files.fileId)!,
            fileRelativePath: r.read(accountFiles.relativePath)!,
            mime: r.read(files.contentType),
          ),
        )
        .get();
  }

  Future<List<ImageLocationGroup>> groupImageLocations({
    required ByAccount account,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
  }) async {
    final query = selectOnly(imageLocations).join([
      innerJoin(
        accountFiles,
        accountFiles.rowId.equalsExp(imageLocations.accountFile),
        useColumns: false,
      ),
      innerJoin(
        files,
        files.rowId.equalsExp(accountFiles.file),
        useColumns: false,
      ),
      innerJoin(
        imageLocationIds,
        imageLocationIds.accountFile.equalsExp(imageLocations.accountFile),
        useColumns: false,
      ),
    ]);
    if (account.sqlAccount != null) {
      query.where(accountFiles.account.equals(account.sqlAccount!.rowId));
    } else {
      query.join([
          innerJoin(
            accounts,
            accounts.rowId.equalsExp(accountFiles.account),
            useColumns: false,
          ),
          innerJoin(
            servers,
            servers.rowId.equalsExp(accounts.server),
            useColumns: false,
          ),
        ])
        ..where(servers.address.equals(account.dbAccount!.serverAddress))
        ..where(
          accounts.userId.equals(
            account.dbAccount!.userId.toCaseInsensitiveString(),
          ),
        );
    }

    final count = imageLocations.rowId.count();
    final latest = accountFiles.bestDateTime.max();
    query
      ..addColumns([
        imageLocationIds.geonameId,
        imageLocationIds.type,
        imageLocations.countryCode,
        count,
        files.fileId,
        files.contentType,
        accountFiles.relativePath,
        latest,
      ])
      ..groupBy([
        imageLocationIds.geonameId,
        imageLocationIds.type,
        imageLocations.countryCode,
      ], having: accountFiles.bestDateTime.equalsExp(latest));

    if (includeRelativeRoots != null &&
        includeRelativeRoots.isNotEmpty &&
        includeRelativeRoots.none((r) => r.isEmpty)) {
      final expr = includeRelativeRoots
          .map((r) => accountFiles.relativePath.like("$r/%"))
          .reduce((value, element) => value | element);
      query.where(expr);
    }
    if (excludeRelativeRoots != null) {
      for (final r in excludeRelativeRoots) {
        query.where(accountFiles.relativePath.like("$r/%").not());
      }
    }
    final idResults =
        await query
            .map(
              (r) => (
                geonameId: r.read(imageLocationIds.geonameId)!,
                type: r.readWithConverter(imageLocationIds.type)!,
                countryCode: r.read(imageLocations.countryCode)!,
                count: r.read(count)!,
                latestFileId: r.read(files.fileId)!,
                latestDateTime: r.read(latest)!.toUtc(),
                latestFileMime: r.read(files.contentType),
                latestFileRelativePath: r.read(accountFiles.relativePath)!,
              ),
            )
            .get();

    final nameQuery = select(imageLocationNames)
      ..where((t) => t.geonameId.isIn(idResults.map((e) => e.geonameId)));
    final nameMap = <int, Map<String, String>>{};
    for (final e in await nameQuery.get()) {
      nameMap[e.geonameId] ??= <String, String>{};
      nameMap[e.geonameId]![e.lang] = e.name;
    }
    return idResults
        .map(
          (e) => nameMap[e.geonameId]?.let(
            (n) => ImageLocationGroup(
              name: LocalizedString(n),
              type: e.type,
              countryCode: e.countryCode,
              count: e.count,
              latestFileId: e.latestFileId,
              latestDateTime: e.latestDateTime,
              latestFileMime: e.latestFileMime,
              latestFileRelativePath: e.latestFileRelativePath,
            ),
          ),
        )
        .nonNulls
        .toList();
  }

  Future<List<ImageLocationGroup>> groupImageLocationsByCountryCode({
    required ByAccount account,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
  }) {
    _log.info("[groupImageLocationsByCountryCode]");
    final query = selectOnly(imageLocations).join([
      innerJoin(
        accountFiles,
        accountFiles.rowId.equalsExp(imageLocations.accountFile),
        useColumns: false,
      ),
      innerJoin(
        files,
        files.rowId.equalsExp(accountFiles.file),
        useColumns: false,
      ),
    ]);
    if (account.sqlAccount != null) {
      query.where(accountFiles.account.equals(account.sqlAccount!.rowId));
    } else {
      query.join([
          innerJoin(
            accounts,
            accounts.rowId.equalsExp(accountFiles.account),
            useColumns: false,
          ),
          innerJoin(
            servers,
            servers.rowId.equalsExp(accounts.server),
            useColumns: false,
          ),
        ])
        ..where(servers.address.equals(account.dbAccount!.serverAddress))
        ..where(
          accounts.userId.equals(
            account.dbAccount!.userId.toCaseInsensitiveString(),
          ),
        );
    }

    final count = imageLocations.rowId.count();
    final latest = accountFiles.bestDateTime.max();
    query
      ..addColumns([
        imageLocations.countryCode,
        count,
        files.fileId,
        files.contentType,
        accountFiles.relativePath,
        latest,
      ])
      ..groupBy([
        imageLocations.countryCode,
      ], having: accountFiles.bestDateTime.equalsExp(latest))
      ..where(imageLocations.countryCode.isNotNull());
    if (includeRelativeRoots != null &&
        includeRelativeRoots.isNotEmpty &&
        includeRelativeRoots.none((r) => r.isEmpty)) {
      final expr = includeRelativeRoots
          .map((r) => accountFiles.relativePath.like("$r/%"))
          .reduce((value, element) => value | element);
      query.where(expr);
    }
    if (excludeRelativeRoots != null) {
      for (final r in excludeRelativeRoots) {
        query.where(accountFiles.relativePath.like("$r/%").not());
      }
    }
    return query.map((r) {
      final cc = r.read(imageLocations.countryCode)!;
      return ImageLocationGroup(
        name: LocalizedString({"en": alpha2CodeToName(cc) ?? cc}),
        type: ImageLocationType.country,
        countryCode: cc,
        count: r.read(count)!,
        latestFileId: r.read(files.fileId)!,
        latestDateTime: r.read(latest)!.toUtc(),
        latestFileMime: r.read(files.contentType),
        latestFileRelativePath: r.read(accountFiles.relativePath)!,
      );
    }).get();
  }

  Future<({double lat, double lng})?> queryFirstLocationLatLngByFileIds({
    required ByAccount account,
    required List<int> fileIds,
  }) async {
    final candidates = await fileIds.withPartition((sublist) async {
      final query = selectOnly(files).join([
        innerJoin(
          accountFiles,
          accountFiles.file.equalsExp(files.rowId),
          useColumns: false,
        ),
        if (account.dbAccount != null) ...[
          innerJoin(
            accounts,
            accounts.rowId.equalsExp(accountFiles.account),
            useColumns: false,
          ),
          innerJoin(
            servers,
            servers.rowId.equalsExp(accounts.server),
            useColumns: false,
          ),
        ],
        innerJoin(
          imageLocations,
          imageLocations.accountFile.equalsExp(accountFiles.rowId),
          useColumns: false,
        ),
      ]);
      query.addColumns([accountFiles.rowId, accountFiles.bestDateTime]);

      if (account.sqlAccount != null) {
        query.where(accountFiles.account.equals(account.sqlAccount!.rowId));
      } else if (account.dbAccount != null) {
        query
          ..where(servers.address.equals(account.dbAccount!.serverAddress))
          ..where(
            accounts.userId.equals(
              account.dbAccount!.userId.toCaseInsensitiveString(),
            ),
          );
      }

      query
        ..where(files.fileId.isIn(sublist))
        ..where(
          imageLocations.latitude.isNotNull() &
              imageLocations.longitude.isNotNull(),
        )
        ..orderBy([OrderingTerm.desc(accountFiles.bestDateTime)])
        ..limit(1);
      return [
        await query
            .map(
              (r) => (
                rowId: r.read(accountFiles.rowId)!,
                dateTime: r.read(accountFiles.bestDateTime)!,
              ),
            )
            .getSingleOrNull(),
      ];
    }, _maxByFileIdsSize);
    final winner =
        candidates.nonNulls.sortedBy((e) => e.dateTime).reversed.firstOrNull;
    if (winner == null) {
      return null;
    }

    final reusltQuery = select(imageLocations)
      ..where((t) => t.accountFile.equals(winner.rowId));
    return reusltQuery
        .map((r) => (lat: r.latitude!, lng: r.longitude!))
        .getSingleOrNull();
  }
}
