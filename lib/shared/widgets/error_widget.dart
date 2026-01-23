import 'package:flutter/material.dart';

/// Custom error widget with retry functionality
class AppErrorWidget extends StatelessWidget {
  final String message;
  final String? subtitle;
  final VoidCallback? onRetry;
  final IconData icon;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.subtitle,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  /// Factory for network errors
  factory AppErrorWidget.network({VoidCallback? onRetry}) {
    return AppErrorWidget(
      message: 'No Internet Connection',
      subtitle: 'Please check your network and try again',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }

  /// Factory for server errors
  factory AppErrorWidget.server({VoidCallback? onRetry}) {
    return AppErrorWidget(
      message: 'Server Error',
      subtitle: 'Something went wrong. Please try again later',
      icon: Icons.cloud_off,
      onRetry: onRetry,
    );
  }

  /// Factory for timeout errors
  factory AppErrorWidget.timeout({VoidCallback? onRetry}) {
    return AppErrorWidget(
      message: 'Request Timed Out',
      subtitle: 'The server took too long to respond',
      icon: Icons.timer_off,
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
