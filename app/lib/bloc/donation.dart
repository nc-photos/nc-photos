import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logging/logging.dart';
import 'package:np_collection/np_collection.dart';
import 'package:np_platform_util/np_platform_util.dart';

class StoreProduct {
  const StoreProduct(this.details);

  static StoreProduct? of(ProductDetails details) {
    if (!_products.keys.contains(details.id)) {
      _log.severe("[of] Unknown product ID: ${details.id}");
      return null;
    } else {
      return StoreProduct(details);
    }
  }

  String get title => _products[details.id]!["title"]!;
  String get price => details.price;

  final ProductDetails details;

  static const _products = <String, Map>{};

  static final _log = Logger("bloc.donation.StoreProduct");
}

class StoreException implements Exception {
  static final storeName =
      getRawPlatform() == NpPlatform.android ? "Play Store" : "App Store";

  const StoreException([this.message]);

  @override
  toString() {
    if (message == null) {
      return "StoreException";
    } else {
      return "StoreException: $message";
    }
  }

  final Object? message;
}

abstract class DonationBlocEvent {
  const DonationBlocEvent();
}

class DonationBlocQuery extends DonationBlocEvent {
  const DonationBlocQuery();
}

abstract class DonationBlocState {
  const DonationBlocState(this.products);

  @override
  toString() => "$runtimeType {"
      "products: List {length: ${products.length}}, "
      "}";

  final List<StoreProduct> products;
}

class DonationBlocInit extends DonationBlocState {
  const DonationBlocInit() : super(const []);
}

class DonationBlocLoading extends DonationBlocState {
  const DonationBlocLoading(super.products);
}

class DonationBlocSuccess extends DonationBlocState {
  const DonationBlocSuccess(super.products);
}

class DonationBlocFailure extends DonationBlocState {
  const DonationBlocFailure(super.products, this.exception);

  @override
  toString() => "$runtimeType {"
      "super: ${super.toString()}, "
      "exception: $exception, "
      "}";

  final Object exception;
}

class DonationBloc extends Bloc<DonationBlocEvent, DonationBlocState> {
  DonationBloc() : super(const DonationBlocInit()) {
    on<DonationBlocEvent>(_onEvent);
  }

  Future<void> _onEvent(
      DonationBlocEvent event, Emitter<DonationBlocState> emit) async {
    _log.info("[_onEvent] $event");
    if (event is DonationBlocQuery) {
      await _onEventQuery(event, emit);
    }
  }

  Future<void> _onEventQuery(
      DonationBlocQuery ev, Emitter<DonationBlocState> emit) async {
    try {
      emit(DonationBlocLoading(state.products));
      if (!await InAppPurchase.instance.isAvailable()) {
        emit(DonationBlocFailure(
            [], StoreException("${StoreException.storeName} is unavilable")));
        return;
      }
      final response = await InAppPurchase.instance
          .queryProductDetails(StoreProduct._products.keys.toSet());
      if (response.notFoundIDs.isNotEmpty) {
        _log.warning(
            "[_onEventQuery] Product IDs not found: ${response.notFoundIDs.toReadableString()}");
      }
      final productMap = Map.fromEntries(response.productDetails
          .map((e) => MapEntry(e.id, StoreProduct.of(e))));
      final products = StoreProduct._products.keys
          .map((id) => productMap[id])
          .whereNotNull()
          .toList();
      emit(DonationBlocSuccess(products));
    } catch (e, stackTrace) {
      _log.severe("[_onEventQuery] Exception while request", e, stackTrace);
      emit(DonationBlocFailure([], e));
    }
  }

  static final _log = Logger("bloc.donation.DonationBloc");
}
