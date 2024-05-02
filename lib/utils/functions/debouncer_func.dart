import 'dart:async';

import 'package:flutter/cupertino.dart';

class DebouncerFunc {
  final int milliseconds;
  Timer? _timer;

  DebouncerFunc({
    required this.milliseconds,
  });

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Notifies if the delayed call is active.
  bool get isRunning => _timer?.isActive ?? false;

  /// Cancel the current delayed call.
  void cancel() => _timer?.cancel();
}
