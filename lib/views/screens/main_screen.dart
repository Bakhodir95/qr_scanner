import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scanner/controllers/qr_code_controller.dart';
import 'package:qr_scanner/views/screens/scanner_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _textController = TextEditingController();
  bool isGenerated = false;
  late String textedited;
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    context.read<QrCodeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Something..."),
            ),
          ),
          isGenerated == false
              ? const SizedBox()
              : RepaintBoundary(
                  key: globalKey,
                  child: Center(
                    child: QrImageView(
                      data: textedited,
                      version: QrVersions.auto,
                      size: 320,
                      gapless: false,
                      errorStateBuilder: (cxt, err) {
                        return Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width,
                            maxHeight: MediaQuery.of(context).size.height / 2,
                          ),
                          child: const Center(
                            child: Text(
                              'Uh oh! Something went wrong...',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
          FilledButton(
            onPressed: () {
              _saveLocalImage();
            },
            child: const Text("Save Image"),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff333333),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 7,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              textedited = _textController.text;
                              isGenerated = textedited.isNotEmpty;
                              _textController.clear();
                            });
                          },
                          child: Image.asset("images/qrcode.png"),
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                        const Text(
                          "Generate",
                          style:
                              TextStyle(color: Color(0xffD9D9D9), fontSize: 20),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Image.asset("images/refresh.png"),
                        ),
                        const Text(
                          "History",
                          style:
                              TextStyle(color: Color(0xffD9D9D9), fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -80,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const QrS(),
                    ),
                  );
                },
                child: Image.asset(
                  "images/center.png",
                  width: 170,
                  height: 170,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveLocalImage() async {
    try {
      RenderRepaintBoundary? boundary = globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Could not find render object')),
        );
        return;
      }

      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        // Request permissions
        var status = await Permission.storage.request();
        if (status.isGranted) {
          final result =
              await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['isSuccess'] ? 'Saved!' : 'Failed!')),
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission denied')),
          );
        }
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
