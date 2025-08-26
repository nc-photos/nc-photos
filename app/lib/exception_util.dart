import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/files_controller.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/exception.dart';
import 'package:nc_photos/navigation_manager.dart';
import 'package:nc_photos/widget/trusted_cert_manager.dart';

class AppMessageException implements Exception {
  const AppMessageException(this.message);

  final String message;
}

/// Convert an exception to a user-facing string
///
/// Typically used with SnackBar to show a proper error message
String toUserString(Object? exception) {
  if (exception is ApiException) {
    if (exception.response.statusCode == 401) {
      return L10n.global().errorUnauthenticated;
    } else if (exception.response.statusCode == 404) {
      return "HTTP 404 not found";
    } else if (exception.response.statusCode == 423) {
      return L10n.global().errorLocked;
    } else if (exception.response.statusCode == 500) {
      return L10n.global().errorServerError;
    }
  } else if (exception is SocketException) {
    return L10n.global().errorDisconnected;
  } else if (exception is InvalidBaseUrlException) {
    return L10n.global().errorInvalidBaseUrl;
  } else if (exception is AlbumDowngradeException) {
    return L10n.global().errorAlbumDowngrade;
  }
  return exception?.toString() ?? "Unknown error";
}

(String text, SnackBarAction? action) exceptionToSnackBarData(
  Object? exception,
) {
  if (exception is ApiException) {
    if (exception.response.statusCode == 401) {
      return (L10n.global().errorUnauthenticated, null);
    } else if (exception.response.statusCode == 404) {
      return ("HTTP 404 not found", null);
    } else if (exception.response.statusCode == 423) {
      return (L10n.global().errorLocked, null);
    } else if (exception.response.statusCode == 500) {
      return (L10n.global().errorServerError, null);
    }
  } else if (exception is SocketException) {
    return (L10n.global().errorDisconnected, null);
  } else if (exception is InvalidBaseUrlException) {
    return (L10n.global().errorInvalidBaseUrl, null);
  } else if (exception is AlbumDowngradeException) {
    return (L10n.global().errorAlbumDowngrade, null);
  } else if (exception is HandshakeException) {
    return (
      L10n.global().serverCertErrorDialogTitle,
      SnackBarAction(
        label: L10n.global().configButtonLabel,
        onPressed:
            () => NavigationManager().getNavigator()?.pushNamed(
              TrustedCertManager.routeName,
            ),
      ),
    );
  } else if (exception is UpdatePropertyFailureError) {
    return (
      "Failed to update files: ${exception.files.map((f) => f.filename).join(", ")}",
      null,
    );
  } else if (exception is AppMessageException) {
    return (exception.message, null);
  }
  return (exception?.toString() ?? "Unknown error", null);
}

(Object, StackTrace) firstErrorOf2(ParallelWaitError e) {
  if (e.errors.$1 != null) {
    return (e.errors.$1!, e.errors.$1!.stackTrace);
  } else {
    return (e.errors.$2!, e.errors.$2!.stackTrace);
  }
}
