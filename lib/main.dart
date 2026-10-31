import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'data/workout_data.dart';
import 'models/workout.dart';
import 'services/progress_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(App(service: await ProgressService.create()));
}

class App extends StatelessWidget {
  const App({super.key, required this.service});
  final ProgressService service;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: service,
    builder: (context, _) => MaterialApp(title: 'Home Workout', theme: AppTheme.dark(), debugShowCheckedModeBanner: false,
      home: Splash(service: service)),
  );
}

class Splash extends StatefulWidget {
  const Splash({super.key, required this.service});
  final ProgressService service;
  @override State<Splash> createState() => _SplashState();
}
class _SplashState extends State<Splash> {
  Timer? _timer;
  @override void initState() { super.initState(); _timer = Timer(const Duration(milliseconds: 2500), () {
    if (mounted) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MainShell(service: widget.service)));
  }); }
  @override void dispose() { _timer?.cancel(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Image.asset('assets/logo.png', width: 150, height: 150),
    const SizedBox(height: 24), Text('HOME WORKOUT', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 2)),
    const SizedBox(height: 8), Text('Your fitness journey starts here.', style: TextStyle(color: Colors.white70)),
    const SizedBox(height: 28), const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)),
  ])));
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.service});
  final ProgressService service;
  @override State<MainShell> createState() => _MainShellState();
}
class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  int index = 0;
  DateTime now = DateTime.now();
  @override void initState() { super.initState(); WidgetsBinding.instance.addObserver(this); }
  @override void dispose() { WidgetsBinding.instance.removeObserver(this); super.dispose(); }
  @override void didChangeAppLifecycleState(AppLifecycleState state) { if (state == AppLifecycleState.resumed) setState(() => now = DateTime.now()); }
  @override Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: index, children: [Dashboard(service: widget.service, now: now), Schedule(service: widget.service, now: now), ProgressPage(service: widget.service, now: now)]),
    bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (value) => setState(() => index = value),
      destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'), NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Schedule'), NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Progress')]),
  );
}

String greeting(DateTime date) => date.hour < 12 ? 'Good morning' : date.hour < 17 ? 'Good afternoon' : 'Good evening';
String percent(double value) => '${(value * 100).round()}%';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key, required this.service, required this.now});
  final ProgressService service; final DateTime now;
  @override Widget build(BuildContext context) {
    final day = workoutFor(now.weekday), progress = service.getDayProgress(now, day), weekly = service.getWeekProgress(now);
    return Page(padding: true, children: [
      Text(greeting(now), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
      Text(DateFormat('EEEE, MMMM d').format(now), style: const TextStyle(color: Colors.white60)),
      const SizedBox(height: 24),
      Card(child: ListTile(contentPadding: const EdgeInsets.all(18), leading: const Icon(Icons.format_quote, color: AppTheme.green, size: 32),
        title: const Text('DAILY MOTIVATION', style: TextStyle(color: AppTheme.green, fontWeight: FontWeight.bold, letterSpacing: 1)),
        subtitle: Padding(padding: const EdgeInsets.only(top: 8), child: Text(motivation[now.weekday]!, style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16))))),
      const SizedBox(height: 14),
      if (day.isRest) RestCard() else Card(child: InkWell(borderRadius: BorderRadius.circular(16), onTap: () => openWorkout(context, service, now, day),
        child: Padding(padding: const EdgeInsets.all(18), child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("TODAY'S WORKOUT", style: TextStyle(color: AppTheme.green, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 8), Text(day.focus, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)), Text('${day.exercises.length} exercises  •  ${progress.completed}/${progress.total} completed', style: const TextStyle(color: Colors.white60))])),
          const Icon(Icons.arrow_forward_ios, size: 18, color: AppTheme.green),
        ])))),
      const SizedBox(height: 14),
      Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('WEEKLY PROGRESS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)), Text(percent(weekly), style: const TextStyle(color: AppTheme.green, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 12), ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: weekly, minHeight: 9)),
        const SizedBox(height: 10), Text('${service.getWeekExercises(now)} exercises completed', style: const TextStyle(color: Colors.white60)),
      ]))),
      const SizedBox(height: 18), const Text('THIS WEEK', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: workoutDays.map((item) {
        final date = service.dateForWeekday(now, item.weekday), p = service.getDayProgress(date, item);
        return GestureDetector(onTap: () => openWorkout(context, service, date, item), child: Column(children: [
          CircleAvatar(radius: 21, backgroundColor: date.day == now.day && date.month == now.month ? AppTheme.green : AppTheme.surface,
            child: p.isComplete ? const Icon(Icons.check, color: Colors.black) : Text(item.name.substring(0, 1), style: TextStyle(color: date.day == now.day && date.month == now.month ? Colors.black : Colors.white))),
          const SizedBox(height: 5), Text(item.name.substring(0, 3), style: const TextStyle(fontSize: 11, color: Colors.white60)),
        ]));
      }).toList()),
    ]);
  }
}

