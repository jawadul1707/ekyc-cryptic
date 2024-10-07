import 'package:flutter/material.dart';

class EndPage extends StatelessWidget {
  const EndPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'End Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ThankYouPage(),
    );
  }
}

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eSign Login'),
      ),
      body: Center(
        child: Card(
          elevation: 4, // Slight shadow for the card
          margin: const EdgeInsets.all(16.0), // Margin around the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0), // Padding inside the card
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Thank you for registering with eSign.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10), // Space between text
                Text(
                  'Please visit esign.com.bd from your PC/Laptop browser to login.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}