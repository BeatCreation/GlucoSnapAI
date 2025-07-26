import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

enum CameraState {
  initial,
  loading,
  ready,
  capturing,
  error,
}

class CameraProvider extends ChangeNotifier {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  CameraState _state = CameraState.initial;
  String? _errorMessage;
  bool _isInitialized = false;
  File? _capturedImage;

  // Getters
  CameraController? get controller => _controller;
  List<CameraDescription> get cameras => _cameras;
  CameraState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;
  File? get capturedImage => _capturedImage;
  bool get isCameraReady => _controller?.value.isInitialized ?? false;

  void _setState(CameraState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setState(CameraState.error);
  }

  Future<void> initializeCamera() async {
    try {
      _setState(CameraState.loading);

      // Check camera permission
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission != PermissionStatus.granted) {
        _setError('Camera permission denied. Please enable camera access in settings.');
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _setError('No cameras found on this device.');
        return;
      }

      // Use back camera by default, fallback to first available
      CameraDescription selectedCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      // Initialize camera controller
      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      _isInitialized = true;
      _setState(CameraState.ready);

    } catch (e) {
      _setError('Failed to initialize camera: ${e.toString()}');
    }
  }

  Future<File?> captureImage() async {
    if (!isCameraReady) {
      _setError('Camera is not ready');
      return null;
    }

    try {
      _setState(CameraState.capturing);

      final XFile imageFile = await _controller!.takePicture();
      _capturedImage = File(imageFile.path);
      
      _setState(CameraState.ready);
      return _capturedImage;

    } catch (e) {
      _setError('Failed to capture image: ${e.toString()}');
      return null;
    }
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    try {
      _setState(CameraState.loading);

      final currentLensDirection = _controller!.description.lensDirection;
      CameraDescription newCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection != currentLensDirection,
        orElse: () => _cameras.first,
      );

      await _controller!.dispose();
      
      _controller = CameraController(
        newCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      _setState(CameraState.ready);

    } catch (e) {
      _setError('Failed to switch camera: ${e.toString()}');
    }
  }

  Future<void> toggleFlash() async {
    if (!isCameraReady) return;

    try {
      final currentFlashMode = _controller!.value.flashMode;
      final newFlashMode = currentFlashMode == FlashMode.off 
          ? FlashMode.torch 
          : FlashMode.off;
      
      await _controller!.setFlashMode(newFlashMode);
      notifyListeners();

    } catch (e) {
      _setError('Failed to toggle flash: ${e.toString()}');
    }
  }

  void clearError() {
    _errorMessage = null;
    if (_state == CameraState.error) {
      _setState(_isInitialized ? CameraState.ready : CameraState.initial);
    }
  }

  void clearCapturedImage() {
    _capturedImage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}