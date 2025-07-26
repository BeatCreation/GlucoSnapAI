# GlucoSnapAI - Flutter Food Scanner App

GlucoSnapAI is a modern Flutter mobile application that uses AI to identify food items through camera capture and provides healthy alternatives for better nutrition choices.

## Features

🍎 **Smart Food Recognition**: Uses AI to identify various food items  
📱 **Native Mobile Experience**: Built with Flutter for smooth performance  
🔍 **Health Analysis**: Categorizes food and highlights health concerns  
🌱 **Healthy Alternatives**: Suggests better food options with detailed benefits  
📊 **Confidence Scoring**: Shows AI confidence levels for predictions  
💚 **Modern UI**: Beautiful Material Design 3 interface  
📷 **Advanced Camera**: Flash, focus, front/back camera switching  
🔄 **State Management**: Uses Provider for reactive UI updates  

## Supported Food Categories

- **High Sugar Snacks**: Candy, Chocolate, Ice Cream
- **Beverages**: Soda and sugary drinks  
- **Fast Food**: Burgers, Pizza
- **Healthy Options**: Fruits like Apples
- **Custom Categories**: Easy to extend with more food types

## Quick Start

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode for device testing
- Camera-enabled device

### Installation

1. **Clone the repository**:
   ```bash
   git clone <your-repo-url>
   cd GlucoSnapAI
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   # For debug mode
   flutter run
   
   # For release mode
   flutter run --release
   ```

### Platform Setup

#### Android
- Minimum SDK: 21 (Android 5.0)
- Camera permissions automatically handled
- No additional setup required

#### iOS  
- Minimum iOS: 11.0
- Camera permissions configured in Info.plist
- Run on physical device for camera access

## App Architecture

### Directory Structure
```
lib/
├── main.dart                    # App entry point
├── models/
│   └── food_data.dart          # Food data models
├── providers/
│   ├── camera_provider.dart    # Camera state management
│   └── food_recognition_provider.dart  # AI recognition logic
├── screens/
│   └── home_screen.dart        # Main app screen
└── widgets/
    ├── camera_view.dart        # Camera interface
    ├── analysis_view.dart      # Analysis progress
    ├── results_view.dart       # Results display
    └── error_view.dart         # Error handling
```

### State Management
The app uses Provider pattern for state management:
- **CameraProvider**: Manages camera initialization, capture, and controls
- **FoodRecognitionProvider**: Handles AI predictions and results

## AI Integration

### Current Implementation
The app currently uses a mock AI model for demonstration. The mock system:
- Simulates realistic processing delays
- Returns predefined food categories
- Shows confidence scores
- Demonstrates the full user flow

### Integrating Real AI

#### Option 1: TensorFlow Lite
```dart
// In food_recognition_provider.dart
import 'package:tflite_flutter/tflite_flutter.dart';

Future<FoodData> _realPrediction(File imageFile) async {
  // Load TensorFlow Lite model
  final interpreter = await Interpreter.fromAsset('model.tflite');
  
  // Preprocess image
  final input = _preprocessImage(imageFile);
  
  // Run inference
  final output = List.filled(7, 0.0).reshape([1, 7]);
  interpreter.run(input, output);
  
  // Process results
  return _processResults(output[0]);
}
```

#### Option 2: Cloud APIs
```dart
// Integrate with Google Cloud Vision, AWS Rekognition, etc.
Future<FoodData> _cloudPrediction(File imageFile) async {
  final bytes = await imageFile.readAsBytes();
  final base64Image = base64Encode(bytes);
  
  // Send to cloud API
  final response = await http.post(
    Uri.parse('YOUR_API_ENDPOINT'),
    body: json.encode({'image': base64Image}),
  );
  
  return _processAPIResponse(response.body);
}
```

## Customizing Food Database

Add new food categories in `lib/models/food_data.dart`:

