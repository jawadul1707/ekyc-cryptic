import 'package:flutter/material.dart';

class SignDetailsPage extends StatelessWidget {
  final String signerName;
  final String signerEmailAddress;
  final String signDate;
  final String signReason;
  final String signLocation;

  const SignDetailsPage({
    required this.signerName,
    required this.signerEmailAddress,
    required this.signDate,
    required this.signReason,
    required this.signLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Signer Name: $signerName',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Signer Email: $signerEmailAddress',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Sign Date: $signDate', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Sign Reason: $signReason',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Sign Location: $signLocation',
                style: const TextStyle(fontSize: 18)),
            const Spacer(),
            SizedBox(
              width: 360,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context,
                      ModalRoute.withName('/')); // Go back to the homepage
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF005D99),
                  backgroundColor: const Color(0xFFFFFFFF), // Text color
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: const Text('Go to Homepage',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
