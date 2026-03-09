part of 'image_editor.dart';

class _ToolBar extends StatelessWidget {
  const _ToolBar();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 16),
            _BlocSelector(
              selector: (state) => state.activeTool,
              builder:
                  (context, activeTool) => _ToolButton(
                    icon: Icons.palette_outlined,
                    label: L10n.global().imageEditToolbarColorLabel,
                    isSelected: activeTool == _ToolType.color,
                    onPressed: () {
                      context.addEvent(const _SetActiveTool(_ToolType.color));
                    },
                  ),
            ),
            _BlocSelector(
              selector: (state) => state.activeTool,
              builder:
                  (context, activeTool) => _ToolButton(
                    icon: Icons.auto_awesome,
                    label: L10n.global().imageEditToolbarEffectLabel,
                    isSelected: activeTool == _ToolType.effect,
                    onPressed: () {
                      context.addEvent(const _SetActiveTool(_ToolType.effect));
                    },
                  ),
            ),
            _BlocSelector(
              selector: (state) => state.activeTool,
              builder:
                  (context, activeTool) => _ToolButton(
                    icon: Icons.transform_outlined,
                    label: L10n.global().imageEditToolbarTransformLabel,
                    isSelected: activeTool == _ToolType.transform,
                    onPressed: () {
                      context.addEvent(
                        const _SetActiveTool(_ToolType.transform),
                      );
                    },
                  ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Theme.of(context).colorScheme.secondaryContainer
                        : null,
                // borderRadius: const BorderRadius.all(Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.onSecondaryContainer
                            : M3.of(context).filterChip.disabled.labelText,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color:
                          isSelected
                              ? Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer
                              : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isSelected;
}
