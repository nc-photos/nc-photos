part of '../album_test.dart';

void _upgradeV8JsonNonManualCover() {
  final json = <String, dynamic>{
    "version": 8,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{"items": []},
    },
    "coverProvider": <String, dynamic>{
      "type": "memory",
      "content": <String, dynamic>{
        "coverFile": <String, dynamic>{
          "fdPath": "remote.php/dav/files/admin/test1.jpg",
          "fdId": 1,
          "fdMime": null,
          "fdIsArchived": false,
          "fdIsFavorite": false,
          "fdDateTime": "2020-01-02T03:04:05.678901Z",
        },
      },
    },
    "sortProvider": <String, dynamic>{
      "type": "null",
      "content": <String, dynamic>{},
    },
    "albumFile": <String, dynamic>{
      "path": "remote.php/dav/files/admin/test1.json",
    },
  };
  expect(const AlbumUpgraderV8().doJson(json), <String, dynamic>{
    "version": 8,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{"items": []},
    },
    "coverProvider": <String, dynamic>{
      "type": "memory",
      "content": <String, dynamic>{
        "coverFile": <String, dynamic>{
          "fdPath": "remote.php/dav/files/admin/test1.jpg",
          "fdId": 1,
          "fdMime": null,
          "fdIsArchived": false,
          "fdIsFavorite": false,
          "fdDateTime": "2020-01-02T03:04:05.678901Z",
        },
      },
    },
    "sortProvider": <String, dynamic>{
      "type": "null",
      "content": <String, dynamic>{},
    },
    "albumFile": <String, dynamic>{
      "path": "remote.php/dav/files/admin/test1.json",
    },
  });
}

void _upgradeV8JsonManualNow() {
  withClock(Clock.fixed(DateTime.utc(2020, 1, 2, 3, 4, 5)), () {
    final json = <String, dynamic>{
      "version": 8,
      "lastUpdated": "2020-01-02T03:04:05.678901Z",
      "provider": <String, dynamic>{
        "type": "static",
        "content": <String, dynamic>{"items": []},
      },
      "coverProvider": <String, dynamic>{
        "type": "manual",
        "content": <String, dynamic>{
          "coverFile": <String, dynamic>{
            "path": "remote.php/dav/files/admin/test1.jpg",
            "fileId": 1,
          },
        },
      },
      "sortProvider": <String, dynamic>{
        "type": "null",
        "content": <String, dynamic>{},
      },
      "albumFile": <String, dynamic>{
        "path": "remote.php/dav/files/admin/test1.json",
      },
    };
    expect(const AlbumUpgraderV8().doJson(json), <String, dynamic>{
      "version": 8,
      "lastUpdated": "2020-01-02T03:04:05.678901Z",
      "provider": <String, dynamic>{
        "type": "static",
        "content": <String, dynamic>{"items": []},
      },
      "coverProvider": <String, dynamic>{
        "type": "manual",
        "content": <String, dynamic>{
          "coverFile": <String, dynamic>{
            "fdPath": "remote.php/dav/files/admin/test1.jpg",
            "fdId": 1,
            "fdMime": null,
            "fdIsArchived": false,
            "fdIsFavorite": false,
            "fdDateTime": "2020-01-02T03:04:05.000Z",
          },
        },
      },
      "sortProvider": <String, dynamic>{
        "type": "null",
        "content": <String, dynamic>{},
      },
      "albumFile": <String, dynamic>{
        "path": "remote.php/dav/files/admin/test1.json",
      },
    });
  });
}

