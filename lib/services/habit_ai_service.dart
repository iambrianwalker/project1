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

    //Early Momentum
    if (analysis.streak > 0) {
      return "You're building momentum. Keep it going!";
    }

    return "Start small. Just show up today.";
  }

  String generateMicroGoal(Habit habit, HabitAnalysis analysis) {
    if (analysis.daysSinceLast > 1) {
      return "Do a minimal version of '${habit.habitName}' today.";
    }

    if (analysis.streak >= 5) {
      return "Push slightly beyond your normal effort.";
    }

    return "Complete '${habit.habitName}' today."; 
  }
}

extension HabitAIPriority on HabitAIService{
  int calculatePriority(HabitAnalysis analysis) {
    if (analysis.daysSinceLast > 2) return 100; //struggling
    if (!analysis.isActive) return 90; // inactive
    if (analysis.streak >= 7) return 70; //strong streak
    if (analysis.streak > 0) return 50; //early momentum
    return 30; //new habit or no streak
  }
}