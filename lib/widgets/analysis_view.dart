import 'package:flutter/material.dart';
import 'dart:io';

class AnalysisView extends StatelessWidget {
  final double progress;
  final File? capturedImage;

  const AnalysisView({
    super.key,
    required this.progress,
    this.capturedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header
          Text(
            'Analyzing Food',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3748),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Please wait while AI identifies your food item',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 40),
          
          // Captured Image Preview
          if (capturedImage != null) ...[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  capturedImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
          
          // Progress Indicator
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                ),
              ),
              Column(
                children: [
                  const Icon(
                    Icons.psychology,
                    size: 40,
                    color: Color(0xFF667EEA),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF667EEA),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Progress Steps
          _buildProgressSteps(),
          
          const SizedBox(height: 40),
          
          // AI Processing Animation
          _buildAIAnimation(),
        ],
      ),
    );
  }

  Widget _buildProgressSteps() {
    return Column(
      children: [
        _buildProgressStep(
          'Loading AI Model',
          progress >= 0.2,
          progress < 0.2,
        ),
        const SizedBox(height: 12),
        _buildProgressStep(
          'Preprocessing Image',
          progress >= 0.4,
          progress >= 0.2 && progress < 0.4,
        ),
        const SizedBox(height: 12),
        _buildProgressStep(
          'Running Prediction',
          progress >= 0.8,
          progress >= 0.4 && progress < 0.8,
        ),
        const SizedBox(height: 12),
        _buildProgressStep(
          'Generating Results',
          progress >= 1.0,
          progress >= 0.8 && progress < 1.0,
        ),
      ],
    );
  }

  Widget _buildProgressStep(String title, bool completed, bool active) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed
                ? const Color(0xFF48BB78)
                : active
                    ? const Color(0xFF667EEA)
                    : Colors.grey[300],
          ),
          child: completed
              ? const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                )
              : active
                  ? SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: completed || active ? const Color(0xFF2D3748) : Colors.grey[500],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAIAnimation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF667EEA).withOpacity(0.1),
            const Color(0xFF764BA2).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF667EEA).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAnimatedDot(0),
          const SizedBox(width: 8),
          _buildAnimatedDot(200),
          const SizedBox(width: 8),
          _buildAnimatedDot(400),
          const SizedBox(width: 16),
          const Text(
            'AI is thinking...',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF667EEA),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDot(int delay) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 500 + delay),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(
              const Color(0xFF667EEA).withOpacity(0.3),
              const Color(0xFF667EEA),
              (value + delay / 1000) % 1.0,
            ),
          ),
        );
      },
    );
  }
}