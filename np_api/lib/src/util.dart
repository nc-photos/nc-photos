import 'package:np_log/np_log.dart' as np_log;

bool isHttpStatusGood(int status) => status ~/ 100 == 2;

void initMyLog() {
  np_log.initLog(isDebugMode: np_log.isDevMode);
}
