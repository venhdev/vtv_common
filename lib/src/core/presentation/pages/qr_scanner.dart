import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../components/scanner_button_widgets.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key, this.overlayBuilder, this.options});

  final Widget Function(BuildContext context, BoxConstraints constraints, MobileScannerController controller)?
      overlayBuilder;
  final void Function(BuildContext context, MobileScannerController controller)? options;

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  @override
  void initState() {
    super.initState();
    if (widget.options != null) {
      widget.options!(context, controller);
    }
    // controller.start();
    // controller.barcodes.listen((data) {
    //   controller.stop();
    //   if (!mounted) return;
    //   Navigator.pop(context, data.barcodes.first.rawValue!);
    // });
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
      appBar: AppBar(
        title: const Text('Quét mã QR'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
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
              overlayBuilder: widget.overlayBuilder == null
                  ? null
                  : (context, constraints) => widget.overlayBuilder!(context, constraints, controller),
              // overlayBuilder: (context, constraints) {
              //   return Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Align(
              //       alignment: Alignment.center,
              //       // child: ScannedBarcodeLabel(barcodes: controller.barcodes),
              //       child: StreamBuilder(
              //         stream: controller.barcodes,
              //         builder: (context, snapshot) {
              //           final scannedBarcodes = snapshot.data?.barcodes ?? [];

              //           if (scannedBarcodes.isEmpty) {
              //             return const Text(
              //               'Scan something!',
              //               overflow: TextOverflow.fade,
              //               style: TextStyle(color: Colors.white),
              //             );
              //           }

              //           return Column(
              //             children: [
              //               Text(
              //                 scannedBarcodes.first.rawValue ?? 'No display value.',
              //                 overflow: TextOverflow.fade,
              //                 style: const TextStyle(color: Colors.white),
              //               ),
              //               if (scannedBarcodes.first.rawValue != null)
              //                 TextButton(
              //                   onPressed: () {
              //                     // popWithScannedData(scannedBarcodes.first.rawValue!);
              //                     Navigator.pop(context, scannedBarcodes.first.rawValue!);
              //                   },
              //                   child: const Text('Nhận đơn'),
              //                 )
              //             ],
              //           );
              //         },
              //       ),
              //     ),
              //   );
              // },
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
                  RetryMobileScannerTextButton(controller: controller),
                  // RetryMobileScannerButton(controller: controller),
                  // StartStopMobileScannerButton(controller: controller),
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

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // ?TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow || borderRadius != oldDelegate.borderRadius;
  }
}

//*---------------------ERROR-----------------------*//
class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
      case MobileScannerErrorCode.permissionDenied:
        // errorMessage = 'Permission denied';
        errorMessage = 'Quyền truy cập máy ảnh bị từ chối';
      case MobileScannerErrorCode.unsupported:
        // errorMessage = 'Scanning is unsupported on this device';
        errorMessage = 'Thiết bị không được hỗ trợ';
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
