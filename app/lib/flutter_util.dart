import 'package:flutter/material.dart';
import 'package:nc_photos/entity/file_descriptor.dart';

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

String getImageHeroTag(FileDescriptor file) => "imageHero(${file.fdPath})";

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
