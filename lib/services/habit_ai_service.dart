import '../models/habit_model.dart';
import 'habit_analyzer.dart';

class HabitAIService{
  String generateMessage(Habit habit, HabitAnalysis analysis) {
    //User is struggling
    if (analysis.daysSinceLast > 2) {
      return "You've been off track. Let's reset today.";
    }
  }
}