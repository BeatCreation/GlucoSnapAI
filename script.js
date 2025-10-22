// Global variables
let video, canvas, ctx;
let stream = null;
let model = null;
let isModelLoaded = false;

// Teachable Machine model URL - Update this with your actual model URL
const MODEL_URL = 'https://teachablemachine.withgoogle.com/models/YOUR_MODEL_ID/';

// Food categories and their alternatives
const foodDatabase = {
    'candy': {
        category: 'High Sugar Snack',
        description: 'High in refined sugar and artificial ingredients. Can cause blood sugar spikes.',
        healthWarning: 'This food is high in sugar and may cause blood glucose spikes!',
        alternative: {
            title: 'Jaggery (Gur)',
            description: 'Natural sweetener rich in minerals and iron',
            benefits: [
                'Contains iron and minerals',
                'Slower absorption than refined sugar',
                'Helps in digestion',
                'Rich in antioxidants'
            ]
        }
    },
    'chocolate': {
        category: 'High Sugar & Fat Snack',
        description: 'High in sugar, fat, and calories. Can be addictive due to sugar content.',
        healthWarning: 'High calorie content with refined sugar and saturated fats!',
        alternative: {
            title: 'Dark Chocolate (70%+ cacao)',
            description: 'Rich in antioxidants with less sugar',
            benefits: [
                'High in antioxidants',
                'May improve heart health',
                'Contains less sugar',
                'Rich in minerals like iron and magnesium'
            ]
        }
    },
    'soda': {
        category: 'High Sugar Beverage',
        description: 'Extremely high in sugar with no nutritional value. Can cause rapid blood sugar spikes.',
        healthWarning: 'Contains excessive sugar and artificial additives!',
        alternative: {
            title: 'Coconut Water',
            description: 'Natural electrolyte-rich beverage',
            benefits: [
                'Natural electrolytes',
                'Low in calories',
                'Contains potassium',
                'Naturally hydrating'
            ]
        }
    },
    'burger': {
        category: 'High Calorie Fast Food',
        description: 'High in calories, saturated fats, and sodium. Often lacks essential nutrients.',
        healthWarning: 'High in calories, saturated fats, and sodium!',
        alternative: {
            title: 'Grilled Chicken Salad',
            description: 'Protein-rich meal with vegetables',
            benefits: [
                'High in protein',
                'Rich in vitamins and minerals',
                'Lower in calories',
                'High fiber content'
            ]
        }
    },
    'pizza': {
        category: 'High Calorie Processed Food',
        description: 'High in calories, saturated fats, and sodium from processed ingredients.',
        healthWarning: 'High in calories and processed ingredients!',
        alternative: {
            title: 'Whole Wheat Veggie Pizza',
            description: 'Healthier pizza option with whole grains',
            benefits: [
                'Higher fiber content',
                'More vitamins from vegetables',
                'Better nutrient profile',
                'Lower glycemic index'
            ]
        }
    },
    'ice cream': {
        category: 'High Sugar Frozen Dessert',
        description: 'Very high in sugar and saturated fats. Can cause rapid blood sugar elevation.',
        healthWarning: 'Very high in sugar and saturated fats!',
        alternative: {
            title: 'Frozen Yogurt with Berries',
            description: 'Lower sugar frozen treat with probiotics',
            benefits: [
                'Contains probiotics',
                'Lower in sugar',
                'Rich in protein',
                'Antioxidants from berries'
            ]
        }
    },
    'apple': {
        category: 'Healthy Fruit',
        description: 'Excellent source of fiber, vitamins, and natural sugars with a low glycemic index.',
        healthWarning: 'Great choice! This is already a healthy option.',
        alternative: {
            title: 'Keep enjoying apples!',
            description: 'You\'re making a great healthy choice',
            benefits: [
                'High in fiber',
                'Rich in vitamin C',
                'Natural antioxidants',
                'Helps regulate blood sugar'
            ]
        }
    }
};

// DOM elements
const startCameraBtn = document.getElementById('startCamera');
const captureBtn = document.getElementById('captureBtn');
const stopCameraBtn = document.getElementById('stopCamera');
const newScanBtn = document.getElementById('newScanBtn');
const retryBtn = document.getElementById('retryBtn');

