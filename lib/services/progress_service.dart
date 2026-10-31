import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/workout_data.dart';
import '../models/workout.dart';

class ProgressService extends ChangeNotifier {
  ProgressService._(this._preferences);
  final SharedPreferences _preferences;
  final Map<String, Set<String>> _completed = {};
  static Future<ProgressService> create() async {
    final service = ProgressService._(await SharedPreferences.getInstance());
    service._load();
    return service;
  }
  static final _dateFormat = DateFormat('yyyy-MM-dd');
  String dateKey(DateTime date) => _dateFormat.format(date);
  void _load() {
    for (final key in _preferences.getKeys().where((key) => key.startsWith('day_'))) {
      final values = _preferences.getStringList(key);
      if (values != null && values.isNotEmpty) _completed[key.substring(4)] = values.toSet();
    }
  }
  DateTime mondayOf(DateTime date) => DateTime(date.year, date.month, date.day - date.weekday + 1);
  DateTime dateForWeekday(DateTime date, int weekday) => DateTime(date.year, date.month, date.day + weekday - date.weekday);
  bool isCompleted(DateTime date, String id) => _completed[dateKey(date)]?.contains(id) ?? false;
  Future<void> setCompleted(DateTime date, String id, bool completed) async {
    final key = dateKey(date);
    final values = _completed.putIfAbsent(key, () => <String>{});
    completed ? values.add(id) : values.remove(id);
    if (values.isEmpty) {
      _completed.remove(key);
      await _preferences.remove('day_$key');
    } else {
      await _preferences.setStringList('day_$key', values.toList());
    }
    notifyListeners();
  }
  DayProgress getDayProgress(DateTime date, WorkoutDay day) {
    final done = day.exercises.where((e) => isCompleted(date, e.id)).length;
    return DayProgress(completed: done, total: day.exercises.length);
  }
  double getWeekProgress(DateTime date) {
    final monday = mondayOf(date);
    var done = 0, total = 0;
    for (final day in workoutDays.where((d) => !d.isRest)) {
      final progress = getDayProgress(dateForWeekday(monday, day.weekday), day);
      done += progress.completed; total += progress.total;
    }
    return total == 0 ? 0 : done / total;
  }
  int getWeekExercises(DateTime date) {
    final monday = mondayOf(date);
    return workoutDays.where((d) => !d.isRest).fold(0, (sum, day) => sum + getDayProgress(dateForWeekday(monday, day.weekday), day).completed);
  }
  int getCompletedDays(DateTime date) {
    final monday = mondayOf(date);
    return workoutDays.where((d) => !d.isRest).where((day) => getDayProgress(dateForWeekday(monday, day.weekday), day).isComplete).length;
  }
  List<WeekHistory> getHistory(DateTime current) {
    final currentMonday = mondayOf(current);
    return List.generate(12, (i) => currentMonday.subtract(Duration(days: (i + 1) * 7)))
        .map((start) => WeekHistory(weekStart: start, percentage: getWeekProgress(start), exercisesCompleted: getWeekExercises(start)))
        .where((history) => history.percentage > 0 || history.exercisesCompleted > 0).toList();
  }
  String weekLabel(DateTime start) => '${DateFormat('MMM d').format(start)} – ${DateFormat('MMM d').format(start.add(const Duration(days: 6)))}';
}