```dart
'new_food': FoodData(
  name: 'New Food',
  category: 'Food Category',
  description: 'Description of the food item',
  healthWarning: 'Health warning message',
  alternative: FoodAlternative(
    title: 'Healthy Alternative',
    description: 'Alternative description',
    benefits: [
      'Benefit 1',
      'Benefit 2', 
      'Benefit 3'
    ],
    iconPath: '🥗',
  ),
),
```

## Camera Features

### Available Controls
- **Capture**: Take photos for food analysis
- **Flash Toggle**: Turn flash on/off
- **Camera Switch**: Switch between front/back cameras  
- **Focus**: Tap to focus (automatic)
- **Zoom**: Pinch to zoom (if supported)

### Camera States
- `initial`: Camera not initialized
- `loading`: Camera initializing
- `ready`: Camera ready for capture
- `capturing`: Taking photo
- `error`: Camera error occurred

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### iOS (requires macOS and Xcode)
```bash
flutter build ios --release
```

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests  
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## Performance Optimization

### Image Processing
- Compress images before AI processing
- Use appropriate image resolutions
- Implement image caching

### Memory Management
- Dispose camera controllers properly
- Clear image references after use
- Use `AutomaticKeepAliveClientMixin` for persistent widgets

### Battery Optimization
- Stop camera when app is in background
- Reduce frame rate when idle
- Minimize processing during analysis

## Deployment

### Google Play Store
1. Follow [Flutter Android deployment guide](https://docs.flutter.dev/deployment/android)
2. Set up app signing
3. Create store listing
4. Upload App Bundle

### Apple App Store
1. Follow [Flutter iOS deployment guide](https://docs.flutter.dev/deployment/ios)
2. Set up certificates and profiles
3. Create App Store listing  
4. Submit for review

### Firebase App Distribution
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Deploy to Firebase App Distribution
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
    --app YOUR_APP_ID \
    --groups testers
```

## Troubleshooting

### Camera Issues
- **Permission Denied**: Check camera permissions in device settings
- **Camera Not Available**: Test on physical device, not emulator
- **Poor Image Quality**: Ensure good lighting and steady hands

### Build Issues
- **Dependency Conflicts**: Run `flutter pub deps` to check dependencies
- **Platform Issues**: Use `flutter doctor` to verify setup
- **Version Mismatches**: Check Flutter and Dart SDK versions

### Performance Issues
- **Slow Recognition**: Optimize image size and AI model
- **Memory Leaks**: Check provider disposal and image cleanup
- **UI Freezing**: Move heavy operations to background threads

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Follow [Flutter style guide](https://dart.dev/guides/language/effective-dart/style)
4. Add tests for new features
5. Commit changes (`git commit -m 'Add AmazingFeature'`)
6. Push to branch (`git push origin feature/AmazingFeature`)
7. Open a Pull Request

## Dependencies

### Core Dependencies
- `flutter`: UI framework
- `camera`: Camera functionality
- `provider`: State management  
- `google_fonts`: Typography
- `permission_handler`: Permission management

### AI/ML Dependencies
- `tflite_flutter`: TensorFlow Lite integration
- `image`: Image processing utilities
- `http`: API communication

### UI/UX Dependencies
- `flutter_animate`: Animations
- `lottie`: Lottie animations
- `shimmer`: Loading effects

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Future Enhancements

- [ ] Real-time food detection (without capture)
- [ ] Nutrition facts integration
- [ ] Meal planning suggestions  
- [ ] User profiles and preferences
- [ ] Offline AI model support
- [ ] Voice commands and accessibility
- [ ] Multi-language support
- [ ] Social sharing features
- [ ] Recipe recommendations
- [ ] Barcode scanning for packaged foods

## Support

For support and questions:
- Create an issue in the repository
- Check the [Flutter documentation](https://docs.flutter.dev/)
- Visit [Flutter community](https://flutter.dev/community)

---

**Made with ❤️ using Flutter for healthier food choices**