import 'package:nc_photos/account.dart';
import 'package:nc_photos/di_container.dart';
import 'package:nc_photos/entity/recognize_face.dart';

class ListRecognizeFace {
  const ListRecognizeFace(this._c);

  /// List all [RecognizeFace]s belonging to [account]
  Stream<List<RecognizeFace>> call(
    Account account, {
    required bool shouldUseApiKey,
  }) =>
      _c.recognizeFaceRepo.getFaces(account, shouldUseApiKey: shouldUseApiKey);

  final DiContainer _c;
}
