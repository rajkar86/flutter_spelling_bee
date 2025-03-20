import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';

/// Extension on BuildContext to support backward compatibility with the old Provider
extension ProviderAdapter on BuildContext {
  /// Get the GameBloc from context
  GameBloc get gameBloc => Provider.of<GameBloc>(this);
}

/// Class that mimics the old Provider API but uses the new provider package under the hood
class LegacyProvider {
  /// Get the GameBloc from context
  static GameBloc of(BuildContext context) {
    return Provider.of<GameBloc>(context);
  }
} 
