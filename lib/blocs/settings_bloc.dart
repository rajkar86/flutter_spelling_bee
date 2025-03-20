import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:spelling_bee/services/storage_service.dart';

/// A BLoC to manage application settings
class SettingsBloc {
  // BehaviorSubject to track theme changes
  final BehaviorSubject<int> theme = BehaviorSubject<int>();

  SettingsBloc();

  /// Initialize settings from storage
  Future<void> init() async {
    // Load theme setting
    final themeIndex = await StorageService.loadTheme();
    theme.add(themeIndex);
    
    // Listen for theme changes and save them
    theme.listen((int themeIndex) async {
      await StorageService.saveTheme(themeIndex);
    });
  }

  /// Dispose of resources
  void dispose() {
    theme.close();
  }
}