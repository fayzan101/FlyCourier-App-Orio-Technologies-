# 🚀 FLY Courier - Mobile Courier Management App

A comprehensive Flutter-based mobile application for courier management, featuring QR code scanning, parcel tracking, and loadsheet management for delivery operations.

## 📱 Features

### 🔐 Authentication & User Management
- **Secure Login System** with email/password authentication
- **Remember Me** functionality for persistent sessions
- **User Profile Management** with employee information
- **Password Reset** functionality
- **Session Management** with automatic logout

### 📦 Parcel Management
- **QR Code Scanner** with green-themed animated overlay
- **Parcel Tracking** by shipment number
- **Parcel Details** including consignee information, addresses, and delivery details
- **Duplicate Scan Prevention** with intelligent cooldown system
- **Audio Feedback** with beep sound on successful scans

### 📋 Loadsheet Operations
- **Create Loadsheets** from scanned parcels
- **Arrival Management** for incoming shipments
- **Pickup Management** for outgoing shipments
- **Real-time Status Updates**

### 📊 Reporting & Analytics
- **Sheetwise Reports** with date range filtering
- **Performance Analytics** for delivery operations
- **Export Capabilities** for data analysis

### 🎨 User Interface
- **Modern Material Design 3** with custom theming
- **Responsive Layout** for various screen sizes
- **Custom Branding** with Fly Courier identity
- **Intuitive Navigation** with sidebar menu
- **Loading States** and error handling

## 🛠️ Technical Stack

### Frontend
- **Flutter** 3.8.1+ (Dart SDK)
- **GetX** for state management and navigation
- **Google Fonts** (Poppins) for typography
- **Material Design 3** components

### Backend Integration
- **RESTful API** integration with Orio Digital APIs
- **Dio** for HTTP client operations
- **Shared Preferences** for local data storage
- **Base64 Authentication** for secure API calls

### QR Code & Scanning
- **qr_code_scanner** for barcode/QR code scanning
- **qr_flutter** for QR code generation
- **Custom Scanner Overlay** with green theme and animations

### Additional Libraries
- **table_calendar** for date selection
- **intl** for internationalization
- **audioplayers** for audio feedback
- **flutter_launcher_icons** for app icons

## 📁 Project Structure

```
lib/
├── config/
│   └── api_config.dart          # API configuration
├── models/
│   ├── parcel_model.dart        # Parcel data model
│   └── user_model.dart          # User data model
├── screens/
│   ├── splash_screen.dart       # App splash screen
│   ├── login_screen.dart        # User authentication
│   ├── dashboard.dart           # Main dashboard
│   ├── qr_scanner_screen.dart   # QR code scanner
│   ├── arrival.dart             # Arrival management
│   ├── Pickup.dart              # Pickup management
│   ├── report_screen.dart       # Reports and analytics
│   ├── profile_screen.dart      # User profile
│   ├── sidebar_menu.dart        # Navigation menu
│   ├── create_account.dart      # Account creation
│   └── forgot_password.dart     # Password reset
├── services/
│   ├── user_service.dart        # User management service
│   └── parcel_service.dart      # Parcel operations service
├── Network/
│   └── network.dart             # Network utilities
├── utils/
│   ├── Colors/
│   │   └── color_resources.dart # Color definitions
│   ├── custom_snackbar.dart     # Custom notifications
│   └── qr_generator.dart        # QR code generation
├── widgets/
│   ├── custom_button.dart       # Reusable buttons
│   ├── custom_date_selector.dart # Date picker widget
│   ├── detail_row.dart          # Detail display widget
│   ├── fly_courier_branding.dart # Branding components
│   └── poppins_text.dart        # Typography widget
└── main.dart                    # App entry point
```

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** 3.8.1 or higher
- **Dart SDK** 3.0.0 or higher
- **Android Studio** / **VS Code** with Flutter extensions
- **Android SDK** (for Android development)
- **Xcode** (for iOS development, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd fly-courier
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoints**
   - Update API configuration in `lib/config/api_config.dart`
   - Ensure proper authentication credentials

4. **Run the application**
   ```bash
   flutter run
   ```

### Build for Production

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

## 🔧 Configuration

### API Configuration
The app integrates with Orio Digital APIs. Update the following endpoints in `lib/config/api_config.dart`:

- **Base URL**: `https://apis.orio.digital`
- **Authentication**: Base64 encoded email:password
- **Endpoints**:
  - Login: `/api/login`
  - Parcel Lookup: `/api/loadsheet_by_cn`
  - Create Loadsheet: `/api/create_loadsheet`
  - Reports: `/api/sheetwise_report`

### Environment Setup
1. **Android Permissions**: Camera and storage permissions are automatically configured
2. **iOS Permissions**: Camera usage description is included
3. **App Icons**: Custom app icon is configured in `pubspec.yaml`

## 📱 Key Features Explained

### QR Code Scanner
- **Green-themed overlay** with animated scanning lines
- **Real-time feedback** with audio beep on successful scans
- **Duplicate prevention** with intelligent timing controls
- **Error handling** for invalid QR codes

### Authentication Flow
- **Secure login** with API validation
- **Session persistence** using SharedPreferences
- **Automatic logout** on session expiry
- **Password reset** functionality

### Parcel Management
- **Track parcels** by shipment number
- **View detailed information** including consignee details
- **Create loadsheets** from scanned parcels
- **Manage arrivals and pickups**

## 🐛 Troubleshooting

### Common Issues

1. **Camera Permission Denied**
   - Ensure camera permissions are granted in device settings
   - Check Android/iOS permission configurations

2. **API Connection Issues**
   - Verify internet connectivity
   - Check API endpoint configurations
   - Ensure valid authentication credentials

3. **QR Scanner Not Working**
   - Check camera hardware availability
   - Verify QR code format and quality
   - Ensure proper lighting conditions

### Debug Mode
Enable debug mode for detailed logging:
```bash
flutter run --debug
```

## 📄 License

This project is proprietary software developed for FLY Courier operations.

## 🤝 Contributing

For internal development and contributions, please follow the established coding standards and review process.

## 📞 Support

For technical support or feature requests, please contact the development team or create an issue in the project repository.

---

**FLY Courier** - Streamlining delivery operations with modern mobile technology.
