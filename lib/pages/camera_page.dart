import 'package:crypt/pages/global_variable.dart';
import 'package:crypt/pages/dob_display_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

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
            'http://$uri/user-management-service/api/v1/detect-text'),
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
      appBar: AppBar(title: const Text('Take a Picture')),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePictureAndUpload,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
