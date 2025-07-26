class FoodData {
  final String name;
  final String category;
  final String description;
  final String healthWarning;
  final FoodAlternative alternative;
  final double confidence;

  FoodData({
    required this.name,
    required this.category,
    required this.description,
    required this.healthWarning,
    required this.alternative,
    this.confidence = 0.0,
  });
}

class FoodAlternative {
  final String title;
  final String description;
  final List<String> benefits;
  final String iconPath;

  FoodAlternative({
    required this.title,
    required this.description,
    required this.benefits,
    this.iconPath = '🍃',
  });
}

class FoodDatabase {
  static final Map<String, FoodData> _foods = {
    'candy': FoodData(
      name: 'Candy',
      category: 'High Sugar Snack',
      description: 'High in refined sugar and artificial ingredients. Can cause blood sugar spikes.',
      healthWarning: 'This food is high in sugar and may cause blood glucose spikes!',
      alternative: FoodAlternative(
        title: 'Jaggery (Gur)',
        description: 'Natural sweetener rich in minerals and iron',
        benefits: [
          'Contains iron and minerals',
          'Slower absorption than refined sugar',
          'Helps in digestion',
          'Rich in antioxidants'
        ],
        iconPath: '🟤',
      ),
    ),
    'chocolate': FoodData(
      name: 'Chocolate',
      category: 'High Sugar & Fat Snack',
      description: 'High in sugar, fat, and calories. Can be addictive due to sugar content.',
      healthWarning: 'High calorie content with refined sugar and saturated fats!',
      alternative: FoodAlternative(
        title: 'Dark Chocolate (70%+ cacao)',
        description: 'Rich in antioxidants with less sugar',
        benefits: [
          'High in antioxidants',
          'May improve heart health',
          'Contains less sugar',
          'Rich in minerals like iron and magnesium'
        ],
        iconPath: '🍫',
      ),
    ),
    'soda': FoodData(
      name: 'Soda',
      category: 'High Sugar Beverage',
      description: 'Extremely high in sugar with no nutritional value. Can cause rapid blood sugar spikes.',
      healthWarning: 'Contains excessive sugar and artificial additives!',
      alternative: FoodAlternative(
        title: 'Coconut Water',
        description: 'Natural electrolyte-rich beverage',
        benefits: [
          'Natural electrolytes',
          'Low in calories',
          'Contains potassium',
          'Naturally hydrating'
        ],
        iconPath: '🥥',
      ),
    ),
    'burger': FoodData(
      name: 'Burger',
      category: 'High Calorie Fast Food',
      description: 'High in calories, saturated fats, and sodium. Often lacks essential nutrients.',
      healthWarning: 'High in calories, saturated fats, and sodium!',
      alternative: FoodAlternative(
        title: 'Grilled Chicken Salad',
        description: 'Protein-rich meal with vegetables',
        benefits: [
          'High in protein',
          'Rich in vitamins and minerals',
          'Lower in calories',
          'High fiber content'
        ],
        iconPath: '🥗',
      ),
    ),
    'pizza': FoodData(
      name: 'Pizza',
      category: 'High Calorie Processed Food',
      description: 'High in calories, saturated fats, and sodium from processed ingredients.',
      healthWarning: 'High in calories and processed ingredients!',
      alternative: FoodAlternative(
        title: 'Whole Wheat Veggie Pizza',
        description: 'Healthier pizza option with whole grains',
        benefits: [
          'Higher fiber content',
          'More vitamins from vegetables',
          'Better nutrient profile',
          'Lower glycemic index'
        ],
        iconPath: '🍕',
      ),
    ),
    'ice cream': FoodData(
      name: 'Ice Cream',
      category: 'High Sugar Frozen Dessert',
      description: 'Very high in sugar and saturated fats. Can cause rapid blood sugar elevation.',
      healthWarning: 'Very high in sugar and saturated fats!',
      alternative: FoodAlternative(
        title: 'Frozen Yogurt with Berries',
        description: 'Lower sugar frozen treat with probiotics',
        benefits: [
          'Contains probiotics',
          'Lower in sugar',
          'Rich in protein',
          'Antioxidants from berries'
        ],
        iconPath: '🍨',
      ),
    ),
    'apple': FoodData(
      name: 'Apple',
      category: 'Healthy Fruit',
      description: 'Excellent source of fiber, vitamins, and natural sugars with a low glycemic index.',
      healthWarning: 'Great choice! This is already a healthy option.',
      alternative: FoodAlternative(
        title: 'Keep enjoying apples!',
        description: 'You\'re making a great healthy choice',
        benefits: [
          'High in fiber',
          'Rich in vitamin C',
          'Natural antioxidants',
          'Helps regulate blood sugar'
        ],
        iconPath: '🍎',
      ),
    ),
  };

  static FoodData? getFoodData(String foodName) {
    return _foods[foodName.toLowerCase()];
  }

  static FoodData getDefaultFoodData() {
    return _foods['candy']!;
  }

  static List<String> getAllFoodNames() {
    return _foods.keys.toList();
  }

  static bool isHealthyFood(String foodName) {
    final food = getFoodData(foodName);
    return food?.category.toLowerCase().contains('healthy') ?? false;
  }
}