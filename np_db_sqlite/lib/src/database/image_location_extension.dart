part of '../database_extension.dart';

class ImageLocationGroup {
  const ImageLocationGroup({
    required this.place,
    required this.countryCode,
    required this.count,
    required this.latestFileId,
    required this.latestDateTime,
    required this.latestFileMime,
    required this.latestFileRelativePath,
  });

  final String place;
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

  Future<List<ImageLocationGroup>> groupImageLocationsByName({
    required ByAccount account,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
  }) {
    _log.info("[groupImageLocationsByName]");
    return _groupImageLocationsBy(
      account: account,
      by: imageLocations.name,
      includeRelativeRoots: includeRelativeRoots,
      excludeRelativeRoots: excludeRelativeRoots,
    );
  }

  Future<List<ImageLocationGroup>> groupImageLocationsByAdmin1({
    required ByAccount account,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
  }) {
    _log.info("[groupImageLocationsByAdmin1]");
    return _groupImageLocationsBy(
      account: account,
      by: imageLocations.admin1,
      includeRelativeRoots: includeRelativeRoots,
      excludeRelativeRoots: excludeRelativeRoots,
    );
  }

  Future<List<ImageLocationGroup>> groupImageLocationsByAdmin2({
    required ByAccount account,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
  }) {
    _log.info("[groupImageLocationsByAdmin2]");
    return _groupImageLocationsBy(
      account: account,
      by: imageLocations.admin2,
      includeRelativeRoots: includeRelativeRoots,
      excludeRelativeRoots: excludeRelativeRoots,
    );
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
        place: alpha2CodeToName(cc) ?? cc,
        countryCode: cc,
        count: r.read(count)!,
        latestFileId: r.read(files.fileId)!,
        latestDateTime: r.read(latest)!.toUtc(),
        latestFileMime: r.read(files.contentType),
        latestFileRelativePath: r.read(accountFiles.relativePath)!,
      );
    }).get();
  }

  Future<ImageLocation?> queryFirstImageLocationByFileIds({
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
    return reusltQuery.getSingleOrNull();
  }

  Future<List<ImageLocationGroup>> _groupImageLocationsBy({
    required ByAccount account,
    required GeneratedColumn<String> by,
    List<String>? includeRelativeRoots,
    List<String>? excludeRelativeRoots,
  }) {
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
        by,
        imageLocations.countryCode,
        count,
        files.fileId,
        files.contentType,
        accountFiles.relativePath,
        latest,
      ])
      ..groupBy([
        by,
        imageLocations.countryCode,
      ], having: accountFiles.bestDateTime.equalsExp(latest))
      ..where(by.isNotNull());
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
    return query
        .map(
          (r) => ImageLocationGroup(
            place: r.read(by)!,
            countryCode: r.read(imageLocations.countryCode)!,
            count: r.read(count)!,
            latestFileId: r.read(files.fileId)!,
            latestDateTime: r.read(latest)!.toUtc(),
            latestFileMime: r.read(files.contentType),
            latestFileRelativePath: r.read(accountFiles.relativePath)!,
          ),
        )
        .get();
  }
}
