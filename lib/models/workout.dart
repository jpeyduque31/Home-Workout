class Exercise {
  const Exercise({required this.id, required this.name, required this.description, required this.sets, this.reps, this.durationSeconds});
  final String id, name, description;
  final int sets;
  final int? reps, durationSeconds;
  String get measure => durationSeconds != null ? '$sets x ${durationSeconds}s' : '$sets x $reps';
}

class WorkoutDay {
  const WorkoutDay({required this.weekday, required this.name, required this.focus, required this.exercises, this.isRest = false});
  final int weekday;
  final String name, focus;
  final List<Exercise> exercises;
  final bool isRest;
}

class DayProgress {
  const DayProgress({required this.completed, required this.total});
  final int completed, total;
  double get fraction => total == 0 ? 1 : completed / total;
  bool get isComplete => total > 0 && completed == total;
}

class WeekHistory {
  const WeekHistory({required this.weekStart, required this.percentage, required this.exercisesCompleted});
  final DateTime weekStart;
  final double percentage;
  final int exercisesCompleted;
}
