import 'package:flutter/material.dart';
import 'package:np_ui/src/material3.dart';

/// A [ListTile]-like widget with unbounded height
class UnboundedListTile extends StatelessWidget {
  const UnboundedListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 16)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: M3.of(context).listTile.enabled.headline,
                  ),
                  child: title,
                ),
                if (subtitle != null)
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: M3.of(context).listTile.enabled.supportingText,
                    ),
                    child: subtitle!,
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(onTap: onTap, child: content);
    } else {
      return content;
    }
  }

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
}
