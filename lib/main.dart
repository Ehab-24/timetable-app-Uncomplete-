
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
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

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //TODO: await ServicesPref.init();

  await _initApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Table_pr(timeTables)),
        ChangeNotifierProvider(create: (_) => Screen_pr()),
        ChangeNotifierProvider(create: (_) => Day_pr(DateTime.now().weekday - 1)),
      ],
      child: const App(),
    )
  );
}

Future<void> _initApp() async {
  timeTables = await LocalDatabase.instance.readAllTimeTables();
  TimeTable.sortAll(timeTables);
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    ThemeData themeData = ThemeData(
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.grey),
          crossAxisMargin: 4
        ), 
        colorScheme: ColorScheme.fromSwatch().copyWith(
          onPrimary: Colors.grey.shade200,
          primary: Colors.grey.shade900,
          secondary: Colors.white
          // secondary: Colors.blueGrey.shade800
        ),
      );

    final Screen_pr screenWatch = context.watch<Screen_pr>();
    final Table_pr tableWatch = context.watch<Table_pr>();

    return MaterialApp(
  
      theme: themeData,
  
      debugShowCheckedModeBanner: false,
  
      home: PageTransitionSwitcher(
        
        duration: screenWatch.currentScreen == Screens.home
        ? Durations.d1000
        : Durations.d500,
        reverse: screenWatch.currentScreen == Screens.home,
        transitionBuilder: ((child, animation, secondaryAnimation) => 
        
          SharedAxisTransition(
            animation: animation, 
            secondaryAnimation: secondaryAnimation,
            fillColor: screenWatch.currentScreen == Screens.home
            ? Colors.green.shade800
            : Colors.blueGrey.shade900,
            transitionType: SharedAxisTransitionType.vertical,
            child: child,
          )
        ),
        
        child: screenWatch.currentScreen == Screens.home
        ? tableWatch.tables.isEmpty ? const CreateFirstTableScreen()
        : const HomeScreen() : screenWatch.currentScreen == Screens.mytables
        ? const TablesScreen() : const ScheduleScreen()
      ),
    );
  }
}