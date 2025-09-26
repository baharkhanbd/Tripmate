/* 
lib/
│
├── main.dart                // Entry point
├── app.dart                 // Theme, Routes, Localization, Providers
│
├── core/                    // Global things
│   ├── constants/           // Colors, Strings, App Constants
│   ├── enums/               // Enums
│   ├── utils/               // Helper functions, validators
│   └── widgets/             // Global reusable widgets (Buttons, Cards, Loading, etc.)
│
├── models/                  // All data models
│   ├── user_model.dart
│   ├── student_model.dart
│   ├── teacher_model.dart
│   ├── question_model.dart
│   ├── answer_model.dart
│   ├── chat_model.dart
│   └── class_model.dart
│
├── services/                // API & Local Storage
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── chat_service.dart
│   ├── question_service.dart
│   ├── student_service.dart
│   ├── teacher_service.dart
│   └── local_storage_service.dart
│
├── controllers/             // Business logic + Provider (ChangeNotifier)
│   ├── auth_controller.dart
│   ├── student_controller.dart
│   ├── teacher_controller.dart
│   ├── chat_controller.dart
│   ├── question_controller.dart
│   ├── class_controller.dart
│   └── notification_controller.dart
│
├── views/                   // UI Screens
│   ├── auth/
│   │    ├── login_page.dart
│   │    └── signup_page.dart
│   │
│   ├── student/
│   │    ├── home_page.dart
│   │    ├── class_room_page.dart
│   │    ├── challenge_page.dart
│   │    ├── message_page.dart
│   │    └── profile_page.dart
│   │
│   ├── teacher/
│   │    ├── home_page.dart
│   │    ├── classes_page.dart
│   │    ├── message_page.dart
│   │    └── profile_page.dart
│   │
│   ├── common/             // Screens shared by both (like chat, notifications)
│   │    ├── chat_page.dart
│   │    └── notifications_page.dart
│
├── routes/
│   └── app_routes.dart      // All named routes
│
├── localization/            // If you add multi-language support later
│   └── en.dart
│   └── bn.dart
│
└── config/                  // App configs (API base URL, App settings)
    └── app_config.dart





*/