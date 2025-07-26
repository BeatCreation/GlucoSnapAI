import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../providers/camera_provider.dart';

class CameraView extends StatelessWidget {
  final CameraProvider cameraProvider;
  final VoidCallback onCapture;
  final VoidCallback onRetry;

  const CameraView({
    super.key,
    required this.cameraProvider,
    required this.onCapture,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (cameraProvider.state == CameraState.loading) {
      return _buildLoadingView();
    }

    if (cameraProvider.state == CameraState.initial) {
      return _buildInitialView();
    }

    if (!cameraProvider.isCameraReady) {
      return _buildErrorView();
    }

    return Column(
      children: [
        // Camera Preview
        Expanded(
          child: Stack(
            children: [
              // Camera Preview
              Container(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CameraPreview(cameraProvider.controller!),
                ),
              ),
              
              // Scan Frame Overlay
              Positioned.fill(
                child: _buildScanOverlay(),
              ),
              
              // Top Controls
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: _buildTopControls(),
              ),
            ],
          ),
        ),
        
        // Bottom Controls
        Container(
          padding: const EdgeInsets.all(24),
          child: _buildBottomControls(),
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
          ),
          SizedBox(height: 16),
          Text(
            'Initializing camera...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Camera not initialized',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap retry to initialize camera',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt_outlined,
            size: 80,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Camera Error',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cameraProvider.errorMessage ?? 'Unknown error occurred',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildScanOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
      ),
      child: Center(
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              // Corner indicators
              _buildCornerIndicator(Alignment.topLeft),
              _buildCornerIndicator(Alignment.topRight),
              _buildCornerIndicator(Alignment.bottomLeft),
              _buildCornerIndicator(Alignment.bottomRight),
              
              // Center text
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Position food item here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCornerIndicator(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF48BB78),
            width: 3,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Flash toggle
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(25),
          ),
          child: IconButton(
            onPressed: cameraProvider.toggleFlash,
            icon: Icon(
              cameraProvider.controller?.value.flashMode == FlashMode.torch
                  ? Icons.flash_on
                  : Icons.flash_off,
              color: Colors.white,
            ),
          ),
        ),
        
        // Camera switch (if multiple cameras available)
        if (cameraProvider.cameras.length > 1)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(25),
            ),
            child: IconButton(
              onPressed: cameraProvider.switchCamera,
              icon: const Icon(
                Icons.flip_camera_ios,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Column(
      children: [
        // Capture Button
        GestureDetector(
          onTap: cameraProvider.state == CameraState.capturing ? null : onCapture,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF48BB78), Color(0xFF38A169)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF48BB78).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: cameraProvider.state == CameraState.capturing
                ? const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  )
                : const Icon(
                    Icons.camera,
                    size: 36,
                    color: Colors.white,
                  ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        Text(
          cameraProvider.state == CameraState.capturing
              ? 'Capturing...'
              : 'Tap to scan food',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}