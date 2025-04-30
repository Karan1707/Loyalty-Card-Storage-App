# Loyalty Card Storage App

A Flutter-based mobile application for storing and managing loyalty cards. The app allows users to digitize their physical loyalty cards, scan barcodes, and access their cards offline.

## Features

- Store multiple loyalty cards in one place
- Scan barcodes/QR codes from physical cards
- Add card images and details
- Track points and expiry dates
- Receive notifications for expiring cards and points milestones
- Offline access to all card data
- Cloud synchronization when online
- Secure storage of card information

## Technical Stack

- Flutter
- Firebase (Authentication and Cloud Firestore)
- Hive (Local Storage)
- Provider (State Management)
- Mobile Scanner (Barcode Scanning)
- QR Flutter (QR Code Generation)
- Flutter Local Notifications

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio / VS Code
- Firebase account

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/loyalty-card-storage-app.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up Firebase:
   - Create a new Firebase project
   - Add Android and iOS apps to your Firebase project
   - Download and add the configuration files
   - Enable Authentication and Cloud Firestore

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── models/
│   └── loyalty_card.dart
├── screens/
│   ├── home_screen.dart
│   ├── add_card_screen.dart
│   └── card_details_screen.dart
├── services/
│   ├── card_provider.dart
│   ├── local_storage_service.dart
│   ├── cloud_sync_service.dart
│   └── notification_service.dart
├── utils/
└── main.dart
```

## Future Enhancements

1. Card Categories and Organization
2. Card Usage Statistics
3. Backup and Restore Functionality
4. Multi-language Support
5. Dark Mode
6. Card Sharing
7. Integration with Popular Loyalty Programs
8. Offline Barcode Scanning
9. Card Templates for Common Programs
10. Advanced Search and Filtering

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 