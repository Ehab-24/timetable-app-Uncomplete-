
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/Reminder.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
import 'package:timetable_app/Databases/ServicesPref.dart';
import 'package:timetable_app/Globals/Reals.dart';
import 'package:timetable_app/Screens/RemindersScreen.dart';
import 'Classes/TimeTable.dart';
import 'package:timetable_app/Globals/Providers.dart';

import 'Globals/enums.dart';
import 'Screens/CreateFirstTableScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/ScheduleScreen.dart';
import 'Screens/TablesScreen.dart';

/*
  Provider and Database managment go hand to hand.
  In many functions, they are modified simultaneoulsy
  however, Provider DOES NOT handle the Database.
*/

late List<TimeTable> timeTables;
late List<Reminder> reminders;

Future main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await _initApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Table_pr(timeTables)),
        ChangeNotifierProvider(create: (_) => Screen_pr()),
        ChangeNotifierProvider(create: (_) => Reminder_pr(reminders)),
        ChangeNotifierProvider(create: (_) => Day_pr(DateTime.now().weekday - 1)),
        ChangeNotifierProvider(create: (_) => Ticker_pr()),
      ],
      child: const App(),
    )
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Screen_pr screenWatch = context.watch<Screen_pr>();
    final Table_pr tableWatch = context.watch<Table_pr>();

    Widget currentScreen = screenWatch.currentScreen == Screens.home
      ? tableWatch.tables.isEmpty ? const CreateFirstTableScreen()
      : const HomeScreen() : screenWatch.currentScreen == Screens.mytables
      ? const TablesScreen() : screenWatch.currentScreen == Screens.reminders
      ? const RemindersScreen() : const ScheduleScreen();

    var pageTransitionSwitcher = PageTransitionSwitcher(
        
        duration: Durations.d500,
        reverse: screenWatch.currentScreen == Screens.home,
        transitionBuilder: ((child, animation, secondaryAnimation) => 
        
          SharedAxisTransition(
            animation: animation, 
            secondaryAnimation: secondaryAnimation,
            fillColor: Colors.blueGrey.shade900,
            transitionType: SharedAxisTransitionType.vertical,
            child: child,
          )
        ),

        child: currentScreen,
      );

    return MaterialApp(
  
      theme: themeData,
  
      debugShowCheckedModeBanner: false,
  
      home: pageTransitionSwitcher,
    );
  }
}

Future<void> _initApp() async {

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: ([]));
  
  await Prefs.init();

  timeTables = await LocalDatabase.instance.readAllTimeTables();
  TimeTable.sortAll(timeTables);

  reminders = await LocalDatabase.instance.readAllReminders();
}