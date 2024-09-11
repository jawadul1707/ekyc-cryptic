import 'dart:convert';
import 'package:crypt/pages/global_variable.dart';
import 'package:crypt/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PinInputPage extends StatefulWidget {
  const PinInputPage({super.key});

  @override
  _PinInputPageState createState() => _PinInputPageState();
}

class _PinInputPageState extends State<PinInputPage> {
  final _phoneController1 = TextEditingController();
  final _phoneController2 = TextEditingController();
  bool _isButtonEnabled = false;

  /*void _validatePinNumber(String pina, String pinb) {
    // Assuming a basic validation for a 11-digit number
    //final isValid = RegExp(r'^\d{4}$').hasMatch(input);
    print(pina);
    print(pinb);
    bool isValid = pina == pinb;
    setState(() {
      _isButtonEnabled = isValid;
    });
  } */

  void _storePinNumber1(String input) {
    pin1 = input;
    print(pin1);
  }

  void _storePinNumber2(String input) {
    pin2 = input;
    print(pin2);
    if (pin1 == pin2) {
      setState(() {
        _isButtonEnabled = true;
      });
    }
  }

  // Function to send an OTP
  Future<void> _createUser() async {
    //print("shaka laka boom boom");
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://$uri/user-management-service/api/v1/create-user'));
    request.body = json.encode({
      "phoneNo": mobileNumber,
      "email": email,
      "password": pin1,
      "fathersName": father,
      "mothersName": mother,
      "dateOfBirth": DOB,
      "commonName": name,
      "serialNumberType": "NID",
      "serialNumberValue": nidAsString,
      "houseIdentifier": houseIdentifier,
      "streetAddress": streetAddress,
      "locality": locality,
      "state": state,
      "postalCode": postalCode,
      "country": country,
      "organizationUnit": "individual",
      "organization": "individual",
      "subscriptionId": 1,
      "digitalSignature": true,
      "nonRepudiation": true,
      "keyEncipherment": false,
      "dataEncipherment": false,
      "keyAgreement": false,
      "keyCertSign": false,
      "crlSign": false,
      "encipherOnly": false,
      "decipherOnly": false
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print("shaka laka boom boom ${response.statusCode}");

    if (response.statusCode == 201) {
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
        title: const Text('Enter Pin Number'),
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
                    obscureText: true,
                    controller: _phoneController1,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Enter 4-digit Pin Number',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _storePinNumber1,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true, 
                    controller: _phoneController2,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Re-enter Pin Number',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _storePinNumber2,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 360,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled
                          ? () {
                              _createUser();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                    //settings:
                                    //RouteSettings(arguments: mobileNumber),
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
    _phoneController1.dispose();
    _phoneController2.dispose();
    super.dispose();
  }
}
