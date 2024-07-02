import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({
    super.key,
    required this.message,
    this.textStyle,
    this.icon,
    this.buttonLabel = 'Thử lại',
    this.onPressed,
    this.onIconLongPressed,
  });

  factory MessageScreen.error([
    String? message,
    Icon? icon,
  ]) =>
      MessageScreen(
        message: message ?? 'Lỗi không xác định',
        icon: icon ?? const Icon(Icons.error),
        textStyle: const TextStyle(color: Colors.red),
      );

  factory MessageScreen.info([
    String message = '',
    Icon? icon,
  ]) =>
      MessageScreen(
        message: message,
        icon: icon ?? const Icon(Icons.info),
        textStyle: const TextStyle(color: Colors.blue),
      );

  final String message;
  final TextStyle? textStyle;
  final Widget? icon;
  final String buttonLabel;
  final void Function()? onPressed;
  final VoidCallback? onIconLongPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //# icon
          if (icon != null)
            GestureDetector(
              onLongPress: onIconLongPressed,
              child: icon!,
            ),

          //# message
          Text(message, style: textStyle),

          //# button
          if (onPressed != null) ...[
            ElevatedButton(
              onPressed: () {
                onPressed!();
              },
              child: Text(buttonLabel),
            ),
          ]
        ],
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.centerText = false,
    this.trailing,
    this.leading,
  });

  final Color? color;
  final String text;
  final double? fontSize;
  final bool centerText;

  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leading != null) leading!,
        if (centerText) Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        Expanded(child: Divider(color: color)),
        if (trailing != null) trailing!,
      ],
    );
  }
}
