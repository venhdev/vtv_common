import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton({
    super.key,
    this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    required this.label,
    // this.reversePosition = false,
    this.reverseDirection = false,
    this.style,
    this.fontSize,
    this.iconSize,
    this.padding,
    this.iconColor,
  });
  // Required parameters
  final IconData? leadingIcon; // Icon now is optional
  final IconData? trailingIcon; // Icon now is optional
  final String label;
  final void Function()? onPressed;

  // Optional parameters
  // Decorations
  final ButtonStyle? style;

  /// If true, the icon will be placed after the text
  // final bool reversePosition; //! no longer used >> leadingIcon and trailingIcon

  /// If true, the icon and text will be placed vertically
  final bool reverseDirection;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;

  /// default is 24
  final double? iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      padding: padding ?? EdgeInsets.zero,
      style: style ??
          IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      icon: !reverseDirection
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // make the button as small as possible
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: iconSize, color: iconColor),
                  const SizedBox(width: 4),
                ],

                Text(label, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),

                if (trailingIcon != null) ...[
                  const SizedBox(width: 4),
                  if (trailingIcon != null) Icon(trailingIcon, size: iconSize, color: iconColor),
                ]
                //*---------------------NO LONGER USE-----------------------*//
                // if (!reversePosition) ...[
                //   Icon(leadingIcon, size: iconSize, color: iconColor),
                //   const SizedBox(width: 4),
                //   Text(label,
                //       style: TextStyle(
                //         fontSize: fontSize,
                //         fontWeight: FontWeight.bold,
                //       )),
                //   if (trailingIcon != null) ...[
                //     const SizedBox(width: 4),
                //     if (trailingIcon != null) Icon(trailingIcon, size: iconSize, color: iconColor),
                //   ]
                // ] else ...[
                //   if (trailingIcon != null) ...[
                //     if (trailingIcon != null) Icon(trailingIcon, size: iconSize, color: iconColor),
                //     const SizedBox(width: 4),
                //   ],
                //   Text(label,
                //       style: TextStyle(
                //         fontSize: fontSize,
                //         fontWeight: FontWeight.bold,
                //       )),
                //   const SizedBox(width: 4),
                //   Icon(leadingIcon, size: iconSize, color: iconColor),
                // ]
                //*---------------------NO LONGER USE-----------------------*//
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min, // make the button as small as possible
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, size: iconSize, color: iconColor),
                  const SizedBox(height: 4),
                ],

                Text(label, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),

                if (trailingIcon != null) ...[
                  const SizedBox(height: 4),
                  if (trailingIcon != null) Icon(trailingIcon, size: iconSize, color: iconColor),
                ]

                //*---------------------NO LONGER USE-----------------------*//
                // if (!reversePosition) ...[
                //   if (leadingIcon != null) Icon(leadingIcon, size: iconSize, color: iconColor),
                //   const SizedBox(width: 4),
                //   Text(label,
                //       style: TextStyle(
                //         fontSize: fontSize,
                //         fontWeight: FontWeight.bold,
                //       )),
                // ] else ...[
                //   Text(label,
                //       style: TextStyle(
                //         fontSize: fontSize,
                //         fontWeight: FontWeight.bold,
                //       )),
                //   const SizedBox(width: 4),
                //   if (leadingIcon != null) Icon(leadingIcon, size: iconSize, color: iconColor),
                // ]
              ],
            ),
    );
  }
}
