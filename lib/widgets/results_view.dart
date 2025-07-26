import 'package:flutter/material.dart';
import 'dart:io';
import '../models/food_data.dart';

class ResultsView extends StatelessWidget {
  final FoodData foodData;
  final File? capturedImage;
  final VoidCallback onNewScan;

  const ResultsView({
    super.key,
    required this.foodData,
    this.capturedImage,
    required this.onNewScan,
  });

  @override
  Widget build(BuildContext context) {
    final isHealthyFood = foodData.category.toLowerCase().contains('healthy');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with New Scan button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Analysis Results',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
              ElevatedButton.icon(
                onPressed: onNewScan,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('New Scan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Captured Image
          if (capturedImage != null) ...[
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
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
            ),
            
            const SizedBox(height: 32),
          ],
          
          // Food Category Card
          _buildFoodCategoryCard(isHealthyFood),
          
          const SizedBox(height: 20),
          
          // Health Alert
          _buildHealthAlert(isHealthyFood),
          
          const SizedBox(height: 24),
          
          // Alternative Suggestion
          _buildAlternativeCard(),
          
          const SizedBox(height: 32),
          
          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildFoodCategoryCard(bool isHealthy) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isHealthy
              ? [const Color(0xFFF0FFF4), const Color(0xFFC6F6D5)]
              : [const Color(0xFFFFF5F5), const Color(0xFFFED7D7)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHealthy
              ? const Color(0xFF68D391)
              : const Color(0xFFFC8181),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant,
                color: isHealthy
                    ? const Color(0xFF22543D)
                    : const Color(0xFFC53030),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Food Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isHealthy
                      ? const Color(0xFF22543D)
                      : const Color(0xFFC53030),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  foodData.category,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isHealthy
                        ? const Color(0xFF22543D)
                        : const Color(0xFFC53030),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF48BB78),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(foodData.confidence * 100).round()}% confident',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Text(
            foodData.description,
            style: TextStyle(
              fontSize: 14,
              color: isHealthy
                  ? const Color(0xFF2F855A)
                  : const Color(0xFF9B2C2C),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthAlert(bool isHealthy) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHealthy
            ? const Color(0xFFF0FFF4)
            : const Color(0xFFFED7D7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHealthy
              ? const Color(0xFF68D391)
              : const Color(0xFFFC8181),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isHealthy ? Icons.check_circle : Icons.warning,
            color: isHealthy
                ? const Color(0xFF38A169)
                : const Color(0xFFC53030),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              foodData.healthWarning,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isHealthy
                    ? const Color(0xFF22543D)
                    : const Color(0xFFC53030),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF0FFF4), Color(0xFFC6F6D5)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF68D391),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF48BB78),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    foodData.alternative.iconPath,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.eco,
                          color: Color(0xFF22543D),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Healthy Alternative',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF22543D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      foodData.alternative.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF22543D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            foodData.alternative.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2F855A),
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Benefits:',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF22543D),
            ),
          ),
          
          const SizedBox(height: 8),
          
          ...foodData.alternative.benefits.map((benefit) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check,
                  color: Color(0xFF38A169),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    benefit,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2F855A),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onNewScan,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Scan Another Food'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF48BB78),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement share functionality
            },
            icon: const Icon(Icons.share),
            label: const Text('Share Results'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF667EEA),
              side: const BorderSide(color: Color(0xFF667EEA)),
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}