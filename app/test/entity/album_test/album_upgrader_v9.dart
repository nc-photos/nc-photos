part of '../album_test.dart';

void _upgradeV9JsonNonStatic() {
  final account = util.buildAccount();
  final json = <String, dynamic>{
    "version": 9,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "tag",
      "content": <String, dynamic>{"tags": []},
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
  expect(AlbumUpgraderV9(account: account).doJson(json), json);
}

void _upgradeV9JsonStaticNormal() {
  final account = util.buildAccount();
  final json = <String, dynamic>{
    "version": 9,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{
        "items": [
          <String, dynamic>{
            "type": "file",
            "content": <String, dynamic>{
              "file": <String, dynamic>{
                "path": "remote.php/dav/files/admin/test1.jpg",
                "fileId": 1,
                "contentLength": 12345,
                "contentType": "image/jpeg",
                "lastModified": "2020-01-02T03:04:05.678901Z",
                "ownerId": "admin",
              },
            },
          },
        ],
      },
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
  expect(AlbumUpgraderV9(account: account).doJson(json), <String, dynamic>{
    "version": 9,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{
        "items": [
          <String, dynamic>{
            "type": "file",
            "content": <String, dynamic>{
              "file": <String, dynamic>{
                "fdPath": "remote.php/dav/files/admin/test1.jpg",
                "fdId": 1,
                "fdMime": "image/jpeg",
                "fdIsArchived": false,
                "fdIsFavorite": false,
                "fdDateTime": "2020-01-02T03:04:05.678901Z",
              },
              "ownerId": "admin",
            },
          },
        ],
      },
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

void _upgradeV9JsonStaticNoOwnerId() {
  final account = util.buildAccount();
  final json = <String, dynamic>{
    "version": 9,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{
        "items": [
          <String, dynamic>{
            "type": "file",
            "content": <String, dynamic>{
              "file": <String, dynamic>{
                "path": "remote.php/dav/files/admin/test1.jpg",
                "fileId": 1,
                "contentLength": 12345,
                "contentType": "image/jpeg",
                "lastModified": "2020-01-02T03:04:05.678901Z",
              },
            },
          },
        ],
      },
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
  expect(AlbumUpgraderV9(account: account).doJson(json), <String, dynamic>{
    "version": 9,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{
        "items": [
          <String, dynamic>{
            "type": "file",
            "content": <String, dynamic>{
              "file": <String, dynamic>{
                "fdPath": "remote.php/dav/files/admin/test1.jpg",
                "fdId": 1,
                "fdMime": "image/jpeg",
                "fdIsArchived": false,
                "fdIsFavorite": false,
                "fdDateTime": "2020-01-02T03:04:05.678901Z",
              },
              "ownerId": "admin",
            },
          },
        ],
      },
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

void _upgradeV9JsonStaticOtherOwnerId() {
  final account = util.buildAccount();
  final json = <String, dynamic>{
    "version": 9,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{
        "items": [
          <String, dynamic>{
            "type": "file",
            "content": <String, dynamic>{
              "file": <String, dynamic>{
                "path": "remote.php/dav/files/admin/test1.jpg",
                "fileId": 1,
                "contentLength": 12345,
                "contentType": "image/jpeg",
                "lastModified": "2020-01-02T03:04:05.678901Z",
                "ownerId": "user1",
              },
            },
          },
        ],
      },
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
  expect(AlbumUpgraderV9(account: account).doJson(json), <String, dynamic>{
    "version": 9,
    "lastUpdated": "2020-01-02T03:04:05.678901Z",
    "provider": <String, dynamic>{
      "type": "static",
      "content": <String, dynamic>{
        "items": [
          <String, dynamic>{
            "type": "file",
            "content": <String, dynamic>{
              "file": <String, dynamic>{
                "fdPath": "remote.php/dav/files/admin/test1.jpg",
                "fdId": 1,
                "fdMime": "image/jpeg",
                "fdIsArchived": false,
                "fdIsFavorite": false,
                "fdDateTime": "2020-01-02T03:04:05.678901Z",
              },
              "ownerId": "user1",
            },
          },
        ],
      },
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

void _upgradeV9DbNonStatic() {
  final account = util.buildAccount();
  final dbObj = DbAlbum(
    fileId: 1,
    fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
    version: 9,
    lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
    name: "test1",
    providerType: "tag",
    providerContent: {"tags": []},
    coverProviderType: "auto",
    coverProviderContent: {},
    sortProviderType: "null",
    sortProviderContent: {},
    shares: [],
  );
  expect(
    AlbumUpgraderV9(account: account).doDb(dbObj),
    DbAlbum(
      fileId: 1,
      fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
      version: 9,
      lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
      name: "test1",
      providerType: "tag",
      providerContent: {"tags": []},
      coverProviderType: "auto",
      coverProviderContent: {},
      sortProviderType: "null",
      sortProviderContent: {},
      shares: [],
    ),
  );
}

void _upgradeV9DbStaticNormal() {
  final account = util.buildAccount();
  final dbObj = DbAlbum(
    fileId: 1,
    fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
    version: 9,
    lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
    name: "test1",
    providerType: "static",
    providerContent: {
      "items": [
        <String, dynamic>{
          "type": "file",
          "content": <String, dynamic>{
            "file": <String, dynamic>{
              "path": "remote.php/dav/files/admin/test1.jpg",
              "fileId": 2,
              "contentLength": 12345,
              "contentType": "image/jpeg",
              "lastModified": "2020-01-02T03:04:05.678901Z",
              "ownerId": "admin",
            },
          },
        },
      ],
    },
    coverProviderType: "auto",
    coverProviderContent: {},
    sortProviderType: "null",
    sortProviderContent: {},
    shares: [],
  );
  expect(
    AlbumUpgraderV9(account: account).doDb(dbObj),
    DbAlbum(
      fileId: 1,
      fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
      version: 9,
      lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
      name: "test1",
      providerType: "static",
      providerContent: {
        "items": [
          <String, dynamic>{
            "type": "file",
            "content": <String, dynamic>{
              "file": <String, dynamic>{
                "fdPath": "remote.php/dav/files/admin/test1.jpg",
                "fdId": 2,
                "fdMime": "image/jpeg",
                "fdIsArchived": false,
                "fdIsFavorite": false,
                "fdDateTime": "2020-01-02T03:04:05.678901Z",
              },
              "ownerId": "admin",
            },
          },
        ],
      },
      coverProviderType: "auto",
      coverProviderContent: {},
      sortProviderType: "null",
      sortProviderContent: {},
      shares: [],
    ),
  );
}

void _upgradeV9DbStaticNoOwnerId() {
  final account = util.buildAccount();
  final dbObj = DbAlbum(
    fileId: 1,
    fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
    version: 9,
    lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
    name: "test1",
    providerType: "static",
    providerContent: {
      "items": [
        <String, dynamic>{
          "type": "file",
          "content": <String, dynamic>{
            "file": <String, dynamic>{
              "path": "remote.php/dav/files/admin/test1.jpg",
              "fileId": 2,
              "contentLength": 12345,
              "contentType": "image/jpeg",
              "lastModified": "2020-01-02T03:04:05.678901Z",
            },
          },
        },
      ],
    },
    coverProviderType: "auto",
    coverProviderContent: {},
    sortProviderType: "null",
    sortProviderContent: {},
    shares: [],
  );
  expect(
    AlbumUpgraderV9(account: account).doDb(dbObj),
    DbAlbum(
      fileId: 1,
      fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
      version: 9,
      lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
      name: "test1",
      providerType: "static",
      providerContent: {
        "items": [
          <String, dynamic>{
            "type": "file",
            "content": <String, dynamic>{
              "file": <String, dynamic>{
                "fdPath": "remote.php/dav/files/admin/test1.jpg",
                "fdId": 2,
                "fdMime": "image/jpeg",
                "fdIsArchived": false,
                "fdIsFavorite": false,
                "fdDateTime": "2020-01-02T03:04:05.678901Z",
              },
              "ownerId": "admin",
            },
          },
        ],
      },
      coverProviderType: "auto",
      coverProviderContent: {},
      sortProviderType: "null",
      sortProviderContent: {},
      shares: [],
    ),
  );
}

void _upgradeV9DbStaticOtherOwnerId() {
  final account = util.buildAccount();
  final dbObj = DbAlbum(
    fileId: 1,
    fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
    version: 9,
    lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
    name: "test1",
    providerType: "static",
    providerContent: {
      "items": [
        <String, dynamic>{
          "type": "file",
          "content": <String, dynamic>{
            "file": <String, dynamic>{
              "path": "remote.php/dav/files/admin/test1.jpg",
              "fileId": 2,
              "contentLength": 12345,
              "contentType": "image/jpeg",
              "lastModified": "2020-01-02T03:04:05.678901Z",
              "ownerId": "user1",
            },
          },
        },
      ],
    },
    coverProviderType: "auto",
    coverProviderContent: {},
    sortProviderType: "null",
    sortProviderContent: {},
    shares: [],
  );
  expect(
    AlbumUpgraderV9(account: account).doDb(dbObj),
    DbAlbum(
      fileId: 1,
      fileEtag: "8a3e0799b6f0711c23cc2d93950eceb5",
      version: 9,
      lastUpdated: DateTime.utc(2020, 1, 2, 3, 4, 5),
      name: "test1",
      providerType: "static",
      providerContent: {
        "items": [
          <String, dynamic>{
            "type": "file",
            "content": <String, dynamic>{
              "file": <String, dynamic>{
                "fdPath": "remote.php/dav/files/admin/test1.jpg",
                "fdId": 2,
                "fdMime": "image/jpeg",
                "fdIsArchived": false,
                "fdIsFavorite": false,
                "fdDateTime": "2020-01-02T03:04:05.678901Z",
              },
              "ownerId": "user1",
            },
          },
        ],
      },
      coverProviderType: "auto",
      coverProviderContent: {},
      sortProviderType: "null",
      sortProviderContent: {},
      shares: [],
    ),
  );
}
