import 'dart:convert';

import 'package:crypt/pages/global_variable.dart';
import 'package:crypt/pages/email_input.dart';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;

class OtpNumberInputPage extends StatefulWidget {
  const OtpNumberInputPage({super.key});

  @override
  _OtpNumberInputPageState createState() => _OtpNumberInputPageState();
}

class _OtpNumberInputPageState extends State<OtpNumberInputPage> {
  String _otpCode = '';
  bool _isButtonEnabled = false;
  int counter = 0;

  void _onOtpChanged(String code) {
    print('OTP code: $code'); // Debugging statement
    _otpCode = _otpCode + code;
    counter++;

    setState(() {
      _isButtonEnabled =
          counter >= 6; // Enable button when all 6 digits are entered
      print('Otp lalala is $_otpCode');
    });
  }

  void _onContinuePressed() {
    // Handle OTP submission
    print('OTP Entered: $_otpCode');
  }

  Future<bool> _verifyOTP() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            '$uri/user-management-service/api/v1/mobile/otp/verify'));
    request.body = json.encode({
      "mobileNumber": mobileNumber,
      "otp": _otpCode,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //String responseString = await response.stream.bytesToString();

      // Parse JSON response
      //Map<String, dynamic> responseBody = json.decode(responseString);
      // Check for successful message
      //return responseBody['message'] == 'OTP verified successfully';
      return true;
    } else {
      print(response.reasonPhrase);
      return false; // OTP verification failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Display a message when the user tries to navigate back
        final snackBar = SnackBar(
          content: const Text('Please complete the registration process first'),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false; // Prevent the navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Verify OTP'),
          ),
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '     Enter the code sent to +88$mobileNumber',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    OtpTextField(
                      numberOfFields: 6,
                      borderColor: const Color(0xFF512DA8),
                      showFieldAsBox: true,
                      keyboardType: TextInputType.number, 
                      onCodeChanged: (String code) {
                        _onOtpChanged(code);
                      },
                      onSubmit: (String verificationCode) {
                        // Optional: Handle OTP submission immediately after entering the code
                      },
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isButtonEnabled
                            ? () async {
                                bool isVerificationSuccessful =
                                    await _verifyOTP();
                                if (isVerificationSuccessful) {
                                  // Navigate to the next page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EmailInputPage(),
                                    ),
                                  );
                                } else {
                                  // Show an error message or handle failed verification
                                  print('OTP verification failed');
                                  counter = 0;
                                  _otpCode = '';
                                  final snackBar = SnackBar(
                                    content:
                                        const Text('OTP Verification Failed'),
                                    action: SnackBarAction(
                                      label: 'OK',
                                      onPressed: () {
                                        // Code to undo the action
                                      },
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFFC2E7FF),
                          backgroundColor: const Color(0xFF005D99),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
}
