import 'package:flutter_test/flutter_test.dart';
import 'package:home_workout/data/workout_data.dart';

void main() {
  test('fixed weekly plan contains six workouts and a rest day', () {
    expect(workoutDays, hasLength(7));
    expect(workoutDays.where((day) => day.isRest), hasLength(1));
    expect(workoutDays.take(6).every((day) => day.exercises.isNotEmpty), isTrue);
  });
}
