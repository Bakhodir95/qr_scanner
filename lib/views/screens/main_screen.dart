import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_scanner/controllers/qr_code_controller.dart';
import 'package:qr_scanner/views/screens/scanner_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _textController = TextEditingController();

  bool isGenerated = false;
  late String textedited;

  @override
  Widget build(BuildContext context) {
    final providerController = context.read<QrCodeController>();
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
              : Center(
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
        ],
      ),
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
              height: MediaQuery.of(context).size.height / 9,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        InkWell(
                            onTap: () {
                              textedited = _textController.text;
                              textedited.isEmpty
                                  ? isGenerated = false
                                  : isGenerated = true;
                              setState(() {
                                _textController.clear();
                              });
                            },
                            child: Image.asset("images/qrcode.png")),
                        const Text(
                          "Generate",
                          style:
                              TextStyle(color: Color(0xffD9D9D9), fontSize: 20),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                            onTap: () {},
                            child: Image.asset("images/refresh.png")),
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
              top: -70,
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
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
