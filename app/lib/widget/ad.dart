import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logging/logging.dart';
import 'package:nc_photos/ad_helper.dart';
import 'package:nc_photos/entity/pref.dart';
import 'package:nc_photos/url_launcher_util.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({
    Key? key,
  }) : super(key: key);

  @override
  createState() => AdBannerState();
}

class AdBannerState extends State<AdBanner> {
  @override
  initState() {
    super.initState();
    _initPlaceholder();
  }

  @override
  build(BuildContext context) {
    if (!_isAdLoading) {
      _isAdLoading = true;
      _createBanner(context);
    }
    return _buildAdContent(context);
  }

  @override
  dispose() {
    super.dispose();
    _ad?.dispose();
  }

  /// Set the height of the placeholder widget
  void _initPlaceholder() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAdSize().then((size) {
        _log.info(
            "[_initPlaceholder] Placeholder size: ${size?.width}x${size?.height}");
        if (size != null) {
          setState(() {
            _placeholderHeight = size.height;
          });
        }
      });
    });
  }

  Widget _buildAdContent(BuildContext context) {
    if (_isLoadFailed) {
      return Container(
        alignment: Alignment.center,
        height: _placeholderHeight?.toDouble() ?? 77,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text("Tired of ads?"),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: ElevatedButton(
                  onPressed: () {
                    launch(
                        "https://play.google.com/store/apps/details?id=com.nkming.nc_photos.paid&referrer=utm_source%3Dfreeapp");
                  },
                  child: const Text("SUPPORT THE APP"),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_ad != null) {
      return Container(
        alignment: Alignment.center,
        width: _ad!.size.width.toDouble(),
        height: _ad!.size.height.toDouble(),
        child: AdWidget(ad: _ad!),
      );
    } else {
      if (_placeholderHeight == null) {
        return const SizedBox.shrink();
      } else {
        return SizedBox(height: _placeholderHeight!.toDouble());
      }
    }
  }

  Future<void> _createBanner(BuildContext context) async {
    AdSize? size = await _getAdSize();
    if (size == null) {
      _log.severe("[_createBanner] Unable to get size of adaptive banner");
      size = AdSize.banner;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: _request,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _log.fine("[_createBanner] Ad loaded");
            _ad = ad as BannerAd;
            _log.fine(
                "[_createBanner] Size: ${_ad!.size.width} * ${_ad!.size.height}");
          });
        },
        onAdFailedToLoad: (ad, e) {
          _log.shout("[_createBanner] Failed while loading ads", e);
          ad.dispose();
          setState(() {
            _isLoadFailed = true;
          });
        },
      ),
    );
    return banner.load();
  }

  Future<AdSize?> _getAdSize() => AdSize.getAnchoredAdaptiveBannerAdSize(
        Orientation.portrait,
        MediaQuery.of(context).size.shortestSide.truncate(),
      );

  BannerAd? _ad;
  var _isAdLoading = false;
  var _isLoadFailed = false;
  int? _placeholderHeight;

  static final _log = Logger("widget.ad.AdBannerState");
}

class RewardedAdHandler {
  static bool isCooldownPeriod(Duration cooldown) {
    final lastEpoch = Pref().getLastAdRewardTime();
    if (lastEpoch == null) {
      return false;
    }
    final last = DateTime.fromMillisecondsSinceEpoch(lastEpoch).toUtc();
    final now = DateTime.now().toUtc();
    return last.isBefore(now) && now.difference(last) < cooldown;
  }

  void init() {
    _log.info("[init] Start loading ad");
    _createRewarded();
  }

  void show({
    VoidCallback? onAdDismissedFullScreenContent,
    void Function(AdError error)? onAdFailedToShowFullScreenContent,
    void Function(RewardItem reward)? onUserEarnedReward,
  }) {
    if (!isAdReady) {
      _log.warning("[show] Ad is not ready");
      return;
    }
    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _log.info("[show] onAdDismissedFullScreenContent");
        ad.dispose();
        onAdDismissedFullScreenContent?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, e) {
        _log.severe("[show] onAdFailedToShowFullScreenContent", e);
        ad.dispose();
        onAdFailedToShowFullScreenContent?.call(e);
      },
    );
    _ad!.setImmersiveMode(true);
    _ad!.show(
      onUserEarnedReward: (ad, reward) {
        _log.info("[show] onUserEarnedReward");
        onUserEarnedReward?.call(reward);
      },
    );
    _ad = null;
  }

  bool get isAdReady => _ad != null;
  bool get isGood => _loadAttempts < 3;

  void _createRewarded() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: _request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loadAttempts = 0;
        },
        onAdFailedToLoad: (e) {
          _log.shout("[_createRewarded] Failed while loading ads", e);
          ++_loadAttempts;
          if (isGood) {
            _createRewarded();
          }
        },
      ),
    );
  }

  RewardedAd? _ad;
  var _loadAttempts = 0;

  static final _log = Logger("widget.ad.RewardedAdHandler");
}

final _request =
    AdRequest(nonPersonalizedAds: !Pref().isPersonalizedAdsOr(false));
