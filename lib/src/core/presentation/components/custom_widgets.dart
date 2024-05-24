import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({
    super.key,
    required this.message,
    this.textStyle,
    this.icon,
    this.buttonLabel = 'Thử lại',
    this.onPressed,
  });
  factory MessageScreen.error([String? message, Icon? icon, void Function()? onPressed]) => MessageScreen(
        message: message ?? 'Lỗi không xác định',
        icon: icon ?? const Icon(Icons.error),
        textStyle: const TextStyle(color: Colors.red),
        onPressed: onPressed,
      );

  final String message;
  final TextStyle? textStyle;
  final Icon? icon;
  final String buttonLabel;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //# icon
          if (icon != null) icon!,
          
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
