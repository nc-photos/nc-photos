part of '../splash.dart';

class _UpgradeProgressView extends StatelessWidget {
  const _UpgradeProgressView();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector<double?>(
      selector: (state) => state.upgradeProgress,
      builder: (context, upgradeProgress) {
        if (upgradeProgress == null) {
          return const Center(
            child: SizedBox.square(
              dimension: 24,
              child: AppIntermediateCircularProgressIndicator(),
            ),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _BlocSelector<String?>(
                selector: (state) => state.upgradeText,
                builder:
                    (context, upgradeText) => Text(upgradeText ?? "Updating"),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: upgradeProgress),
            ],
          );
        }
      },
    );
  }
}
