# All-in-One Video Saver

A centralized media vault app that lets users save or bookmark videos/posts from any platform.

## Features

- Share video/post links from any platform to this app (via Android share intent)
- Save videos locally or to the cloud (Firebase, S3, or local storage)
- Organize content by folders/tags
- Search and filter saved media
- (Future scope) Add AI features like auto-categorization and summaries

## Tech Stack

- **Framework:** Flutter 3.x
- **State Management:** Riverpod (latest version)
- **Architecture:** MVVM (Model–View–ViewModel)
- **Navigation:** go_router
- **Local Storage:** Hive
- **Cloud:** Firebase (optional placeholders)
- **HTTP Client:** Dio
- **Download Handling:** Dio + flutter_downloader
- **Permissions:** permission_handler
- **Share Intent:** receive_sharing_intent
- **Analytics:** firebase_analytics
- **Dependency Injection:** Riverpod Providers
- **Theming:** Light/Dark mode support

## Project Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── color_schemes.dart
│       └── text_styles.dart
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── utils/
│   ├── services/
│   │   ├── share_intent_service.dart
│   │   ├── download_service.dart
│   │   ├── file_service.dart
│   │   ├── platform_detector.dart
│   │   └── permissions_service.dart
│   └── widgets/
│       ├── common_button.dart
│       ├── common_text_field.dart
│       ├── common_card.dart
│       └── ...
│
├── data/
│   ├── models/
│   │   ├── video_model.dart
│   │   ├── folder_model.dart
│   │   ├── user_model.dart
│   │   └── platform_model.dart
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── video_local_source.dart
│   │   │   └── folder_local_source.dart
│   │   ├── remote/
│   │   │   ├── video_remote_source.dart
│   │   │   └── auth_remote_source.dart
│   └── repositories/
│       ├── video_repository.dart
│       ├── folder_repository.dart
│       └── auth_repository.dart
│
├── features/
│   ├── home/
│   │   ├── view/
│   │   │   └── home_screen.dart
│   │   ├── view_model/
│   │   │   └── home_view_model.dart
│   │   └── widgets/
│   │       └── video_card.dart
│   │
│   ├── video_detail/
│   │   ├── view/
│   │   ├── view_model/
│   │   └── widgets/
│   │
│   ├── downloader/
│   │   ├── view/
│   │   ├── view_model/
│   │   └── services/
│   │       └── link_parser_service.dart
│   │
│   ├── auth/
│   │   ├── view/
│   │   ├── view_model/
│   │   ├── services/
│   │   └── widgets/
│   │
│   └── settings/
│       ├── view/
│       ├── view_model/
│       └── widgets/
│
└── providers/
    ├── global_providers.dart
    └── dependency_injection.dart
```

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter pub run build_runner build` to generate Riverpod code
4. Run the app with `flutter run`

## Dependencies

All dependencies are listed in `pubspec.yaml`. Key dependencies include:
- riverpod for state management
- go_router for navigation
- hive for local storage
- dio for HTTP requests
- flutter_downloader for downloads
- permission_handler for permissions
- receive_sharing_intent for share intents

## Architecture

This app follows the MVVM (Model-View-ViewModel) architecture pattern with Riverpod for state management. The structure is designed to be modular and scalable.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.