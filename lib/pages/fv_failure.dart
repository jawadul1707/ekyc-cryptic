import 'package:crypt/pages/dob_nid_display.dart';
import 'package:crypt/pages/fv_caputre.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class InvalidPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show a message when trying to navigate back
        final snackBar = SnackBar(
          content:
              const Text('Please complete the registration process first.'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false; // Prevent back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false, // Remove the back button
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.highlight_off,
                      size: 100,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Face Verification Error',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: 'Try again.',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            // Navigate to the other page when "Try again" is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DobDisplayPage()),
                            );
                          },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 360,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    // Add your onPressed code here!
                    final cameras = await availableCameras();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelfiePage(cameras: cameras),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFC2E7FF),
                    backgroundColor: const Color(0xFF005D99), // Text color
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Continue',
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
  }
}
