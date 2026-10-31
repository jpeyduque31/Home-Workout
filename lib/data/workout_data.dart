import '../models/workout.dart';

const workoutDays = <WorkoutDay>[
  WorkoutDay(weekday: 1, name: 'Monday', focus: 'Upper Body', exercises: [
    Exercise(id: 'mon_pushups', name: 'Push-ups', description: 'Keep your body straight and lower your chest with control.', sets: 3, reps: 10),
    Exercise(id: 'mon_diamond', name: 'Diamond Push-ups', description: 'Place your hands close together beneath your chest and press up.', sets: 2, reps: 8),
    Exercise(id: 'mon_dips', name: 'Tricep Dips', description: 'Use a sturdy chair, keeping your elbows pointing behind you.', sets: 3, reps: 10),
    Exercise(id: 'mon_pike', name: 'Pike Push-ups', description: 'Lift your hips high and bend your elbows to lower your head.', sets: 2, reps: 8),
    Exercise(id: 'mon_circles', name: 'Arm Circles', description: 'Make smooth, controlled circles with both arms extended.', sets: 2, durationSeconds: 30),
  ]),
  WorkoutDay(weekday: 2, name: 'Tuesday', focus: 'Core & Abs', exercises: [
    Exercise(id: 'tue_crunches', name: 'Crunches', description: 'Lift your shoulders gently while keeping your lower back grounded.', sets: 2, reps: 12),
    Exercise(id: 'tue_raises', name: 'Leg Raises', description: 'Raise straight legs slowly and avoid arching your lower back.', sets: 2, reps: 10),
    Exercise(id: 'tue_bicycle', name: 'Bicycle Crunches', description: 'Rotate your torso and bring each elbow toward the opposite knee.', sets: 2, reps: 12),
    Exercise(id: 'tue_plank', name: 'Plank', description: 'Brace your core and hold a straight line from shoulders to heels.', sets: 2, durationSeconds: 20),
  ]),
  WorkoutDay(weekday: 3, name: 'Wednesday', focus: 'Lower Body', exercises: [
    Exercise(id: 'wed_squats', name: 'Bodyweight Squats', description: 'Sit your hips back, keep your chest tall, then stand through your feet.', sets: 3, reps: 15),
    Exercise(id: 'wed_lunges', name: 'Lunges', description: 'Step forward and lower both knees, keeping the front knee over your ankle.', sets: 3, reps: 10),
    Exercise(id: 'wed_bridges', name: 'Glute Bridges', description: 'Press through your heels and squeeze your glutes at the top.', sets: 3, reps: 12),
    Exercise(id: 'wed_calves', name: 'Calf Raises', description: 'Rise onto the balls of your feet, then lower slowly.', sets: 3, reps: 15),
    Exercise(id: 'wed_wall', name: 'Wall Sit', description: 'Slide down a wall until your thighs are comfortable and parallel.', sets: 2, durationSeconds: 30),
  ]),
  WorkoutDay(weekday: 4, name: 'Thursday', focus: 'Recovery', exercises: [
    Exercise(id: 'thu_neck', name: 'Neck Rolls', description: 'Move your head in a slow, gentle circle without forcing the range.', sets: 2, durationSeconds: 30),
    Exercise(id: 'thu_shoulder', name: 'Shoulder Stretch', description: 'Draw one arm across your chest and hold it gently.', sets: 2, durationSeconds: 30),
    Exercise(id: 'thu_catcow', name: 'Cat-Cow Stretch', description: 'Alternate rounding and lengthening your spine with your breathing.', sets: 2, reps: 10),
    Exercise(id: 'thu_child', name: "Child's Pose", description: 'Sit your hips toward your heels and reach your arms forward.', sets: 2, durationSeconds: 30),
    Exercise(id: 'thu_hamstring', name: 'Hamstring Stretch', description: 'Extend one leg and hinge forward with a relaxed back.', sets: 2, durationSeconds: 30),
  ]),
  WorkoutDay(weekday: 5, name: 'Friday', focus: 'Full Body', exercises: [
    Exercise(id: 'fri_jacks', name: 'Jumping Jacks', description: 'Jump your feet out as your arms rise, then return smoothly.', sets: 3, reps: 20),
    Exercise(id: 'fri_squats', name: 'Squats', description: 'Lower your hips with control and keep your knees tracking over your toes.', sets: 3, reps: 12),
    Exercise(id: 'fri_pushups', name: 'Push-ups', description: 'Keep your body straight and lower your chest with control.', sets: 3, reps: 10),
    Exercise(id: 'fri_mountain', name: 'Mountain Climbers', description: 'From a plank, alternate driving each knee toward your chest.', sets: 3, durationSeconds: 20),
    Exercise(id: 'fri_plank', name: 'Plank', description: 'Brace your core and hold a straight line from shoulders to heels.', sets: 2, durationSeconds: 30),
  ]),
  WorkoutDay(weekday: 6, name: 'Saturday', focus: 'Core & Cardio', exercises: [
    Exercise(id: 'sat_highknees', name: 'High Knees', description: 'Alternate lifting your knees while staying light and tall.', sets: 3, durationSeconds: 30),
    Exercise(id: 'sat_twists', name: 'Russian Twists', description: 'Lean back slightly and rotate your ribcage from side to side.', sets: 3, reps: 16),
    Exercise(id: 'sat_flutter', name: 'Flutter Kicks', description: 'With legs extended, make small alternating kicks from your hips.', sets: 3, reps: 20),
    Exercise(id: 'sat_burpees', name: 'Burpees', description: 'Squat, step or jump to plank, return, and stand tall.', sets: 3, reps: 8),
    Exercise(id: 'sat_rope', name: 'Jump Rope (no rope)', description: 'Make small, soft jumps while turning imaginary rope handles.', sets: 3, durationSeconds: 30),
  ]),
  WorkoutDay(weekday: 7, name: 'Sunday', focus: 'Rest Day', exercises: [], isRest: true),
];

const motivation = <int, String>{
  1: 'Start your week strong!', 2: 'Every rep brings you closer to your goal.',
  3: 'Consistency beats perfection.', 4: 'Recovery is part of progress.',
  5: 'Finish the week stronger!', 6: 'Keep showing up!', 7: 'Rest, recover, and prepare.',
};

WorkoutDay workoutFor(int weekday) => workoutDays[weekday - 1];
