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
        child: QrImageView(
          data: data,
          version: QrVersions.auto,
          size: 250,
          errorStateBuilder: (cxt, err) {
            return const Center(
              child: Text(
                'Uh oh! Something went wrong...',
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}
