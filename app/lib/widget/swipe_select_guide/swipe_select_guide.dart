import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/widget/selectable.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

part 'preview_item_animation.dart';
part 'swipe_select_animation.dart';

class SwipeSelectGuide extends StatefulWidget {
  const SwipeSelectGuide({super.key});

  @override
  State<StatefulWidget> createState() => _SwipeSelectGuideState();
}

class _SwipeSelectGuideState extends State<SwipeSelectGuide> {
  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.hasClients && _pageController.page != null) {
        final currPage = _pageController.page!.round();
        if (_page.value != currPage) {
          setState(() {
            _page.value = currPage;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: _pageAnimationHeight + 60,
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) => switch (index) {
                    1 => const _PreviewItemPage(),
                    0 || _ => const _SwipeSelectPage(),
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_page.value > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: k.animationDurationNormal,
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text("Back"),
                    )
                  else
                    const Spacer(),
                  if (_page.value < 1)
                    TextButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: k.animationDurationNormal,
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text("Next"),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close"),
                    ),
                ],
              ),
              CirclePageIndicator(currentPageNotifier: _page, itemCount: 2),
            ],
          ),
        ],
      ),
    );
  }

  final _page = ValueNotifier<int>(0);
  final _pageController = PageController(keepPage: false);
}

class _SwipeSelectPage extends StatelessWidget {
  const _SwipeSelectPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: _pageAnimationHeight,
          child: _SwipeSelectAnimation(),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Text(L10n.global().swipeSelectGuide),
          ),
        ),
      ],
    );
  }
}

class _PreviewItemPage extends StatelessWidget {
  const _PreviewItemPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: _pageAnimationHeight,
          child: _PreviewItemAnimation(),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Text(L10n.global().selectionModePreviewGuide),
          ),
        ),
      ],
    );
  }
}

const _pageAnimationHeight = 280.0;
