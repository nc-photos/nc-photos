import 'package:flutter/material.dart';
import 'package:nc_photos/entity/any_file/any_file.dart';
import 'package:nc_photos/entity/file_descriptor.dart';
import 'package:nc_photos/entity/local_file.dart';

class CustomizableMaterialPageRoute extends MaterialPageRoute {
  CustomizableMaterialPageRoute({
    required super.builder,
    super.settings,
    super.maintainState,
    super.fullscreenDialog,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
  });

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;
}

class HeroTag {
  const HeroTag(this.tag);

  factory HeroTag.fromFile(FileDescriptor file) =>
      HeroTag("imageHero(${AnyFileNextcloudProvider.toAfId(file.fdId)})");

  factory HeroTag.fromLocalFile(LocalFile file) =>
      HeroTag("imageHero(${AnyFileLocalProvider.toAfId(file.id)})");

  factory HeroTag.fromAnyFile(AnyFile file) => HeroTag("imageHero(${file.id})");

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is HeroTag && tag == other.tag);

  @override
  int get hashCode => tag.hashCode;

  final String tag;
}

String getCollectionHeroTag(String coverUrl) => "collectionHero($coverUrl)";

// copied from flutter
Widget defaultHeroFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final Hero toHero = toHeroContext.widget as Hero;

  final MediaQueryData? toMediaQueryData = MediaQuery.maybeOf(toHeroContext);
  final MediaQueryData? fromMediaQueryData = MediaQuery.maybeOf(
    fromHeroContext,
  );

  if (toMediaQueryData == null || fromMediaQueryData == null) {
    return toHero.child;
  }

  final EdgeInsets fromHeroPadding = fromMediaQueryData.padding;
  final EdgeInsets toHeroPadding = toMediaQueryData.padding;

  return AnimatedBuilder(
    animation: animation,
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: toMediaQueryData.copyWith(
          padding:
              (flightDirection == HeroFlightDirection.push)
                  ? EdgeInsetsTween(
                    begin: fromHeroPadding,
                    end: toHeroPadding,
                  ).evaluate(animation)
                  : EdgeInsetsTween(
                    begin: toHeroPadding,
                    end: fromHeroPadding,
                  ).evaluate(animation),
        ),
        child: toHero.child,
      );
    },
  );
}
