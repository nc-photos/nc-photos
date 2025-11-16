import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nc_photos/app_localizations.dart';
import 'package:nc_photos/controller/pref_controller.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/k.dart' as k;
import 'package:nc_photos/mobile/android/permission_util.dart';
import 'package:nc_photos/platform/features.dart';
import 'package:nc_photos/widget/home/home.dart';
import 'package:nc_photos/widget/local_root_picker/local_root_picker.dart';
import 'package:nc_photos/widget/sign_in/sign_in.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

bool isNeedSetup() => Pref().getSetupProgressOr() & _PageId.all != _PageId.all;

class Setup extends StatefulWidget {
  static const routeName = "/setup";

  static Route buildRoute(RouteSettings settings) => MaterialPageRoute(
    builder: (context) => const Setup(),
    settings: settings,
  );

  const Setup({super.key});

  @override
  createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Builder(builder: (context) => _buildContent(context)),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(title: Text(L10n.global().setupWidgetTitle), elevation: 0);
  }

  Widget _buildContent(BuildContext context) {
    final page = _pageController.hasClients ? _pageController.page!.round() : 0;
    final pages = <_Page>[
      if (_initialProgress & _PageId.exif == 0) _Exif(),
      if (_initialProgress & _PageId.hiddenPrefDirNotice == 0)
        _HiddenPrefDirNotice(),
      if (isSupportLocalFiles && (_initialProgress & _PageId.localFiles == 0))
        _LocalFiles(key: _localFilesKey),
    ];
    final isLastPage = page >= pages.length - 1;
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: pages,
            onPageChanged: (page) {
              setState(() {
                _currentPageNotifier.value = page;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:
                    isLastPage
                        ? [
                          ElevatedButton(
                            onPressed: () {
                              _onDonePressed(pages.last.getPageId());
                            },
                            child: Text(L10n.global().doneButtonLabel),
                          ),
                        ]
                        : [
                          ElevatedButton(
                            onPressed: () {
                              if (_pageController.hasClients) {
                                _onNextPressed(
                                  pages[_pageController.page!.round()]
                                      .getPageId(),
                                );
                              }
                            },
                            child: Text(L10n.global().nextButtonLabel),
                          ),
                        ],
              ),
              CirclePageIndicator(
                itemCount: pages.length,
                currentPageNotifier: _currentPageNotifier,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onDonePressed(int pageId) {
    Pref().setSetupProgress(Pref().getSetupProgressOr() | pageId);

    if (pageId == _PageId.localFiles) {
      _localFilesKey.currentState?.save();
    }

    final account = context.read<PrefController>().currentAccountValue;
    if (account == null) {
      Navigator.pushReplacementNamed(context, SignIn.routeName);
    } else {
      Navigator.pushReplacementNamed(
        context,
        Home.routeName,
        arguments: HomeArguments(account),
      );
    }
  }

  void _onNextPressed(int pageId) {
    Pref().setSetupProgress(Pref().getSetupProgressOr() | pageId);

    if (pageId == _PageId.localFiles) {
      _localFilesKey.currentState?.save();
    }

    _pageController.nextPage(
      duration: k.animationDurationNormal,
      curve: Curves.easeInOut,
    );
  }

  final _initialProgress = Pref().getSetupProgressOr();
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  final _localFilesKey = GlobalKey<_LocalFilesState>();
}

class _PageId {
  static const exif = 0x01;
  static const hiddenPrefDirNotice = 0x02;
  static const localFiles = 0x04;
  static final all =
      exif | hiddenPrefDirNotice | (isSupportLocalFiles ? localFiles : 0);
}

abstract interface class _Page implements Widget {
  int getPageId();
}

class _Exif extends StatefulWidget implements _Page {
  @override
  createState() => _ExifState();

  @override
  getPageId() => _PageId.exif;
}

class _ExifState extends State<_Exif> {
  @override
  build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: Text(L10n.global().settingsExifSupportTitle2),
            value: _isEnableExif,
            onChanged: _onValueChanged,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(L10n.global().exifSupportDetails),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(L10n.global().exifSupportNextcloud28Notes),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              L10n.global().setupSettingsModifyLaterHint,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  @override
  dispose() {
    super.dispose();
    // persist user's choice
    Pref().setEnableExif(_isEnableExif);
  }

  void _onValueChanged(bool value) {
    setState(() {
      _isEnableExif = value;
    });
  }

  bool _isEnableExif = Pref().isEnableExifOr();
}

class _HiddenPrefDirNotice extends StatefulWidget implements _Page {
  @override
  createState() => _HiddenPrefDirNoticeState();

  @override
  getPageId() => _PageId.hiddenPrefDirNotice;
}

class _HiddenPrefDirNoticeState extends State<_HiddenPrefDirNotice> {
  @override
  build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(L10n.global().setupHiddenPrefDirNoticeDetail),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/setup_hidden_pref_dir.png",
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _LocalFiles extends StatefulWidget implements _Page {
  const _LocalFiles({super.key});

  @override
  State<StatefulWidget> createState() => _LocalFilesState();

  @override
  int getPageId() => _PageId.localFiles;
}

class _LocalFilesState extends State<_LocalFiles> {
  @override
  void initState() {
    super.initState();
    requestReadMediaForResult().then((_) {
      setState(() {
        _isReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isReady
        ? LocalRootPicker(
          key: _key,
          switchTitle: L10n.global().settingsDeviceMediaTitle,
        )
        : const Center(child: CircularProgressIndicator());
  }

  void save() {
    _key.currentState?.save();
  }

  final _key = GlobalKey<LocalRootPickerState>();
  var _isReady = false;
}
