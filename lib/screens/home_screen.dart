import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/camera_provider.dart';
import '../providers/food_recognition_provider.dart';
import '../widgets/camera_view.dart';
import '../widgets/analysis_view.dart';
import '../widgets/results_view.dart';
import '../widgets/error_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
    });
  }

  Future<void> _initializeCamera() async {
    final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
    await cameraProvider.initializeCamera();
  }

  void _onCapturePressed() async {
    final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
    final recognitionProvider = Provider.of<FoodRecognitionProvider>(context, listen: false);

    // Capture image
    final imageFile = await cameraProvider.captureImage();
    if (imageFile != null) {
      // Start food recognition
      await recognitionProvider.recognizeFood(imageFile);
    }
  }

  void _onNewScanPressed() {
    final recognitionProvider = Provider.of<FoodRecognitionProvider>(context, listen: false);
    final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
    
    recognitionProvider.clearResults();
    cameraProvider.clearCapturedImage();
  }

  Widget _buildBody() {
    return Consumer2<CameraProvider, FoodRecognitionProvider>(
      builder: (context, cameraProvider, recognitionProvider, child) {
        // Show error if camera failed to initialize
        if (cameraProvider.state == CameraState.error) {
          return ErrorView(
            title: 'Camera Error',
            message: cameraProvider.errorMessage ?? 'Unknown camera error',
            onRetry: _initializeCamera,
          );
        }

        // Show error if recognition failed
        if (recognitionProvider.state == RecognitionState.error) {
          return ErrorView(
            title: 'Recognition Error',
            message: recognitionProvider.errorMessage ?? 'Unknown recognition error',
            onRetry: _onNewScanPressed,
          );
        }

        // Show results when recognition is completed
        if (recognitionProvider.state == RecognitionState.completed &&
            recognitionProvider.recognizedFood != null) {
          return ResultsView(
            foodData: recognitionProvider.recognizedFood!,
            capturedImage: cameraProvider.capturedImage,
            onNewScan: _onNewScanPressed,
          );
        }

        // Show analysis progress
        if (recognitionProvider.state == RecognitionState.analyzing) {
          return AnalysisView(
            progress: recognitionProvider.progress,
            capturedImage: cameraProvider.capturedImage,
          );
        }

        // Show camera view (default)
        return CameraView(
          cameraProvider: cameraProvider,
          onCapture: _onCapturePressed,
          onRetry: _initializeCamera,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'GlucoSnapAI',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan food, get healthy alternatives',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _buildBody(),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}