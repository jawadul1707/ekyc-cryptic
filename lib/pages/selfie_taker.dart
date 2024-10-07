import 'dart:convert';
import 'dart:io';
//import 'package:crypt/pages/end.dart';
//import 'package:crypt/pages/fetchinfo.dart';
import 'package:crypt/pages/fetchinfo.dart';
import 'package:crypt/pages/global_variable.dart';
import 'package:crypt/pages/invalid.dart';
//import 'package:crypt/pages/user_details.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SelfiePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SelfiePage({required this.cameras, super.key});

  @override
  _SelfiePageState createState() => _SelfiePageState();
}

class _SelfiePageState extends State<SelfiePage> {

  late CameraController _selfiecontroller;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Reset the imageLocation when navigating to this page
    selfieLocation = null;

    if (widget.cameras.isEmpty) {
      // Handle the case when there are no cameras available
      print('No cameras available');
      return;
    }

    // Find the front camera
    final frontCamera = widget.cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => widget.cameras.first,
    );

    _selfiecontroller = CameraController(
      frontCamera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _selfiecontroller.initialize();
  }

  @override
  void dispose() {
    _selfiecontroller.dispose();
    super.dispose();
  }

  Future<void> _takeSelfie() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _initializeControllerFuture;
      final image = await _selfiecontroller.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = join(directory.path, '${DateTime.now()}.png');
      await image.saveTo(imagePath);

      setState(() {
        selfieLocation = imagePath;
        print(imageLocation);
        print(selfieLocation);
      });

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$uri/user-management-service/api/v1/face/recognition'),
      );

      request.files.add(
          await http.MultipartFile.fromPath('sourceImage', imageLocation!));
      request.files.add(
          await http.MultipartFile.fromPath('targetImage', selfieLocation!));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        //String responseString = await response.stream.bytesToString();
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        if (jsonResponse['statusCode'] == "OK") {
          // Navigate to the second page if face matched
          Navigator.push(this.context, MaterialPageRoute(builder: (context) => const NIDInfoFetcher()));
        } else {
          // Navigate to the third page if face didn't match
          Navigator.push(this.context, MaterialPageRoute(builder: (context) => InvalidPage()));
        }
        
        print(responseBody);
        //Navigator.push(
          //this.context,
          //MaterialPageRoute(builder: (context) => const NIDInfoFetcher()),
        //);
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
                return selfieLocation == null
                    ? CameraPreview(_selfiecontroller)
                    : Image.file(File(selfieLocation!));
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
        onPressed: _takeSelfie,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
