import 'package:messaging_core/core/utils/debouncer/debouncer.dart';

class FunctionDeBouncer extends DeBouncer<Function> {
  FunctionDeBouncer([int? duration]) : super(duration);

  @override
  void doOnListen(event) {
    event.call();
  }
}
