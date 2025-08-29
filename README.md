# 🛍️ SnapShop - Flutter E-Commerce App

A modern, responsive Flutter e-commerce application with Firebase backend integration, featuring user authentication, product management, shopping cart, favorites, and order processing.

## ✨ Features

### 🔐 Authentication & User Management
- **User Registration & Login**: Secure authentication with email/password
- **OTP Verification**: Email-based OTP for account verification
- **Password Reset**: Secure password recovery with OTP
- **Social Login**: Google and Apple sign-in support
- **User Profiles**: Manage personal information and delivery addresses

### 🏠 Home & Product Management
- **Dynamic Categories**: Display and filter products by category
- **Product Grid**: Responsive product display with search functionality
- **Product Details**: Comprehensive product information and images
- **Random Products**: Featured products showcase
- **Live Search**: Real-time product search with debouncing

### 🔍 Advanced Search & Filtering
- **Smart Search**: Search across product titles and descriptions
- **Category Filtering**: Filter by product categories
- **Price Range Filter**: Filter products by price range
- **Dynamic Filters**: Apply multiple filters simultaneously
- **Local Filtering**: Fast client-side filtering for better performance

### ❤️ Favorites & Wishlist
- **Add to Favorites**: Heart products for later viewing
- **Firebase Integration**: Sync favorites across devices
- **Wishlist Management**: Organize and manage favorite products
- **Search in Wishlist**: Find specific items in your favorites

### 🛒 Shopping Cart & Orders
- **Shopping Cart**: Add, remove, and manage cart items
- **Quantity Management**: Increase/decrease product quantities
- **Order Preview**: Review orders before checkout
- **Order History**: Track current and past orders
- **Firebase Storage**: Persistent cart and order data

### 📱 Responsive Design
- **ScreenUtil Integration**: Responsive UI across all device sizes
- **Material Design**: Modern, intuitive user interface
- **Cross-Platform**: Works seamlessly on iOS and Android
- **Adaptive Layouts**: Optimized for different screen orientations

## 🏗️ Architecture

### State Management
- **Flutter Bloc**: Clean architecture with BLoC pattern
- **Cubits**: Lightweight state management for simple features
- **State Classes**: Well-defined state management structure

### Project Structure
```
lib/
├── core/                    # Core utilities and constants
│   ├── app_color.dart      # Centralized color management
│   ├── custom_button.dart  # Reusable UI components
│   └── custom_textformfield_container.dart
├── features/               # Feature-based modules
│   ├── home/              # Home screen and product features
│   ├── cart/              # Shopping cart and orders
│   ├── account/           # User profile and settings
│   ├── login_signup/      # Authentication flows
│   ├── onboarding/        # App introduction screens
│   └── splash_screen/     # App launch screen
├── models/                 # Data models
├── api/                    # API service layer
└── db/                     # Firebase database services
```

### Key Components
- **AppColor**: Centralized color management system
- **ScreenUtil**: Responsive design utilities
- **FirebaseService**: Backend integration layer
- **ApiService**: External API integration (dummyjson.com)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/snapshop.git
   cd snapshop
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project
   - Add Android and iOS apps
   - Download and add configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS
   - Enable Authentication and Firestore

4. **Run the app**
   ```bash
   flutter run
   ```

### Environment Configuration
- Ensure Firebase configuration is properly set up
- Configure email OTP settings if using email verification
- Set up API keys for external services

## 🔧 Configuration

### Firebase Setup
1. **Authentication**
   - Enable Email/Password authentication
   - Configure Google and Apple sign-in (optional)
   - Set up password reset policies

2. **Firestore Database**
   - Create collections for users, products, orders
   - Set up security rules
   - Configure indexes for queries

3. **Storage** (if using image uploads)
   - Set up Firebase Storage
   - Configure security rules

### API Configuration
- **DummyJSON**: Used for product data
- **Email OTP**: Configure for password reset
- **Custom APIs**: Add your own product APIs

## 📱 Screenshots
<img width="1920" height="1080" alt="1" src="https://github.com/user-attachments/assets/e209cef3-23c9-4cf2-b915-9fb65859f032" />
<img width="1920" height="1080" alt="2" src="https://github.com/user-attachments/assets/32d33e17-f425-402a-89f4-868cc09cc050" />

### Main Screens
- **Splash Screen**: App launch with branding
- **Onboarding**: App introduction and feature highlights
- **Home Screen**: Product categories and featured items
- **Search Screen**: Advanced search with filters
- **Product Details**: Comprehensive product information
- **Cart Screen**: Shopping cart management
- **Profile Screen**: User account and settings

### Features
- **Responsive Design**: Adapts to all screen sizes
- **Dark/Light Theme**: Consistent color scheme
- **Smooth Navigation**: Intuitive user flow
- **Loading States**: Professional loading indicators

## 🛠️ Development

### Code Style
- **Clean Architecture**: Separation of concerns
- **Consistent Naming**: Clear, descriptive names
- **Documentation**: Comprehensive code comments
- **Error Handling**: Robust error management

### Testing
- **Unit Tests**: Core functionality testing
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end testing

### Performance
- **Image Optimization**: Efficient image loading
- **State Management**: Optimized state updates
- **API Caching**: Reduced network requests
- **Local Storage**: Offline functionality

## 🔒 Security

### Authentication
- **Secure Login**: Encrypted password storage
- **Session Management**: Secure token handling
- **Password Policies**: Strong password requirements

### Data Protection
- **Firebase Security Rules**: Database access control
- **Input Validation**: User input sanitization
- **Error Handling**: Secure error messages

## 📦 Dependencies

### Core Dependencies
```yaml
flutter_bloc: ^8.1.3          # State management
firebase_core: ^2.24.2        # Firebase core
firebase_auth: ^4.15.3        # Authentication
cloud_firestore: ^4.13.6      # Database
flutter_screenutil: ^5.9.0    # Responsive design
http: ^1.1.0                  # HTTP requests
```

### UI Dependencies
```yaml
smooth_page_indicator: ^1.1.0 # Page indicators
image_picker: ^1.0.4          # Image selection
cached_network_image: ^3.3.0  # Image caching
```

## 🚀 Deployment

### Android
1. **Build APK**
   ```bash
   flutter build apk --release
   ```

2. **Build App Bundle**
   ```bash
   flutter build appbundle --release
   ```

### iOS
1. **Build iOS App**
   ```bash
   flutter build ios --release
   ```

2. **Archive in Xcode**
   - Open iOS project in Xcode
   - Archive and distribute

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

### Code Review
- Follow Flutter best practices
- Ensure responsive design
- Test on multiple devices
- Update documentation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing framework
- **Firebase**: For backend services
- **DummyJSON**: For sample product data
- **Open Source Community**: For various packages

## 📞 Support

### Issues
- Report bugs via GitHub Issues
- Include device information and steps to reproduce
- Provide error logs when possible

### Questions
- Check existing issues and discussions
- Create new issues for questions
- Contact maintainers for urgent issues

### Feature Requests
- Submit feature requests via GitHub Issues
- Describe the feature and its benefits
- Include mockups if applicable

---

**Made with ❤️ using Flutter & Firebase**

*Last updated: December 2024*
