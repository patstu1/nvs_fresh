import 'package:flutter/material.dart';

/// Uppercase text helper used throughout older UI components.
class NvsCaps extends StatelessWidget {
  const NvsCaps(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = style ?? Theme.of(context).textTheme.labelLarge ?? const TextStyle();
    return Text(
      text.toUpperCase(),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.visible : TextOverflow.ellipsis,
      style: baseStyle.copyWith(
        fontFamily: baseStyle.fontFamily ?? 'BellGothic',
        letterSpacing: baseStyle.letterSpacing ?? 1.2,
      ),
    );
  }
}