const cameraSection = document.getElementById('cameraSection');
const loadingSection = document.getElementById('loadingSection');
const resultsSection = document.getElementById('resultsSection');
const errorSection = document.getElementById('errorSection');

// Initialize the app
document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
    setupEventListeners();
});

function initializeApp() {
    video = document.getElementById('video');
    canvas = document.getElementById('canvas');
    ctx = canvas.getContext('2d');
    
    // Try to load the Teachable Machine model
    loadModel();
}

function setupEventListeners() {
    startCameraBtn.addEventListener('click', startCamera);
    captureBtn.addEventListener('click', captureAndAnalyze);
    stopCameraBtn.addEventListener('click', stopCamera);
    newScanBtn.addEventListener('click', resetToCamera);
    retryBtn.addEventListener('click', resetToCamera);
}

async function loadModel() {
    try {
        // For demo purposes, we'll simulate model loading
        // In a real implementation, you would load your actual Teachable Machine model
        console.log('Loading Teachable Machine model...');
        
        // Simulate model loading delay
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        // For demo, we'll use a mock model
        model = {
            predict: mockPredict
        };
        
        isModelLoaded = true;
        console.log('Model loaded successfully');
    } catch (error) {
        console.error('Error loading model:', error);
        isModelLoaded = false;
    }
}

// Mock prediction function for demo purposes
function mockPredict(imageElement) {
    return new Promise((resolve) => {
        // Simulate AI processing time
        setTimeout(() => {
            // Mock predictions - in real implementation, this would come from Teachable Machine
            const mockPredictions = [
                { className: 'candy', probability: 0.95 },
                { className: 'apple', probability: 0.03 },
                { className: 'chocolate', probability: 0.02 }
            ];
            resolve(mockPredictions);
        }, 1500);
    });
}

async function startCamera() {
    try {
        const constraints = {
            video: {
                width: { ideal: 640 },
                height: { ideal: 480 },
                facingMode: 'environment' // Use back camera if available
            }
        };

        stream = await navigator.mediaDevices.getUserMedia(constraints);
        video.srcObject = stream;
        
        video.onloadedmetadata = () => {
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
        };

        // Update UI
        startCameraBtn.style.display = 'none';
        captureBtn.style.display = 'inline-flex';
        stopCameraBtn.style.display = 'inline-flex';
        
        // Add animation
        video.parentElement.classList.add('fade-in');
        
    } catch (error) {
        console.error('Error accessing camera:', error);
        showError('Unable to access camera. Please check permissions and try again.');
    }
}

function stopCamera() {
    if (stream) {
        stream.getTracks().forEach(track => track.stop());
        stream = null;
    }
    
    video.srcObject = null;
    
    // Update UI
    startCameraBtn.style.display = 'inline-flex';
    captureBtn.style.display = 'none';
    stopCameraBtn.style.display = 'none';
}

async function captureAndAnalyze() {
    if (!isModelLoaded) {
        showError('AI model is still loading. Please wait a moment and try again.');
        return;
    }

    try {
        // Show loading
        showLoading();
        
        // Capture image from video
        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
        const capturedImageData = canvas.toDataURL('image/jpeg', 0.8);
        
        // Create image element for prediction
        const imageElement = new Image();
        imageElement.onload = async () => {
            try {
                // Predict using the model
                const predictions = await model.predict(imageElement);
                
                // Process and display results
                displayResults(capturedImageData, predictions);
                
            } catch (error) {
                console.error('Prediction error:', error);
                showError('Error analyzing the image. Please try again.');
            }
        };
        
        imageElement.src = capturedImageData;
        
    } catch (error) {
        console.error('Capture error:', error);
        showError('Error capturing image. Please try again.');
    }
}

