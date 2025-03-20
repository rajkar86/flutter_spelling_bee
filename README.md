# Source-code for the NY Times style Spelling Bee app 

App can be downloaded here: https://play.google.com/store/apps/details?id=com.kraj.spelling.bee

![Screenshot](images/Screenshot1.png?raw=true "Screenshot")

### Installation
1. Install [Flutter](https://flutter.dev/)
2. Install [Android Studio](https://developer.android.com/studio) or [Intellij](https://www.jetbrains.com/idea/)
3. Install Flutter plugin for your IDE
4. Copy example key properties file:
```
cd android/
cp key.properties.example key.properties
```
5. Run the project
```
flutter run
```

# Flutter Spelling Bee

A Spelling Bee clone built with Flutter.

## Migration Progress

### What's Been Updated

#### Dependencies
- All dependencies have been updated to their modern, null-safe versions in `pubspec.yaml`, including:
  - `rxdart` to the latest version
  - `shared_preferences` for state persistence
  - `provider` for state management
  - `flutter_polygon` for the hexagon widget

#### Provider Migration
- Created `provider_adapter.dart` as a compatibility layer for the transition
- Updated all imports and usages of the custom Provider to the official provider package
- Added proper typing to all Provider implementations
- Fixed Provider.of calls throughout the app

#### Null Safety
- All files have been updated to support null safety, particularly:
  - `lib/blocs/game_bloc.dart` - Updated types and handling of nullability
  - `lib/blocs/settings_bloc.dart` - Converted to null-safe code
  - All widget constructors now use `required` and proper `Key?` parameters
  - Added late initialization where appropriate
  - Added null checks and fallbacks

#### Storage Implementation
- Created a dedicated `StorageService` class to replace the old native_state functionality
- Implemented proper state persistence using `SharedPreferences`
- Added route persistence for navigation state
- Upgraded the Assets helper to use typed Maps and Lists

#### Widget Modernization
- Replaced deprecated widgets like `Container` with `SizedBox` where appropriate
- Added `const` constructors for better performance
- Added `const` to static widgets to improve Flutter's performance
- Fixed typing issues with animations in `tally.dart`
- Updated Tween implementation for null safety
- Improved UI with better layout and design

#### Core Files Updated
The following files have been updated for null safety and modernization:
- `lib/blocs/game_bloc.dart`
- `lib/blocs/settings_bloc.dart`
- `lib/widgets/word_list.dart`
- `lib/widgets/tally.dart`
- `lib/pages/main_menu.dart`
- `lib/pages/rules.dart`
- `lib/pages/settings.dart`
- `lib/pages/game.dart`
- `lib/main.dart`
- `lib/helpers/ui.dart`
- `lib/helpers/assets.dart`
- `lib/services/storage_service.dart` (New file)

### Final Testing Checklist
- [ ] Test the application on different devices/screen sizes
- [ ] Test state persistence between app restarts
- [ ] Verify the game mechanics work correctly (adding words, scoring, etc.)
- [ ] Check that theme switching works properly
- [ ] Ensure animations run smoothly

## References
- [Dart Null Safety Migration Guide](https://dart.dev/null-safety/migration-guide)
- [Flutter Provider Package](https://pub.dev/packages/provider)
- [SharedPreferences Documentation](https://pub.dev/packages/shared_preferences)
- [Material 3 Design](https://m3.material.io/)
- [Flutter Animation Guide](https://docs.flutter.dev/ui/animations)

## Original Game Description

The objective is to find as many words as possible given 7 letters. The words must:

1. Be at least 4 letters long
2. Use the center letter
3. Letters can be used multiple times
4. Every puzzle includes at least one pangram - a word that uses all 7 letters

## Point Values

- 4 letters: 1 point
- 5+ letters: 1 point per letter
- Pangram: 7 point bonus