class Schedule extends StatelessWidget {
  const Schedule({super.key, required this.service, required this.now});
  final ProgressService service; final DateTime now;
  @override Widget build(BuildContext context) => Page(title: 'Schedule', children: workoutDays.map((day) {
    final date = service.dateForWeekday(now, day.weekday), p = service.getDayProgress(date, day);
    final status = day.isRest ? 'Rest Day' : p.isComplete ? 'Completed' : p.completed > 0 ? 'In progress' : 'Not started';
    return Card(child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8), onTap: () => openWorkout(context, service, date, day),
      leading: CircleAvatar(backgroundColor: date.day == now.day && date.month == now.month ? AppTheme.green : AppTheme.border, child: Text('${day.weekday}', style: TextStyle(color: date.day == now.day && date.month == now.month ? Colors.black : Colors.white))),
      title: Text(day.name, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${day.focus}  •  ${day.exercises.length} exercises'),
      trailing: Text(status, style: TextStyle(color: day.isRest || p.isComplete ? AppTheme.green : Colors.white60, fontSize: 12))));
  }).toList());
}

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key, required this.service, required this.now});
  final ProgressService service; final DateTime now;
  @override Widget build(BuildContext context) {
    final weekly = service.getWeekProgress(now), history = service.getHistory(now);
    final historyCards = history.map<Widget>((item) => Card(child: ListTile(
      title: Text(service.weekLabel(item.weekStart)),
      subtitle: Text('${item.exercisesCompleted} exercises completed'),
      trailing: Text(percent(item.percentage), style: const TextStyle(color: AppTheme.green, fontWeight: FontWeight.bold)),
    ))).toList();
    return Page(title: 'Progress', children: [
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('YOUR WEEKLY PROGRESS', style: TextStyle(color: AppTheme.green, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 8),
        Text(percent(weekly), style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppTheme.green)), LinearProgressIndicator(value: weekly, minHeight: 10),
        const SizedBox(height: 14), Text('${service.getWeekExercises(now)} exercises completed'), Text('${service.getCompletedDays(now)}/6 workout days completed', style: const TextStyle(color: Colors.white60)),
      ]))),
      const SizedBox(height: 22), const Text('WEEK HISTORY', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold, letterSpacing: 1)), const SizedBox(height: 10),
      if (history.isEmpty)
        const Card(child: Padding(padding: EdgeInsets.all(24), child: Center(child: Text(
          'Your completed weeks will appear here.\nKeep showing up!',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.white60),
        ))))
      else
        ...historyCards,
    ]);
  }
}

class RestCard extends StatelessWidget {
  const RestCard({super.key});
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
    const Icon(Icons.spa_outlined, color: AppTheme.green, size: 34), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('REST DAY', style: TextStyle(color: AppTheme.green, fontWeight: FontWeight.bold)), SizedBox(height: 5), Text('Recover today and prepare for Monday.', style: TextStyle(color: Colors.white70))])),
  ])));
}

class Page extends StatelessWidget {
  const Page({super.key, this.title, required this.children, this.padding = false});
  final String? title; final List<Widget> children; final bool padding;
  @override Widget build(BuildContext context) => SafeArea(child: CustomScrollView(slivers: [
    if (title != null) SliverAppBar(title: Text(title!, style: const TextStyle(fontWeight: FontWeight.bold)), pinned: true),
    SliverPadding(padding: EdgeInsets.fromLTRB(padding ? 20 : 16, 20, padding ? 20 : 16, 28), sliver: SliverList(delegate: SliverChildListDelegate(children.expand((child) => [child, const SizedBox(height: 12)]).toList()))),
  ]));
}

void openWorkout(BuildContext context, ProgressService service, DateTime date, WorkoutDay day) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => day.isRest ? RestDay(date: date) : Checklist(service: service, date: date, day: day)));
}

class RestDay extends StatelessWidget {
  const RestDay({super.key, required this.date});
  final DateTime date;
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Rest Day')), body: Page(padding: true, children: [
    const SizedBox(height: 30), const Icon(Icons.self_improvement, color: AppTheme.green, size: 80), const Text('Recovery matters', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
    Text('Sunday, ${DateFormat('MMMM d').format(date)}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60)), const SizedBox(height: 12),
    const Text('Use today to recharge so you can return stronger next week.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white70)),
    const SizedBox(height: 15), const Card(child: Padding(padding: EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('RECOVERY TIPS', style: TextStyle(color: AppTheme.green, fontWeight: FontWeight.bold)), SizedBox(height: 14), Text('•  Hydrate throughout the day\\n\\n•  Do a gentle stretch\\n\\n•  Aim for 7–9 hours of sleep\\n\\n•  Prepare for Monday')]))),
  ]));
}

class Checklist extends StatelessWidget {
  const Checklist({super.key, required this.service, required this.date, required this.day});
  final ProgressService service; final DateTime date; final WorkoutDay day;
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(day.name)), body: AnimatedBuilder(animation: service, builder: (context, _) {
      final current = service.getDayProgress(date, day);
      return Page(padding: true, children: [
        Text(day.focus, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)), Text('${current.completed} of ${current.total} exercises completed', style: const TextStyle(color: Colors.white60)),
        const SizedBox(height: 8), LinearProgressIndicator(value: current.fraction, minHeight: 9),
        if (current.isComplete)
          const Card(child: Padding(padding: EdgeInsets.all(16), child: Row(children: [
            Icon(Icons.celebration, color: AppTheme.green),
            SizedBox(width: 12),
            Text('Workout complete!', style: TextStyle(color: AppTheme.green, fontWeight: FontWeight.bold)),
          ]))),
        ...day.exercises.map((exercise) => _ExerciseTile(service: service, date: date, exercise: exercise)),
      ]);
    }));
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({required this.service, required this.date, required this.exercise});
  final ProgressService service; final DateTime date; final Exercise exercise;
  @override Widget build(BuildContext context) => Card(child: ExpansionTile(
    leading: Checkbox(value: service.isCompleted(date, exercise.id), onChanged: (value) => service.setCompleted(date, exercise.id, value ?? false)),
    title: Text(exercise.name, style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: Text(exercise.measure, style: const TextStyle(color: AppTheme.green)),
    childrenPadding: const EdgeInsets.fromLTRB(72, 0, 18, 16), children: [Align(alignment: Alignment.centerLeft, child: Text(exercise.description, style: const TextStyle(color: Colors.white70)))],
  ));
}
