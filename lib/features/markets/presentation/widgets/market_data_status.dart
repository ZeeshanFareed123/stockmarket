import 'package:flutter/material.dart';
import 'package:stockubl/app/theme/app_colors.dart';
import 'package:stockubl/app/theme/app_radius.dart';
import 'package:stockubl/app/theme/app_spacing.dart';
import 'package:stockubl/shared/market_data/domain/entities/market_stream_status.dart';

class MarketDataStatus extends StatelessWidget {
  const MarketDataStatus({required this.status, super.key});

  final MarketStreamStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isConnected = status.connection == MarketStreamConnection.connected;
    final isWorking =
        status.connection == MarketStreamConnection.connecting ||
        status.connection == MarketStreamConnection.reconnecting;
    final color = isConnected
        ? AppColors.gain
        : isWorking
        ? colors.primary
        : colors.onSurfaceVariant;
    final label = switch (status.connection) {
      MarketStreamConnection.connected => 'Live prices connected',
      MarketStreamConnection.connecting => 'Connecting live prices',
      MarketStreamConnection.reconnecting => 'Reconnecting live prices',
      MarketStreamConnection.paused => 'Live prices paused',
      MarketStreamConnection.failed => 'Live prices unavailable',
      MarketStreamConnection.disconnected => 'Preparing live prices',
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isConnected)
            Text(
              'REALTIME',
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
        ],
      ),
    );
  }
}
