import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner/controllers/qr_code_controller.dart';
import 'package:share_plus/share_plus.dart';

class QrS extends StatefulWidget {
  const QrS({super.key});

  @override
  State<QrS> createState() => _QrSState();
}

class _QrSState extends State<QrS> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerController = context.read<QrCodeController>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: (result != null)
                    ? Text(
                        // ignore: deprecated_member_use
                        "Xush Kelibsiz\n ${result!.code!}\nsaytiga")
                    : const Text('Scanerlash'),
              ),
            ),
            if (result != null && Uri.tryParse(result!.code ?? '') != null)
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          providerController.launchURL(result!.code!);
                        },
                        child: const Text("Saytga kirish"),
                      ),
                      FilledButton(
                        onPressed: () {
                          Share.share(result!.code!);
                        },
                        child: const Text("Share"),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
