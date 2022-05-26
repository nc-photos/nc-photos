import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/help_utils.dart' as help_util;
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/update_checker.dart' as checker;
import 'package:nc_photos/url_launcher_util.dart';

class UpdateChecker extends StatefulWidget {
  static const routeName = "/update-checker";

  static Route buildRoute() =>
      MaterialPageRoute(builder: (context) => const UpdateChecker());

  const UpdateChecker({super.key});

  @override
  createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {
  @override
  initState() {
    super.initState();
    _work();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Builder(builder: _buildContent),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Photos ${k.versionStr}",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Align(alignment: Alignment.center, child: _getStatusWidget()),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      _getStatusText(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_result == checker.UpdateCheckerResult.updateAvailable)
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_updateUrl != null) {
                            launch(_updateUrl!);
                          } else {
                            // fallback
                            launch("https://bit.ly/3wNLHFo");
                          }
                        },
                        child: const Text("GET UPDATE"),
                      ),
                    )
                  else
                    const SizedBox(height: 48),
                  const SizedBox(height: 56),
                  Center(
                    child: Text(
                      L10n.global().donationShortMessage,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        launch(help_util.donateUrl);
                      },
                      child: Text(L10n.global().donationButtonLabel),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Expanded(child: Text("Having problems?")),
              TextButton(
                onPressed: () {
                  launch("https://bit.ly/3wNLHFo");
                },
                child: const Text("CHECK MANUALLY"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _work() async {
    await Future.delayed(const Duration(seconds: 1));
    final uc = checker.UpdateChecker();
    final result = await uc();
    if (result == checker.UpdateCheckerResult.updateAvailable) {
      _updateUrl = uc.updateUrl;
      _versionStr = uc.versionStr;
    }
    if (mounted) {
      setState(() {
        _result = result;
      });
    }
  }

  Widget _getStatusWidget() {
    if (_result == null) {
      return const SizedBox(
        width: _statusIconSize,
        height: _statusIconSize,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      switch (_result!) {
        case checker.UpdateCheckerResult.updateAvailable:
          return Icon(
            Icons.upload,
            color: Colors.orange[700],
            size: _statusIconSize,
          );

        case checker.UpdateCheckerResult.alreadyLatest:
          return Icon(
            Icons.done,
            color: Colors.green[600],
            size: _statusIconSize,
          );

        case checker.UpdateCheckerResult.error:
          return Icon(
            Icons.warning,
            color: Colors.red[700],
            size: _statusIconSize,
          );
      }
    }
  }

  String _getStatusText() {
    if (_result == null) {
      return "Checking...";
    } else {
      switch (_result!) {
        case checker.UpdateCheckerResult.updateAvailable:
          return "Update available ($_versionStr)";

        case checker.UpdateCheckerResult.alreadyLatest:
          return "You are running the latest version";

        case checker.UpdateCheckerResult.error:
          return "Failed checking for updates";
      }
    }
  }

  checker.UpdateCheckerResult? _result;
  String? _updateUrl;
  String? _versionStr;

  static const _statusIconSize = 72.0;
}
