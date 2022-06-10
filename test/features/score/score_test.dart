import 'package:cabo_karte/features/score/domain/score.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Score', () {
    test('score should save initial value', () {
      final score = Score(initValue: 2);
      expect(score.getValue(), 2);
    });
    test('Score should retain set Value', () {
      final score = Score();
      score.setValue(15);
      expect(score.getValue(), 15);
    });
  });
}