function displayResults(capturedImage, predictions) {
    // Get the top prediction
    const topPrediction = predictions.reduce((max, prediction) => 
        prediction.probability > max.probability ? prediction : max
    );
    
    const confidence = Math.round(topPrediction.probability * 100);
    const foodType = topPrediction.className.toLowerCase();
    
    // Get food data
    const foodData = foodDatabase[foodType] || foodDatabase['candy']; // Default to candy if not found
    
    // Update UI elements
    document.getElementById('capturedImage').src = capturedImage;
    document.getElementById('categoryName').textContent = foodData.category;
    document.getElementById('confidenceBadge').textContent = `${confidence}%`;
    document.getElementById('categoryDescription').textContent = foodData.description;
    document.getElementById('healthWarning').textContent = foodData.healthWarning;
    document.getElementById('alternativeTitle').textContent = foodData.alternative.title;
    document.getElementById('alternativeDescription').textContent = foodData.alternative.description;
    
    // Update benefits list
    const benefitsList = document.getElementById('benefitsList');
    benefitsList.innerHTML = '';
    foodData.alternative.benefits.forEach(benefit => {
        const li = document.createElement('li');
        li.textContent = benefit;
        benefitsList.appendChild(li);
    });
    
    // Update health alert styling based on food type
    const healthAlert = document.getElementById('healthAlert');
    if (foodType === 'apple' || confidence < 50) {
        healthAlert.style.background = 'linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%)';
        healthAlert.style.borderColor = '#28a745';
        healthAlert.style.color = '#155724';
        healthAlert.querySelector('i').className = 'fas fa-check-circle';
    } else {
        healthAlert.style.background = 'linear-gradient(135deg, #fed7d7 0%, #feb2b2 100%)';
        healthAlert.style.borderColor = '#fc8181';
        healthAlert.style.color = '#c53030';
        healthAlert.querySelector('i').className = 'fas fa-exclamation-triangle';
    }
    
    // Show results section
    showResults();
}

function showLoading() {
    cameraSection.style.display = 'none';
    loadingSection.style.display = 'block';
    resultsSection.style.display = 'none';
    errorSection.style.display = 'none';
    
    loadingSection.classList.add('fade-in');
}

function showResults() {
    cameraSection.style.display = 'none';
    loadingSection.style.display = 'none';
    resultsSection.style.display = 'block';
    errorSection.style.display = 'none';
    
    resultsSection.classList.add('slide-up');
}

function showError(message) {
    cameraSection.style.display = 'none';
    loadingSection.style.display = 'none';
    resultsSection.style.display = 'none';
    errorSection.style.display = 'block';
    
    document.getElementById('errorMessage').textContent = message;
    errorSection.classList.add('fade-in');
}

function resetToCamera() {
    cameraSection.style.display = 'block';
    loadingSection.style.display = 'none';
    resultsSection.style.display = 'none';
    errorSection.style.display = 'none';
    
    // Clear animation classes
    cameraSection.classList.remove('fade-in');
    resultsSection.classList.remove('slide-up');
    errorSection.classList.remove('fade-in');
    loadingSection.classList.remove('fade-in');
}

// Utility function to check if device has camera
async function checkCameraSupport() {
    try {
        const devices = await navigator.mediaDevices.enumerateDevices();
        const hasCamera = devices.some(device => device.kind === 'videoinput');
        
        if (!hasCamera) {
            showError('No camera found on this device.');
            return false;
        }
        return true;
    } catch (error) {
        console.error('Error checking camera support:', error);
        showError('Unable to access camera. Please check permissions.');
        return false;
    }
}

// Handle page visibility change to manage camera resources
document.addEventListener('visibilitychange', () => {
    if (document.hidden && stream) {
        // Page is hidden, stop camera to save resources
        stopCamera();
    }
});

// Handle window resize for responsive design
window.addEventListener('resize', () => {
    if (video && video.videoWidth) {
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
    }
});

// Handle orientation change on mobile devices
window.addEventListener('orientationchange', () => {
    setTimeout(() => {
        if (video && video.videoWidth) {
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
        }
    }, 500);
});

// Check for HTTPS requirement
if (location.protocol !== 'https:' && location.hostname !== 'localhost') {
    console.warn('Camera access requires HTTPS. Please serve this app over HTTPS.');
}

// Initialize camera support check
window.addEventListener('load', async () => {
    await checkCameraSupport();
});