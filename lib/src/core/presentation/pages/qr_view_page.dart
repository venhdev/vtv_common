import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrViewPage extends StatelessWidget {
  const QrViewPage({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: QrView(data: data, size: 250),
      ),
    );
  }
}

class QrView extends StatelessWidget {
  const QrView({super.key, required this.data, this.size});

  final String data;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      errorStateBuilder: (cxt, err) {
        return const Center(
          child: Text(
            'Uh oh! Something went wrong...',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
