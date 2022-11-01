
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/Reminder.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
import 'package:timetable_app/Databases/ServicesPref.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';
import 'package:timetable_app/Globals/Reals.dart';
import 'package:timetable_app/Screens/ProfileScreen.dart';
import 'package:timetable_app/Screens/RemindersScreen.dart';
import 'Classes/TimeTable.dart';
import 'package:timetable_app/Globals/Providers.dart';

import 'Globals/enums.dart';
import 'Screens/OnboardingScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/TablesScreen.dart';



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
        ChangeNotifierProvider(create: (_) => NewReminder_pr()),
        ChangeNotifierProvider(create: (_) => NewSlot_pr()),
        ChangeNotifierProvider(create: (_) => Color_pr(
          background: Prefs.isDarkMode? backgroundDarkC: backgroundC, 
          onBackground: Prefs.isDarkMode? onBackgroundDarkC: onBackgroundC, 
          foreground: Prefs.isDarkMode? foregroundDarkC: foregroundC, 
          shadow: Prefs.isDarkMode? shadowDarkC: shadowC,
          shadow_alt: Prefs.isDarkMode? shadow_altDarkC: shadow_altC, 
          splash: Prefs.isDarkMode? splashDarkC: splashC,
        )),
      ],
      child: const App(),
    )
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    final Screen_pr screenWatch = context.watch<Screen_pr>();
    final Table_pr tableWatch = context.watch<Table_pr>();

    Widget currentScreen = screenWatch.currentScreen == Screens.home
      ? tableWatch.tables.isEmpty ? const OnboardingScreen()
      : const HomeScreen() : screenWatch.currentScreen == Screens.mytables
      ? const TablesScreen() : screenWatch.currentScreen == Screens.reminders
      ? const RemindersScreen() : const ProfileScreen();

    var pageTransitionSwitcher = PageTransitionSwitcher(
        duration: Durations.d500,
        reverse: screenWatch.currentScreen == Screens.home,
        transitionBuilder: ((child, animation, secondaryAnimation) => 
          FadeScaleTransition(
            animation: animation,
            child: child,
          )
        ),
        child: currentScreen,
      );

    return MaterialApp(

      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.grey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: colorWatch.onBackground,
            fixedSize: const Size.fromWidth(100),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shadowColor: colorWatch.shadow_alt,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
            ),
          )
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colorWatch.foreground, width: 0.5),
            foregroundColor: colorWatch.foreground
          )
        )
      ),
  
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
  Reminder.sortAll(reminders);

  currentTableIndex = Prefs.homeTable;
}