import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Scanner',
      home: FoodScannerApp(),
    );
  }
}

class FoodScannerApp extends StatefulWidget {
  @override
  _FoodScannerAppState createState() => _FoodScannerAppState();
}

class _FoodScannerAppState extends State<FoodScannerApp> {
  CameraController? controller;
  bool isAnalyzing = false;
  String result = '';

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  initCamera() async {
    await Permission.camera.request();
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller!.initialize();
    setState(() {});
  }

  takePhoto() async {
    if (controller == null) return;
    
    setState(() {
      isAnalyzing = true;
    });

    final image = await controller!.takePicture();
    
    // Fake AI analysis
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      isAnalyzing = false;
      result = 'This looks like CANDY 🍭\n\nTry JAGGERY instead!\n- Natural sweetener\n- Contains iron\n- Better for health';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Scanner'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Camera or Result
          Expanded(
            child: result.isEmpty 
              ? (controller?.value.isInitialized ?? false)
                  ? CameraPreview(controller!)
                  : Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant, size: 100, color: Colors.orange),
                      SizedBox(height: 20),
                      Text(
                        result,
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
          ),
          
          // Buttons
          Container(
            padding: EdgeInsets.all(20),
            child: result.isEmpty
              ? ElevatedButton(
                  onPressed: isAnalyzing ? null : takePhoto,
                  child: isAnalyzing 
                    ? Text('Analyzing...')
                    : Text('SCAN FOOD'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    setState(() {
                      result = '';
                    });
                  },
                  child: Text('SCAN AGAIN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}