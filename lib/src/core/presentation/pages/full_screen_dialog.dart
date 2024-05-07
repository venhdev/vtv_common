import 'package:flutter/material.dart';

class FullScreenDialog extends StatelessWidget {
  const FullScreenDialog({
    super.key,
    required this.body,
    this.canPop = false,
    this.scaffoldBackgroundColor,
  });

  final bool canPop;
  final Color? scaffoldBackgroundColor;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: body,
      ),
    );
  }
}
