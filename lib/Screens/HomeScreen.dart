
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import '../Classes/TimeSlot.dart';
import '../Classes/TimeTable.dart';
import '../Globals/Providers.dart';
import '../Globals/enums.dart';
import '../Widgets/LinearFlowFAB.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Table_pr tableWatch = Provider.of<Table_pr>(context);

    return SafeArea(
      
      child: Container(
        
        decoration: Decorations.homeImage,
    
        child: Container(
          
          decoration: Decorations.homeVignette,
    
          child: Scaffold(
      
            backgroundColor: Colors.transparent,
          
            body: HomeBody(homeTable: tableWatch.tables[0]),
      
            floatingActionButton: const LinearFlowFAB(),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////

class HomeBody extends StatefulWidget {
  const HomeBody({
    Key? key,
    required this.homeTable
  }) : super(key: key);

  final TimeTable homeTable;

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  bool animate = false;

  @override
  void initState() {
    startAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final int currentDay = DateTime.now().weekday - 1;

    final TimeSlot currentSlot = widget.homeTable.currentSlot(currentDay) ?? TimeSlot.zero(-1,-1).copyWith(title: 'None');
    final TimeSlot nextSlot = widget.homeTable.nextSlot(currentDay) ?? TimeSlot.zero(-1,-1).copyWith(title: 'None');

    return Center(
      child: AnimatedOpacity(

        duration: Durations.d500,
        opacity: animate? 1: 0,

        child: AnimatedPadding(
      
          duration: Durations.d300,
          padding: EdgeInsets.only(
            top: animate? 0: 30
          ),
      
          child: Column(
        
            mainAxisAlignment: MainAxisAlignment.center,
        
            children: [
        
              Text(
                'Current: ${currentSlot.title}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 205, 238, 219),
                  fontSize: 32,
                  wordSpacing: 10,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                currentSlot.title == 'None'
                ? ''
                : '${currentSlot.startTime.toString().substring(10,15)} - ${currentSlot.endTime.toString().substring(10,15)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  wordSpacing: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
        
              Spaces.vertical40,
        
              Text(
                'Upcoming: ${nextSlot.title}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 205, 238, 219),
                  fontSize: 24,
                  letterSpacing: 0.7,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                nextSlot.title == 'None'
                ? ''
                : '${nextSlot.startTime.toString().substring(10,15)} - ${nextSlot.endTime.toString().substring(10,15)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> startAnimation() async {
    await Future.delayed(Durations.d300);
    setState(() {
      animate = true;
    });
  }
}