import 'package:flutter/widgets.dart';
import 'package:spelling_bee/blocs/game_bloc.dart';

/// A legacy provider class that will be replaced by the modern provider package
@Deprecated('Use package:provider/provider.dart instead. This is kept for backward compatibility only.')
class Provider extends InheritedWidget {
  const Provider({
    Key? key, 
    required this.game, 
    required Widget child
  }) : super(key: key, child: child);

  final GameBloc game;

  @override
  bool updateShouldNotify(Provider oldWidget) => true;
  
  static Provider? _maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>();
  }
  
  /// Get the Provider from the context
  static GameBloc of(BuildContext context) {
    final provider = _maybeOf(context);
    assert(provider != null, 'No Provider found in context');
    return provider!.game;
  }
}