void _upgradeV8JsonManualExifTime() {
  final json = <String, dynamic>{
    "version": 8,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{"items": []},
    },
    "coverProvider": <String, dynamic>{
      "type": "manual",
      "content": <String, dynamic>{
        "coverFile": <String, dynamic>{
          "path": "remote.php/dav/files/admin/test1.jpg",
          "fileId": 1,
          "metadata": <String, dynamic>{
            "exif": <String, dynamic>{
              "DateTimeOriginal": "2020:01:02 03:04:05",
            },
          },
        },
      },
    },
    "sortProvider": <String, dynamic>{
      "type": "null",
      "content": <String, dynamic>{},
    },
    "albumFile": <String, dynamic>{
      "path": "remote.php/dav/files/admin/test1.json",
    },
  };
  expect(const AlbumUpgraderV8().doJson(json), <String, dynamic>{
    "version": 8,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{"items": []},
    },
    "coverProvider": <String, dynamic>{
      "type": "manual",
      "content": <String, dynamic>{
        "coverFile": <String, dynamic>{
          "fdPath": "remote.php/dav/files/admin/test1.jpg",
          "fdId": 1,
          "fdMime": null,
          "fdIsArchived": false,
          "fdIsFavorite": false,
          // dart does not provide a way to mock timezone
          "fdDateTime": DateTime(2020, 1, 2, 3, 4, 5).toUtc().toIso8601String(),
        },
      },
    },
    "sortProvider": <String, dynamic>{
      "type": "null",
      "content": <String, dynamic>{},
    },
    "albumFile": <String, dynamic>{
      "path": "remote.php/dav/files/admin/test1.json",
    },
  });
}

void _upgradeV8JsonAutoNull() {
  final json = <String, dynamic>{
    "version": 8,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{"items": []},
    },
    "coverProvider": <String, dynamic>{
      "type": "auto",
      "content": <String, dynamic>{},
    },
    "sortProvider": <String, dynamic>{
      "type": "null",
      "content": <String, dynamic>{},
    },
    "albumFile": <String, dynamic>{
      "path": "remote.php/dav/files/admin/test1.json",
    },
  };
  expect(const AlbumUpgraderV8().doJson(json), <String, dynamic>{
    "version": 8,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{"items": []},
    },
    "coverProvider": <String, dynamic>{
      "type": "auto",
      "content": <String, dynamic>{},
    },
    "sortProvider": <String, dynamic>{
      "type": "null",
      "content": <String, dynamic>{},
    },
    "albumFile": <String, dynamic>{
      "path": "remote.php/dav/files/admin/test1.json",
    },
  });
}

void _upgradeV8JsonAutoLastModified() {
  final json = <String, dynamic>{
    "version": 8,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{"items": []},
    },
    "coverProvider": <String, dynamic>{
      "type": "auto",
      "content": <String, dynamic>{
        "coverFile": <String, dynamic>{
          "path": "remote.php/dav/files/admin/test1.jpg",
          "fileId": 1,
          "lastModified": "2020-01-02T03:04:05.000Z",
        },
      },
    },
    "sortProvider": <String, dynamic>{
      "type": "null",
      "content": <String, dynamic>{},
    },
    "albumFile": <String, dynamic>{
      "path": "remote.php/dav/files/admin/test1.json",
    },
  };
  expect(const AlbumUpgraderV8().doJson(json), <String, dynamic>{
    "version": 8,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{"items": []},
    },
    "coverProvider": <String, dynamic>{
      "type": "auto",
      "content": <String, dynamic>{
        "coverFile": <String, dynamic>{
          "fdPath": "remote.php/dav/files/admin/test1.jpg",
          "fdId": 1,
          "fdMime": null,
          "fdIsArchived": false,
          "fdIsFavorite": false,
          "fdDateTime": "2020-01-02T03:04:05.000Z",
        },
      },
    },
    "sortProvider": <String, dynamic>{
      "type": "null",
      "content": <String, dynamic>{},
    },
    "albumFile": <String, dynamic>{
      "path": "remote.php/dav/files/admin/test1.json",
    },
  });
}

