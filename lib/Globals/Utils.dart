
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Databases/ServicesPref.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Widgets/ErrorCard.dart';
import 'package:timetable_app/Widgets/Helpers.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../Classes/TimeSlot.dart';
import '../Classes/TimeTable.dart';
import '../Widgets/ClearTableCard.dart';
import '../Widgets/CreateAndEditTablePopUpCards.dart';
import '../Widgets/DeleteTableCard.dart';
import '../Widgets/TimeSlotDeleteCard.dart';
import 'Providers.dart';
import 'enums.dart';

typedef IndexedWidgetBuilder = Widget Function(BuildContext context, int index);

class Utils{

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  
  static double screenWidthPercentage(BuildContext context, double percentage){
    return MediaQuery.of(context).size.width * percentage;
  }
  static double screenHeightPercentage(BuildContext context, double percentage){
    return MediaQuery.of(context).size.height * percentage;
  }

  static PageRoute buildFadeThroughTransition(Widget page, Color fillColor) {
    return PageRouteBuilder(
      pageBuilder: ((context, animation, secondaryAnimation) => 
        page
      ),
      transitionDuration: Durations.d500,
      transitionsBuilder: ((context, animation, secondaryAnimation, child) =>
       FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          fillColor: fillColor,
          child: child,
        )
      )
    );
  }

  static void showSnackBar(BuildContext context, String content, {backgroundColor = Colors.greenAccent}){
    final color = Provider.of<Color_pr>(context, listen: false).onBackground;
    showTopSnackBar(
      context,
      CustomSnackBar.info(
        message: content,
        backgroundColor: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        iconPositionTop: -30,
        textStyle: TextStyles.b2(color),
        icon: const Icon(Icons.menu, size: 260, color: Colors.black12,),
      ),
      displayDuration: Durations.d2000,
      animationDuration: Durations.d1000,
      curve: Curves.elasticOut,
      reverseAnimationDuration: Durations.d300,
      reverseCurve: Curves.easeInQuint,
    );
  }

  static Future<void> showSlideDialog(BuildContext context, Widget child, {barrierDismissible = true}) {

    return showGeneralDialog(
      context: context, 
      barrierLabel: '',

      barrierColor: Prefs.isDarkMode? const Color.fromRGBO(23, 41, 58, 0.75): Colors.grey.withOpacity(0.75),
      barrierDismissible: barrierDismissible,
      transitionDuration: Durations.d500,
      pageBuilder: ((context, animation, secondaryAnimation) =>
        Container()
      ),
      transitionBuilder: ((context, animation, secondaryAnimation, _) {
        
        const curve = Curves.easeOutQuint;

        final scaleTween = Tween(begin: 0.0, end: 1.0); //
        final curvedScaleAnimation = CurvedAnimation( //
          parent: animation,
          curve: curve,
        );
        final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: Transform.scale(
            scale: scaleTween.animate(curvedScaleAnimation).value,
            child: child
          ),
        );
      })
    );
  }
  
  static void showDeleteDialog(context, TimeSlot timeSlot) =>
    showSlideDialog(context, TimeSlotDeleteCard(timeSlot: timeSlot)); 

  static void showErrorDialog(context, String content) => 
  showSlideDialog(context, ErrorCard(content: content));

  static void showCreateTableDialog(BuildContext context) => 
    showSlideDialog(context, const CreateTableCard(),);
  
  static void showEditTableDialog(BuildContext context) => 
    showSlideDialog(context, const EditTableCard(),);

  static void showDeleteTableDialog(BuildContext context, TimeTable timeTable) => 
    showSlideDialog(context, DeleteTableCard(timeTable: timeTable));

  static void showClearTableDialog(BuildContext context, TimeTable timeTable) => 
    showSlideDialog(context, ClearTableCard(timeTable: timeTable));

  static void showTimePicker(BuildContext context, TimeOfDay timeOfDay) =>
    showSlideDialog(context, const TimePicker());


  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}


List<InlineSpan> appBarHeader(String firstLetter, String restOfWord) => [
    TextSpan(
      text: firstLetter, 
      style: const TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w500,
        color: Colors.white
      ),
    ),
    TextSpan(
      text: restOfWord,
      style: const TextStyle(
        fontSize: 40,
        color: Colors.white70,
        fontWeight: FontWeight.bold
      )
    ),
  ];