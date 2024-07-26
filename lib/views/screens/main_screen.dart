import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: QrImageView(
              data: 'This QR code will show the error state instead',
              version:
                  QrVersions.auto, // Automatically chooses the correct version
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
                            onTap: () {},
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
              child: Image.asset(
                "images/center.png",
                width: 150,
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
