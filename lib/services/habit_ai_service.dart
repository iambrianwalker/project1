import '../models/habit_model.dart';
import 'habit_analyzer.dart';

class HabitAIService{
  String generateMessage(Habit habit, HabitAnalysis analysis) {
    //User is struggling
    if (analysis.daysSinceLast > 2) {
      return "You've been off track. Let's reset today.";
    }

    //Strong Streak
    if (analysis.streak >= 7) {
      return "${analysis.streak}-day streak. You're locked in!";
    }

    //Inactive Habit
    if (!analysis.isActive) {
      return "This habit is fading. Bring it back today!";
    }
  }
}