void _upgradeV8JsonAutoNoFileId() {
  final json = <String, dynamic>{
    "version": 8,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{"items": []},
    },
    "coverProvider": <String, dynamic>{
      "type": "auto",
      "content": <String, dynamic>{
        "coverFile": <String, dynamic>{
          "path": "remote.php/dav/files/admin/test1.jpg",
          "lastModified": "2020-01-02T03:04:05.000Z",
        },
      },
    },
    "sortProvider": <String, dynamic>{
      "type": "null",
      "content": <String, dynamic>{},
    },
    "albumFile": <String, dynamic>{
      "path": "remote.php/dav/files/admin/test1.json",
    },
  };
  expect(const AlbumUpgraderV8().doJson(json), <String, dynamic>{
    "version": 8,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{"items": []},
    },
    "coverProvider": <String, dynamic>{
      "type": "auto",
      "content": <String, dynamic>{},
    },
    "sortProvider": <String, dynamic>{
      "type": "null",
      "content": <String, dynamic>{},
    },
    "albumFile": <String, dynamic>{
      "path": "remote.php/dav/files/admin/test1.json",
    },
  });
}

void _upgradeV8DbNonManualCover() {
  final dbObj = DbAlbum(
    fileId: 1,
    fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
    version: 8,
    lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
    name: "test1",
    providerType: "static",
    providerContent: {"items": []},
    coverProviderType: "memory",
    coverProviderContent: {
      "coverFile": {
        "fdPath": "remote.php/dav/files/admin/test1.jpg",
        "fdId": 1,
        "fdMime": null,
        "fdIsArchived": false,
        "fdIsFavorite": false,
        "fdDateTime": "2020-01-02T03:04:05.678901Z",
      },
    },
    sortProviderType: "null",
    sortProviderContent: {},
    shares: [],
  );
  expect(
    const AlbumUpgraderV8().doDb(dbObj),
    DbAlbum(
      fileId: 1,
      fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
      version: 8,
      lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
      name: "test1",
      providerType: "static",
      providerContent: {"items": []},
      coverProviderType: "memory",
      coverProviderContent: {
        "coverFile": {
          "fdPath": "remote.php/dav/files/admin/test1.jpg",
          "fdId": 1,
          "fdMime": null,
          "fdIsArchived": false,
          "fdIsFavorite": false,
          "fdDateTime": "2020-01-02T03:04:05.678901Z",
        },
      },
      sortProviderType: "null",
      sortProviderContent: {},
      shares: [],
    ),
  );
}

void _upgradeV8DbManualNow() {
  withClock(Clock.fixed(DateTime.utc(2020, 1, 2, 3, 4, 5)), () {
    final dbObj = DbAlbum(
      fileId: 1,
      fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
      version: 8,
      lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
      name: "test1",
      providerType: "static",
      providerContent: {"items": []},
      coverProviderType: "manual",
      coverProviderContent: {
        "coverFile": {
          "path": "remote.php/dav/files/admin/test1.jpg",
          "fileId": 1,
        },
      },
      sortProviderType: "null",
      sortProviderContent: {},
      shares: [],
    );
    expect(
      const AlbumUpgraderV8().doDb(dbObj),
      DbAlbum(
        fileId: 1,
        fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
        version: 8,
        lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
        name: "test1",
        providerType: "static",
        providerContent: {"items": []},
        coverProviderType: "manual",
        coverProviderContent: {
          "coverFile": {
            "fdPath": "remote.php/dav/files/admin/test1.jpg",
            "fdId": 1,
            "fdMime": null,
            "fdIsArchived": false,
            "fdIsFavorite": false,
            "fdDateTime": "2020-01-02T03:04:05.000Z",
          },
        },
        sortProviderType: "null",
        sortProviderContent: {},
        shares: [],
      ),
    );
  });
}

