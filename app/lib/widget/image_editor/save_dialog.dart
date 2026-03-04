part of 'image_editor.dart';

class _SaveDialog extends StatelessWidget {
  const _SaveDialog();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(child: ColoredBox(color: Colors.black38)),
        _BlocBuilder(
          buildWhen:
              (previous, current) => previous.saveState != current.saveState,
          builder:
              (context, state) => switch (state.saveState) {
                _SaveState.init => const _ProcessSaveDialog(),
                _SaveState.download => const _DownloadSaveDialog(),
                _SaveState.process => const _ProcessSaveDialog(),
                null => const _ProcessSaveDialog(),
              },
        ),
      ],
    );
  }
}

class _DownloadSaveDialog extends StatelessWidget {
  const _DownloadSaveDialog();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.downloadProgress,
      builder:
          (context, downloadProgress) => AlertDialog(
            title: const Text("Downloading image from server"),
            content: LinearProgressIndicator(value: downloadProgress),
          ),
    );
  }
}

class _ProcessSaveDialog extends StatelessWidget {
  const _ProcessSaveDialog();

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text("Processing image..."),
      content: LinearProgressIndicator(),
    );
  }
}
