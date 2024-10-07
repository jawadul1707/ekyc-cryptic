//import 'package:crypt/pages/scan_qr_code.dart';
import 'package:crypt/pages/scan_qr_code.dart';
import 'package:flutter/material.dart';
//import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:crypt/pages/mobile_number.dart';
//import 'package:url_launcher/url_launcher.dart';
//import 'dart:async';
//import 'dart:io';

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
                          foregroundColor: const Color(0xFF005D99),
                          backgroundColor:
                              const Color(0xFFFFFFFF), // Text color
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                        ),
                        child: const Text(
                          'Scan QR Code',
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

  Widget _welcomeCard() {
    return Card(
      color: const Color(0xFFC2E7FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // More rounded corners
      ),
      elevation: 10, // Elevation for shadow
      child: Container(
        width: 360,
        height: 180,
        padding: const EdgeInsets.all(16),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome To',
              style: TextStyle(
                color: Color(0xFF005D99),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'CRYPT',
              style: TextStyle(
                color: Color(0xFF005D99),
                fontSize: 57,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
