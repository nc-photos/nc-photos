part of 'image_editor.dart';

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return _BlocSelector(
      selector: (state) => state.isModified,
      builder:
          (context, isModified) => AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              onPressed: () {
                context.addEvent(const _RequestQuit());
              },
            ),
            title: Text(L10n.global().imageEditTitle),
            actions: [
              if (isModified)
                IconButton(
                  icon: const Icon(Icons.save_outlined),
                  tooltip: L10n.global().saveTooltip,
                  onPressed: () {
                    context.addEvent(const _Save());
                  },
                ),
              IconButton(
                icon: const Icon(Icons.help_outline),
                tooltip: L10n.global().helpTooltip,
                onPressed: () {
                  launch(help_util.editPhotosUrl);
                },
              ),
            ],
          ),
    );
  }
}
