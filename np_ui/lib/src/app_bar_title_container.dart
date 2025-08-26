import 'package:flutter/material.dart';
import 'package:np_ui/src/material3.dart';

/// App bar title with optional subtitle and leading icon
class AppBarTitleContainer extends StatelessWidget {
  const AppBarTitleContainer({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          SizedBox(
            height: 40,
            width: 40,
            child: Center(
              child: IconTheme(
                data: IconThemeData(
                  size: 24,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
                child: icon!,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultTextStyle(
                style:
                    subtitle == null
                        ? Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).appBarTheme.foregroundColor,
                        )
                        : Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).appBarTheme.foregroundColor,
                        ),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.clip,
                child: title,
              ),
              if (subtitle != null)
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: M3.of(context).listTile.enabled.supportingText,
                  ),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.clip,
                  child: subtitle!,
                ),
            ],
          ),
        ),
      ],
    );
  }

  final Widget title;
  final Widget? subtitle;
  final Widget? icon;
}
