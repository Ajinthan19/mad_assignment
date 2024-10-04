import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class RatingsAndReviewsPage extends StatefulWidget {
  @override
  _RatingsAndReviewsPageState createState() => _RatingsAndReviewsPageState();
}

class _RatingsAndReviewsPageState extends State<RatingsAndReviewsPage> {
  double _rating = 0.0;
  String _review = '';
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = _cameraController!.initialize();
    // Ensure the camera is initialized
    setState(() {});
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      // Capture the picture and store it in an XFile
      XFile imageFile = await _cameraController!.takePicture();

      // Define the image path where you want to save the picture
      final imagePath = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      // Move the file to the specified path
      await imageFile.saveTo(imagePath);

      setState(() {
        _imageFile = File(imagePath);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _submitReview() async {
    // Here you would typically send the data to your backend
    print('Rating: $_rating');
    print('Review: $_review');
    if (_imageFile != null) {
      print('Image path: ${_imageFile!.path}');
    }

    // Clear the fields after submission
    setState(() {
      _rating = 0.0;
      _review = '';
      _imageFile = null;
    });

    // Show success message
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(content: Text('Review submitted successfully!')),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ratings & Reviews'),
        backgroundColor: Colors.indigo[1],
      ),
      body: SingleChildScrollView( // Make the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate your booking:', style: TextStyle(fontSize: 18)),
            Slider(
              value: _rating,
              min: 0,
              max: 5,
              divisions: 5,
              label: _rating.toString(),
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Write a review:', style: TextStyle(fontSize: 18)),
            TextField(
              onChanged: (value) {
                setState(() {
                  _review = value;
                });
              },
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your review here',
              ),
            ),
            SizedBox(height: 20),
            Text('Capture an image (if any):', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            if (_imageFile != null) Image.file(_imageFile!),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('Capture Image'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReview,
              child: Text('Submit Review'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            ),
          ],
        ),
      ),
    );
  }
}
