
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/NotificationApi.dart';
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

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {  
    super.initState();

    NotificationApi.init(true);
    listenNotifications();
  }

  void listenNotifications() =>
    NotificationApi.onNotofication.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) =>
    context.read<Screen_pr>().setScreen(Screens.mytables);

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

      theme: themeData(colorWatch),
  
      debugShowCheckedModeBanner: false,
  
      home: pageTransitionSwitcher,
    );
  }
}

Future<void> _initApp() async {
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: ([]));
  
  await initPreferences();

  await initLocalData();
}
  

Future<void> initPreferences() async {
  await Prefs.init();
  currentTableIndex = Prefs.homeTable;
}

Future<void> initLocalData() async {
  timeTables = await LocalDatabase.instance.readAllTimeTables();
  TimeTable.sortAll(timeTables);

  reminders = await LocalDatabase.instance.readAllReminders();
  Reminder.sortAll(reminders);

  await removeUotdatedReminders();
}

Future<void> removeUotdatedReminders() async {
  while(reminders.isNotEmpty && DateTime.now().isAfter(reminders[0].dateTime)){
    await LocalDatabase.instance.deleteReminder(reminders[0].id!);
    reminders.removeAt(0);
  }
}