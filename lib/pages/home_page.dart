import 'package:flutter/material.dart';
import 'package:crypt/pages/mobile_number.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(_url)) {
  //     throw Exception('Could not launch $_url');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false, body: _buildUI(context));
  }

  Widget _buildUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
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
                    _welcomeCard(),
                    const Spacer(),
                    _filledButtonFull(context, const Text("Sign Up Now"),
                        const Color(0xFF005D99), const Color(0xFFC2E7FF)),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.01,
                    ),
                    SizedBox(
                      width: 360,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          //_launchUrl;

                          const link = "https://e-sign.com.bd/";
                          launchUrl(Uri.parse(link),
                              mode: LaunchMode.inAppWebView);
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
                          'Log In',
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
    );
  }

  Widget _welcomeCard() {
    return Card(
      color: const Color(0xFFC2E7FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
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
                fontSize: 14,
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
}
