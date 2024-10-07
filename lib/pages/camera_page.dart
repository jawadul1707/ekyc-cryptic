import 'dart:io';
import 'dart:convert';

import 'package:crypt/pages/global_variable.dart';
import 'package:crypt/pages/dob_display_page.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CameraPage extends StatefulWidget {

  final List<CameraDescription> cameras;
  const CameraPage({required this.cameras, super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
  
}

class _CameraPageState extends State<CameraPage> {

  //VARIABLES
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = false;

  @override
  void initState() {

    super.initState();

    // Reset the imageLocation when navigating to this page
    imageLocation = null;

    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePictureAndUpload() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = join(directory.path, '${DateTime.now()}.png');
      await image.saveTo(imagePath);

      setState(() {
        imageLocation = imagePath;
        print(imagePath);
      });

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$uri/user-management-service/api/v1/detect-text'),
      );
      
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();

        // Parse the JSON response
        Map<String, dynamic> responseBody = jsonDecode(responseString);

        // Extract values and store them in separate variables
        String dob = responseBody['dob'];
        int nid = responseBody['nid'] as int; // Cast to int for type safety

        print('DOB: $dob');
        print('NID: $nid');

        DOB = dob;
        nidNumber = nid;

        Navigator.push(
          this.context,
          MaterialPageRoute(builder: (context) => const DobDisplayPage()),
        );
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return imageLocation == null
                  ? CameraPreview(_controller)
                  : Image.file(File(imageLocation!));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        
        // Bottom blue bar
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 140, // Height of the bottom bar
            width: double.infinity,
            color: const Color(0xFFC2E7FF), // Change the color to blue
          ),
        ),
      ],
    ),
  floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0), // Adjust height as needed
        child: GestureDetector(
          onTap: _takePictureAndUpload,
          child: Container(
            width: 100.0,  // Increased size of the button
            height: 100.0, // Ensuring a circular shape
            decoration: const BoxDecoration(
              shape: BoxShape.circle, // Makes the button circular
              color: Color(0xFF005D99), // Background color
            ),
            child: const Icon(
              Icons.camera,
              size: 50, // Increased icon size
              color: Color(0xFFC2E7FF), // Icon color
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Keep the button centered
    );
  }
}
