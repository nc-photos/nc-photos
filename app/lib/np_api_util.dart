import 'package:nc_photos/account.dart';
import 'package:np_api/np_api.dart';

class ApiUtil {
  static Api fromAccount(Account account) => Api(
    Uri.parse(account.url),
    BasicAuth(account.username2, account.password),
  );
}

class AuthUtil {
  static BasicAuth fromAccount(Account account) =>
      BasicAuth(account.username2, account.password);
}
