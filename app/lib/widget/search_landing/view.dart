part of '../search_landing.dart';

class _PersonItemView extends StatelessWidget {
  const _PersonItemView({
    required this.account,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(72 / 2),
              child: PersonThumbnail(
                dimension: 72,
                account: account,
                person: item.person,
                coverUrl: item.coverUrl,
                coverMime: item.coverMime,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _LabelView(label: item.name)),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: content,
      );
    } else {
      return content;
    }
  }

  final Account account;
  final _PersonItem item;
  final VoidCallback? onTap;
}

class _PlaceItemView extends StatelessWidget {
  const _PlaceItemView({
    required this.account,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: _LocationCoverImage(
              dimension: 72,
              account: account,
              coverUrl: item.coverUrl,
              coverMime: item.coverMime,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _LabelView(label: item.name)),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: content,
      );
    } else {
      return content;
    }
  }

  final Account account;
  final _PlaceItem item;
  final VoidCallback? onTap;
}

class _LabelView extends StatelessWidget {
  const _LabelView({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: Text(
        label + "\n",
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  final String label;
}

class _LocationCoverPlaceholder extends StatelessWidget {
  const _LocationCoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Icon(
        Icons.location_on,
        color: Theme.of(context).listPlaceholderForegroundColor,
      ),
    );
  }
}

class _LocationCoverImage extends StatelessWidget {
  const _LocationCoverImage({
    required this.dimension,
    required this.account,
    required this.coverUrl,
    required this.coverMime,
  });

  @override
  Widget build(BuildContext context) {
    Widget cover;
    try {
      cover = NetworkRectThumbnail(
        account: account,
        imageUrl: coverUrl!,
        mime: coverMime,
        errorBuilder: (_) => const _LocationCoverPlaceholder(),
      );
    } catch (_) {
      cover = const FittedBox(
        child: _LocationCoverPlaceholder(),
      );
    }

    return SizedBox.square(
      dimension: dimension,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(dimension / 2),
        child: Container(
          color: Theme.of(context).listPlaceholderBackgroundColor,
          constraints: const BoxConstraints.expand(),
          child: cover,
        ),
      ),
    );
  }

  final double dimension;
  final Account account;
  final String? coverUrl;
  final String? coverMime;
}
