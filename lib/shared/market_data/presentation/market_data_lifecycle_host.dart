import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stockubl/app/config/app_config_provider.dart';
import 'package:stockubl/shared/market_data/application/market_data_controller.dart';

class MarketDataLifecycleHost extends ConsumerStatefulWidget {
  const MarketDataLifecycleHost({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<MarketDataLifecycleHost> createState() =>
      _MarketDataLifecycleHostState();
}

class _MarketDataLifecycleHostState
    extends ConsumerState<MarketDataLifecycleHost>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final symbols = ref.read(appConfigProvider).initialMarketSymbols;
      unawaited(ref.read(marketDataControllerProvider.notifier).start(symbols));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = ref.read(marketDataControllerProvider.notifier);
    switch (state) {
      case AppLifecycleState.resumed:
        unawaited(controller.resume());
      case AppLifecycleState.paused ||
          AppLifecycleState.hidden ||
          AppLifecycleState.detached:
        unawaited(controller.pause());
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(marketDataControllerProvider);
    return widget.child;
  }
}
