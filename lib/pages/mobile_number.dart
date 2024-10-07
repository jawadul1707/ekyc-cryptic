import 'dart:convert';
import 'package:crypt/pages/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:crypt/pages/otp_number.dart';
import 'package:http/http.dart' as http;

class MobileNumberInputPage extends StatefulWidget {
  const MobileNumberInputPage({super.key});

  @override
  _MobileNumberInputPageState createState() => _MobileNumberInputPageState();
}

class _MobileNumberInputPageState extends State<MobileNumberInputPage> {
  final _phoneController = TextEditingController();
  bool _isButtonEnabled = false;

  void _validatePhoneNumber(String input) {
    // Assuming a basic validation for a 11-digit number
    final isValid = RegExp(r'^\d{11}$').hasMatch(input);
    setState(() {
      _isButtonEnabled = isValid;
    });

    mobileNumber = input;
  }

  // Function to send an OTP
  Future<void> _sendOTP() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            '$uri/user-management-service/api/v1/mobile/otp/send'));
    request.body = json.encode({"mobileNumber": mobileNumber});
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Sign up with eSign',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Set the font weight to bold
          ),
        ),
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
                  // Add the text "Enter your mobile number"
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter your mobile number',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                      height:
                          4), // Add some space between the text and TextField
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: '01XXXXXXXXX',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _validatePhoneNumber,
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
                                        const OtpNumberInputPage(),
                                    settings:
                                        RouteSettings(arguments: mobileNumber),
                                  )); // Handle the button press
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFFC2E7FF),
                        backgroundColor: const Color(0xFF005D99), // Text color
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                        ),
                      ),
                      child: const Text('Continue'),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
