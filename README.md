# GlucoSnapAI - Food Scanner with Health Alternatives

GlucoSnapAI is a web-based food scanning application that uses AI to identify food items through camera capture and provides healthy alternatives for better nutrition choices.

## Features

🍎 **Smart Food Recognition**: Uses Teachable Machine AI to identify various food items
📱 **Camera Integration**: Real-time camera access for food scanning
🔍 **Health Analysis**: Categorizes food and highlights health concerns
🌱 **Healthy Alternatives**: Suggests better food options with detailed benefits
📊 **Confidence Scoring**: Shows AI confidence levels for predictions
💚 **Modern UI**: Beautiful, responsive design that works on all devices

## Supported Food Categories

- **High Sugar Snacks**: Candy, Chocolate, Ice Cream
- **Beverages**: Soda and sugary drinks
- **Fast Food**: Burgers, Pizza
- **Healthy Options**: Fruits like Apples
- **Custom Categories**: Easy to extend with more food types

## Quick Start

1. **Clone the repository**:
   ```bash
   git clone <your-repo-url>
   cd GlucoSnapAI
   ```

2. **Serve the application**:
   Since the app uses camera access, it needs to be served over HTTPS or localhost:
   
   **Option 1 - Using Python**:
   ```bash
   # Python 3
   python -m http.server 8000
   
   # Python 2
   python -m SimpleHTTPServer 8000
   ```
   
   **Option 2 - Using Node.js (if you have http-server installed)**:
   ```bash
   npx http-server -p 8000
   ```
   
   **Option 3 - Using Live Server (VS Code Extension)**:
   - Install Live Server extension
   - Right-click on `index.html` and select "Open with Live Server"

3. **Open the application**:
   Navigate to `http://localhost:8000` in your browser

## Setting Up Teachable Machine Integration

Currently, the app uses a mock AI model for demonstration. To integrate with your actual Teachable Machine model:

### Step 1: Train Your Model on Teachable Machine
1. Go to [Teachable Machine](https://teachablemachine.withgoogle.com/)
2. Choose "Image Project"
3. Create classes for different food items (candy, apple, chocolate, etc.)
4. Upload training images for each class
5. Train your model
6. Export the model

### Step 2: Get Model URL
1. After training, click "Export Model"
2. Choose "TensorFlow.js"
3. Upload to Google Drive or download
4. Copy the model URL

### Step 3: Update the Code
In `script.js`, replace the mock model loading with actual Teachable Machine integration:

```javascript
// Replace the MODEL_URL with your actual model URL
const MODEL_URL = 'https://teachablemachine.withgoogle.com/models/YOUR_MODEL_ID/';

// Replace the loadModel function
async function loadModel() {
    try {
        model = await tmImage.load(MODEL_URL + 'model.json', MODEL_URL + 'metadata.json');
        isModelLoaded = true;
        console.log('Model loaded successfully');
    } catch (error) {
        console.error('Error loading model:', error);
        isModelLoaded = false;
    }
}

// Replace the mockPredict function
async function realPredict(imageElement) {
    const predictions = await model.predict(imageElement);
    return predictions;
}
```

## Customizing Food Database

To add new food categories or modify existing ones, edit the `foodDatabase` object in `script.js`:

```javascript
const foodDatabase = {
    'your_food_name': {
        category: 'Food Category Name',
        description: 'Description of the food item',
        healthWarning: 'Health warning message',
        alternative: {
            title: 'Alternative Food Name',
            description: 'Description of the alternative',
            benefits: [
                'Benefit 1',
                'Benefit 2',
                'Benefit 3'
            ]
        }
    }
};
```

## Browser Compatibility

- **Chrome**: Fully supported
- **Firefox**: Fully supported
- **Safari**: Supported (iOS 11+)
- **Edge**: Supported

**Note**: Camera access requires HTTPS in production environments.

## File Structure

```
GlucoSnapAI/
├── index.html          # Main HTML file
├── styles.css          # CSS styles
├── script.js           # JavaScript functionality
└── README.md           # Documentation
```

## Technologies Used

- **HTML5**: Canvas API for image capture
- **CSS3**: Modern styling with gradients and animations
- **JavaScript**: ES6+ features for app functionality
- **TensorFlow.js**: Machine learning inference
- **Teachable Machine**: AI model training and deployment
- **MediaDevices API**: Camera access

## Deployment

### GitHub Pages
1. Push your code to a GitHub repository
2. Go to repository Settings > Pages
3. Select source branch (main/master)
4. Your app will be available at `https://username.github.io/repository-name`

### Netlify
1. Connect your GitHub repository to Netlify
2. Deploy automatically on every push
3. Custom domain support available

### Vercel
1. Import your GitHub repository
2. Deploy with zero configuration
3. Automatic HTTPS and custom domains

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Troubleshooting

### Camera Access Issues
- Ensure you're accessing the app via HTTPS or localhost
- Check browser permissions for camera access
- Try refreshing the page if camera doesn't start

### Model Loading Issues
- Verify your Teachable Machine model URL is correct
- Check browser console for detailed error messages
- Ensure stable internet connection for model download

### Performance Issues
- Use smaller image sizes for faster processing
- Consider compressing your Teachable Machine model
- Test on different devices for optimal performance

## Future Enhancements

- [ ] Barcode scanning integration
- [ ] Nutrition facts display
- [ ] Meal planning suggestions
- [ ] User preferences and dietary restrictions
- [ ] Offline model support
- [ ] Voice announcements for accessibility
- [ ] Multi-language support
- [ ] Recipe suggestions for healthy alternatives

---

**Made with ❤️ for healthier food choices**