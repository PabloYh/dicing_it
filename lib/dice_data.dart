import 'dart:math';

class DiceData {
  final int limit;
  late int value = limit;
  static const Duration _rollingDuration = Duration(milliseconds: 1000);
  bool isMax = false;
  bool isMin = false;
  bool isAnimating = false;

  DiceData(this.limit);

  int rollValues() {
    value = Random().nextInt(limit) + 1;
    return value;
  }

  void setMaxMinDefault() {
    isMax = false;
    isMin = false;
  }

  static Duration fractionOfRollingDuration(double fraction) {
    return Duration(
        milliseconds: (_rollingDuration.inMilliseconds * fraction).toInt());
  }
}
