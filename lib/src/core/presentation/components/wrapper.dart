import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({
    super.key,
    this.width,
    this.height,
    this.onPressed,
    this.disabled = false,
    this.child,
    this.bottom,
    this.label,
    this.suffixLabel,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(8),
    this.margin, // = const EdgeInsets.all(2)
    this.border,
    this.useBoxShadow = true,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.labelCrossAxisAlignment = CrossAxisAlignment.center,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  final VoidCallback? onPressed;

  /// disable touch event {onPressed}
  final bool disabled;

  final double? width;
  final double? height;

  final Widget? child;
  final Widget? bottom;
  final WrapperLabel? label;
  final Widget? suffixLabel;

  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? border;
  final bool useBoxShadow;
  final BorderRadius? borderRadius;

  final CrossAxisAlignment crossAxisAlignment;
  final CrossAxisAlignment labelCrossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: InkWell(
        onTap: disabled ? null : onPressed,
        borderRadius: borderRadius,
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            border: border,
            borderRadius: borderRadius,
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
                  crossAxisAlignment: labelCrossAxisAlignment,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    label ?? const SizedBox.shrink(),
                    suffixLabel ?? const SizedBox.shrink(),
                  ],
                ),
              child ?? const SizedBox.shrink(),
              if (bottom != null) bottom!,
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
    this.icon,
    required this.labelText,
    this.labelStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.iconColor,
  });

  final IconData? icon;
  final String labelText;
  final TextStyle? labelStyle;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[Icon(icon!, color: iconColor), const SizedBox(width: 4)],
        Text(labelText, style: labelStyle),
      ],
    );
  }
}
