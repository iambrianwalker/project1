import 'package:flutter/cupertino.dart';

class HabitsScreen extends StatefulWidget{
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen>{
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Habits'),
    );
  }
}