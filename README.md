# aash_india

Freelancing project

### Project Folder Structure

lib/
│
├── main.dart                   // Entry point of the app
│
├── core/                       // Core functionalities
│   ├── config/                 // App configurations (theme, environment, etc.)
│   ├── constants/              // App constants (e.g., strings, keys)
│   └── utils/                  // Utility functions, helpers
│
├── data/                       // Data layer
│   ├── models/                 // Data models
│   ├── repositories/           // Business logic, API calls
│   └── providers/              // Provider classes (if using Provider for state management)
│
├── presentation/               // Presentation layer
│   ├── screens/                // All screens
│   │   ├── home/               // Home screen folder
│   │   ├── login/              // Login screen folder
│   │   └── coupon/             // Coupon-related screens
│   │
│   ├── widgets/                // Reusable widgets
│   ├── components/             // Small, reusable components (e.g., buttons, cards)
│   └── styles/                 // Styles, themes, and UI-related configurations
│
├── routes/                     // Navigation and routes
│   └── app_routes.dart         // Route management
│
└── services/                   // External services
    ├── api/                    // API services
    ├── local_storage/          // Local storage management
    └── notification/           // Notification service