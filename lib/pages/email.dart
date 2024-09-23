import 'dart:convert';
import 'package:crypt/pages/global_variable.dart';
import 'package:crypt/pages/otp_email.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailInputPage extends StatefulWidget {
  const EmailInputPage({super.key});

  @override
  _EmailInputPageState createState() => _EmailInputPageState();
}

class _EmailInputPageState extends State<EmailInputPage> {
  
  // VARIABLES
  final _phoneController = TextEditingController();
  bool _isButtonEnabled = false;

  void _validateEmail(String input) {
    // Assuming a basic validation for an email address
    final isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);
    setState(() {
      _isButtonEnabled = isValid;
    });
    email = input;
    print(email);
  }

  // Function to send an OTP
  Future<void> _sendOTP() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse('http://$uri/user-management-service/api/v1/email/otp/send'));
    request.body = json.encode({"email": email});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Display message when user tries to go back
        final snackBar = SnackBar(
          content: const Text('Please complete the registration process first'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false; // Prevents navigation
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Enter Email Address'),
          automaticallyImplyLeading: false, // Removes the back button
        ),
        body: LayoutBuilder(builder: (context, constraints) {
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
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _validateEmail,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 360,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _isButtonEnabled
                            ? () {
                                _sendOTP();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OtpEmailInputPage(),
                                      settings: RouteSettings(arguments: email),
                                    )); // Handle the button press
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFFC2E7FF),
                          backgroundColor: const Color(0xFF005D99), // Text color
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Rounded corners
                          ),
                        ),
                        child: const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
