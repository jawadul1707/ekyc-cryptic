import 'package:crypt/pages/selfie_taker.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class FaceVerificationPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.lightBlue[100],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.face,
                    size: 100,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Position your face in the blue circle. Follow the instructions on your screen.\n\n'
                    '1. Find a well-lit area to focus your face.\n\n'
                    '2. Remove accessories like hats, eye glasses etc.\n\n'
                    '3. Hold your device at eye level and keep your face centered on the circle.\n\n'
                    '4. Do not move your face away from the outlined area.\n\n'
                    'The verification process will take less than a minute to complete.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 360,
              height: 40,
              //padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    borderRadius: BorderRadius.circular(10), // Rounded corners
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
    );
  }
}
