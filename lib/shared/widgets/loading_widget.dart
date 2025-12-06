import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Reusable loading widget with NVS styling
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.message,
    this.size = AppConstants.iconSizeLarge,
    this.color,
  });
  final String? message;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: AppConstants.borderWidthThick,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? theme.colorScheme.primary,
              ),
            ),
          ),
          if (message != null) ...<Widget>[
            const SizedBox(height: AppConstants.spacingM),
            Text(
              message!,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Full screen loading overlay
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.message,
    this.show = false,
  });
  final String? message;
  final bool show;

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();

    return ColoredBox(
      color: Colors.black54,
      child: LoadingWidget(
        message: message,
      ),
    );
  }
}
