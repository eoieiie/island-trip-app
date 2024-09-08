class Throttle {
  final Duration duration;
  bool _isReady = true;

  Throttle(this.duration);

  void call(Function action) {
    if (_isReady) {
      _isReady = false;
      action();
      Future.delayed(duration, () {
        _isReady = true;
      });
    }
  }
}
