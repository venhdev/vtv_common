import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vtv_common/src/core/presentation/components/custom_widgets.dart';

import '../components/scanner_button_widgets.dart';
import 'qr_scan_page.dart';

// OverlayQrScannerView
class QrScannerWithCustomOverlayPage extends StatefulWidget {
  const QrScannerWithCustomOverlayPage({super.key});

  @override
  State<QrScannerWithCustomOverlayPage> createState() => _QrScannerWithCustomOverlayPageState();
}

class _QrScannerWithCustomOverlayPageState extends State<QrScannerWithCustomOverlayPage> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  @override
  void initState() {
    super.initState();
    controller.start();
    controller.barcodes.listen((data) {
      log('Scanned: ${data.barcodes.first.rawValue}');
      // controller.stop();
      // if (!mounted) return;
      // Navigator.pop(context, data.barcodes.first.rawValue!);
    });
  }


  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 250,
      height: 250,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Quét mã QR')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: MobileScanner(
              fit: BoxFit.contain,
              controller: controller,
              scanWindow: scanWindow,
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
              overlayBuilder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.center,
                    // child: ScannedBarcodeLabel(barcodes: controller.barcodes),
                    child: StreamBuilder(
                      stream: controller.barcodes,
                      builder: (context, snapshot) {
                        final scannedBarcodes = snapshot.data?.barcodes ?? [];

                        if (scannedBarcodes.isEmpty) {
                          // controller.bar
                          return const SizedBox.shrink();
                          // return const Text(
                          //   'Scan something!',
                          //   overflow: TextOverflow.fade,
                          //   style: TextStyle(color: Colors.white),
                          // );
                        }

                        return SlowBuildWidget();

                        // return Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       scannedBarcodes.first.rawValue ?? 'No display value.',
                        //       overflow: TextOverflow.fade,
                        //       style: const TextStyle(color: Colors.white),
                        //     ),
                        //     if (scannedBarcodes.first.rawValue != null)
                        //       TextButton(
                        //         onPressed: () {
                        //           // popWithScannedData(scannedBarcodes.first.rawValue!);
                        //           Navigator.pop(context, scannedBarcodes.first.rawValue!);
                        //         },
                        //         child: const Text('Nhận đơn'),
                        //       )
                        //   ],
                        // );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (!value.isInitialized || !value.isRunning || value.error != null) {
                return const SizedBox();
              }

              return CustomPaint(
                painter: ScannerOverlay(scanWindow: scanWindow),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // RetryMobileScannerButton(controller: controller),
                  StartStopMobileScannerButton(controller: controller),
                  ToggleFlashlightButton(controller: controller),
                  // SwitchCameraButton(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}

class SlowBuildWidget extends StatefulWidget {
  const SlowBuildWidget({super.key});

  @override
  State<SlowBuildWidget> createState() => _SlowBuildWidgetState();
}

class _SlowBuildWidgetState extends State<SlowBuildWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(
        const Duration(seconds: 2),
        () => 'Data Loaded',
      ),
      builder: (context, snapshot) {
        log('snapshot snapshot');
        if (snapshot.hasData) {
          return SizedBox(
            height: 50,
            width: 100,
            child: Text(snapshot.data!),
          );
        } else if (snapshot.hasError) {
          return MessageScreen.error(snapshot.error.toString());
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
