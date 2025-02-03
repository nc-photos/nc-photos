part of 'connect.dart';

class _AskWebDavUrlRequest {
  const _AskWebDavUrlRequest(this.account);

  final Account account;
}

class _InvalidWevDavUrlException implements Exception {
  const _InvalidWevDavUrlException({
    required this.account,
  });

  final Account account;
}
