import 'package:flutter/material.dart';

class NoConnectionOverlay extends StatelessWidget {
  const NoConnectionOverlay({super.key, required this.imagePath});

  final String imagePath; // 'assets/images/loading.gif'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.4),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 150,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(alignment: Alignment.center, children: [
            Center(child: Image.asset(imagePath, height: 50, width: 50)),
            const Positioned(bottom: 0, child: Text('Không có kết nối mạng', textAlign: TextAlign.center)),
          ]),
        ),
      ),
    );
  }
}
