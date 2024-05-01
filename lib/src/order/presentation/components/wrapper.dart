import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({
    super.key,
    this.onPressed,
    this.child,
    this.label,
    this.suffixLabel,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(8),
    this.margin, // = const EdgeInsets.all(2)
    this.border,
    this.useBoxShadow = true,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final VoidCallback? onPressed;

  final Widget? child;
  final WrapperLabel? label;
  final Widget? suffixLabel;

  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final bool useBoxShadow;

  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(4),
            color: backgroundColor,
            boxShadow: useBoxShadow
                ? [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              if (label != null || suffixLabel != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    label ?? const SizedBox.shrink(),
                    suffixLabel ?? const SizedBox.shrink(),
                  ],
                ),
              child ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class WrapperLabel extends StatelessWidget {
  const WrapperLabel({
    super.key,
    required this.icon,
    required this.labelText,
    this.labelStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.iconColor,
  });

  final IconData icon;
  final String labelText;
  final TextStyle? labelStyle;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(width: 4),
        Text(labelText, style: labelStyle),
      ],
    );
  }
}
