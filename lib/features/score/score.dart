class Score {
  int? _value;

  Score({
    int initValue = 0,
  }) {
    _value = initValue;
  }

  void setValue(int value) {
    _value = value;
  }

  int getValue() {
    return _value ?? 0;
  }
}
