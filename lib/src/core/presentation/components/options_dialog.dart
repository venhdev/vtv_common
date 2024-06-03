import 'package:flutter/material.dart';

class OptionsDialog<T> extends StatelessWidget {
  const OptionsDialog({
    super.key,
    required this.title,
    required this.options,
    this.disableOptions = const [],
    required this.optionBuilder,
    this.titleTextStyle,
  });

  final String title;
  final List<T> options;
  final List<T> disableOptions;
  /// [optionBuilder] is a function that returns a widget for each option
  /// - [context] is the current build context
  /// - [value] is the current option value
  /// - [disabled] is whether the current option is disabled
  final Widget Function(BuildContext context, T value, bool disabled) optionBuilder;

  // style
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      alignment: Alignment.center,
      titleTextStyle: titleTextStyle,
      children: List.generate(
        options.length,
        (index) => SimpleDialogOption(
          onPressed: disableOptions.contains(options[index]) ? null : () => Navigator.pop(context, options[index]),
          child: optionBuilder(context, options[index], disableOptions.contains(options[index])),
        ),
      ),
    );
  }
}
