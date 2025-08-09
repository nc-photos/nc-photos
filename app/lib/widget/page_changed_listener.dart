import 'package:flutter/widgets.dart';

class PageChangedListener {
  PageChangedListener(this.pageController, {this.onPageChanged})
    : _prevPage = pageController.initialPage;

  void call() {
    if (pageController.hasClients) {
      final page = pageController.page!.round();
      if (page != _prevPage) {
        onPageChanged?.call(_prevPage, page);
        _prevPage = page;
      }
    }
  }

  final PageController pageController;
  final void Function(int from, int to)? onPageChanged;
  int _prevPage;
}
