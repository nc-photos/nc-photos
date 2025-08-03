class LoginResult {
  const LoginResult({
    required this.server,
    required this.username,
    required this.password,
  });

  final Uri server;
  final String username;
  final String password;
}
