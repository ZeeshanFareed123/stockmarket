// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_data_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MarketDataController)
const marketDataControllerProvider = MarketDataControllerProvider._();

final class MarketDataControllerProvider
    extends $NotifierProvider<MarketDataController, MarketDataState> {
  const MarketDataControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketDataControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketDataControllerHash();

  @$internal
  @override
  MarketDataController create() => MarketDataController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarketDataState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarketDataState>(value),
    );
  }
}

String _$marketDataControllerHash() =>
    r'62d38b09e57e85111f9fc45718a43d0417b4e9b7';

abstract class _$MarketDataController extends $Notifier<MarketDataState> {
  MarketDataState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MarketDataState, MarketDataState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MarketDataState, MarketDataState>,
              MarketDataState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