void _upgradeV8DbManualExifTime() {
  final dbObj = DbAlbum(
    fileId: 1,
    fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
    version: 8,
    lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
    name: "test1",
    providerType: "static",
    providerContent: {"items": []},
    coverProviderType: "manual",
    coverProviderContent: {
      "coverFile": {
        "path": "remote.php/dav/files/admin/test1.jpg",
        "fileId": 1,
        "metadata": {
          "exif": {"DateTimeOriginal": "2020:01:02 03:04:05"},
        },
      },
    },
    sortProviderType: "null",
    sortProviderContent: {},
    shares: [],
  );
  // dart does not provide a way to mock timezone
  final dateTime = DateTime(2020, 1, 2, 3, 4, 5).toUtc().toIso8601String();
  expect(
    const AlbumUpgraderV8().doDb(dbObj),
    DbAlbum(
      fileId: 1,
      fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
      version: 8,
      lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
      name: "test1",
      providerType: "static",
      providerContent: {"items": []},
      coverProviderType: "manual",
      coverProviderContent: {
        "coverFile": {
          "fdPath": "remote.php/dav/files/admin/test1.jpg",
          "fdId": 1,
          "fdMime": null,
          "fdIsArchived": false,
          "fdIsFavorite": false,
          "fdDateTime": dateTime,
        },
      },
      sortProviderType: "null",
      sortProviderContent: {},
      shares: [],
    ),
  );
}

void _upgradeV8DbAutoNull() {
  final dbObj = DbAlbum(
    fileId: 1,
    fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
    version: 8,
    lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
    name: "test1",
    providerType: "static",
    providerContent: {"items": []},
    coverProviderType: "auto",
    coverProviderContent: {},
    sortProviderType: "null",
    sortProviderContent: {},
    shares: [],
  );
  expect(
    const AlbumUpgraderV8().doDb(dbObj),
    DbAlbum(
      fileId: 1,
      fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
      version: 8,
      lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
      name: "test1",
      providerType: "static",
      providerContent: {"items": []},
      coverProviderType: "auto",
      coverProviderContent: {},
      sortProviderType: "null",
      sortProviderContent: {},
      shares: [],
    ),
  );
}

void _upgradeV8DbAutoLastModified() {
  final dbObj = DbAlbum(
    fileId: 1,
    fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
    version: 8,
    lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
    name: "test1",
    providerType: "static",
    providerContent: {"items": []},
    coverProviderType: "auto",
    coverProviderContent: {
      "coverFile": {
        "path": "remote.php/dav/files/admin/test1.jpg",
        "fileId": 1,
        "lastModified": "2020-01-02T03:04:05.000Z",
      },
    },
    sortProviderType: "null",
    sortProviderContent: {},
    shares: [],
  );
  expect(
    const AlbumUpgraderV8().doDb(dbObj),
    DbAlbum(
      fileId: 1,
      fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
      version: 8,
      lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
      name: "test1",
      providerType: "static",
      providerContent: {"items": []},
      coverProviderType: "auto",
      coverProviderContent: {
        "coverFile": {
          "fdPath": "remote.php/dav/files/admin/test1.jpg",
          "fdId": 1,
          "fdMime": null,
          "fdIsArchived": false,
          "fdIsFavorite": false,
          "fdDateTime": "2020-01-02T03:04:05.000Z",
        },
      },
      sortProviderType: "null",
      sortProviderContent: {},
      shares: [],
    ),
  );
}

void _upgradeV8DbAutoNoFileId() {
  final dbObj = DbAlbum(
    fileId: 1,
    fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
    version: 8,
    lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
    name: "test1",
    providerType: "static",
    providerContent: {"items": []},
    coverProviderType: "auto",
    coverProviderContent: {
      "coverFile": {
        "path": "remote.php/dav/files/admin/test1.jpg",
        "lastModified": "2020-01-02T03:04:05.000Z",
      },
    },
    sortProviderType: "null",
    sortProviderContent: {},
    shares: [],
  );
  expect(
    const AlbumUpgraderV8().doDb(dbObj),
    DbAlbum(
      fileId: 1,
      fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
      version: 8,
      lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
      name: "test1",
      providerType: "static",
      providerContent: {"items": []},
      coverProviderType: "auto",
      coverProviderContent: {},
      sortProviderType: "null",
      sortProviderContent: {},
      shares: [],
    ),
  );
}
