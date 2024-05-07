import 'package:flutter/material.dart';

class OptionsDialog<T> extends StatelessWidget {
  const OptionsDialog({
    super.key,
    required this.title,
    required this.options,
    required this.optionBuilder,
    this.titleTextStyle,
  });

  final String title;
  final List<T> options;
  final Widget Function(BuildContext context, T value) optionBuilder;
  
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
          onPressed: () => Navigator.pop(context, options[index]),
          child: optionBuilder(context, options[index]),
        ),
      ),
    );
  }
}
