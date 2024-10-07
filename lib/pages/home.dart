import 'package:flutter/material.dart';

import 'package:crypt/pages/qrcode_scan.dart';
import 'package:crypt/pages/mnumber_input.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false, body: _buildUI(context));
  }

  Widget _buildUI(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Home Page'),
        //   centerTitle: true,
        // ),
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFF005D99)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 40,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(seconds: 2),
                        child: _welcomeImage()
                        //child: _welcomeCard(),
                        ),
                    const Spacer(),
                    _filledButtonFull(context, const Text("Sign up now"),
                        const Color(0xFFC2E7FF), const Color(0xFF005D99)),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.01,
                    ),
                    SizedBox(
                      width: 360,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const QRScannerPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFFC2E7FF),
                          backgroundColor:
                              const Color(0xFF005D99), // Text color
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          'Verify with QR code',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }

  Widget _filledButtonFull(
    BuildContext context,
    Text text,
    Color colorOfBackground,
    Color colorOfForeground,
  ) {
    return SizedBox(
      width: 360,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MobileNumberInputPage()));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: colorOfForeground,
          backgroundColor: colorOfBackground, // Text color
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
        ),
        child: text,
      ),
    );
  }

  Widget _welcomeImage() {
    return SizedBox(
      width: 400,
      height: 400,
      child: Image.asset(
        'assets/dohatecesign.png', // Replace with your image path
        fit: BoxFit.contain,
      ),
    );
  }
}
