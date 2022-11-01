
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:timetable_app/Widgets/ErrorCard.dart';
import '../Classes/TimeSlot.dart';
import '../Classes/TimeTable.dart';
import '../Widgets/ClearTableCard.dart';
import '../Widgets/CreateAndEditTablePopUpCards.dart';
import '../Widgets/DeleteTableCard.dart';
import '../Widgets/TimeSlotDeleteCard.dart';
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

  static void showSnackBar(BuildContext context, String content, {int seconds = 3}){
    ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
      
      duration: Duration(seconds: seconds),
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.white
        ),
      ), 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20)
        ),
      ),
    ));
  }

  static Future<void> showSlideDialog(BuildContext context, Widget child, {barrierDismissible = true}) {
    return showGeneralDialog(
      context: context, 
      barrierLabel: '',

      //TODO: Prefs.isDarkMode? lightpink: ...
      barrierColor: darken(Colors.pink).withOpacity(0.9),
      barrierDismissible: barrierDismissible,
      transitionDuration: Durations.d500,
      pageBuilder: ((context, animation, secondaryAnimation) =>
        Container()
      ),
      transitionBuilder: ((context, animation, secondaryAnimation, _) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutQuint;

        final scaleTween = Tween(begin: 0.0, end: 1.0); //
        final curvedScaleAnimation = CurvedAnimation( //
          parent: animation,
          curve: curve,
        );
        final tween = Tween(begin: begin, end: end);
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
          // child: Opacity(
          //   opacity: animation.value,
          //   child: child,
          // ),
        );
      })
    );
  }
  
  // static void showEditDialog(context, TimeSlot timeSlot, {required Color color, bool isfirst = false}) => 
  //   showSlideDialog(context, TimeSlotPopUpCard(timeSlot: timeSlot, isfirst: isfirst, color: color));
  // showDialog(
  //   context: context,
  //   barrierColor: Colors.black.withOpacity(0.8),
  //   barrierDismissible: false,
  //   builder: (_) =>
  //     TimeSlotPopUpCard(timeSlot: timeSlot, color: color, isfirst: isfirst)
  //   );

  static void showDeleteDialog(context, TimeSlot timeSlot) =>
    showSlideDialog(context, TimeSlotDeleteCard(timeSlot: timeSlot)); 
  // showDialog(
  //   context: context, 
  //   barrierColor: Colors.black.withOpacity(0.8),
  //   builder: (_) =>
  //     TimeSlotDeleteCard(timeSlot: timeSlot),
  // );

  static void showErrorDialog(context, String content) => 
  showDialog(
    context: context,
    builder: (_) =>
      ErrorCard(content: content),
  );
  // showSlideDialog(context, ErrorCard(content: content));

  static void showCreateTableDialog(BuildContext context) => 
    showSlideDialog(context, const CreateTableCard(),);
  // showDialog(
  //   context: context,
  //   barrierColor: Colors.black.withOpacity(0.8),
  //   barrierDismissible: false,
  //   builder: (_) =>
  //     const CreateTableCard()
  // );
  
  static void showEditTableDialog(BuildContext context) => 
    showSlideDialog(context, const EditTableCard(),);
  // showDialog(
  //   context: context,
  //   barrierColor: Colors.black.withOpacity(0.8),
  //   barrierDismissible: false,
  //   builder: (_) =>
  //     const EditTableCard()
  // );

  static void showDeleteTableDialog(BuildContext context, TimeTable timeTable) => 
    showSlideDialog(context, DeleteTableCard(timeTable: timeTable));
  // showDialog(
  //   context: context,
  //   barrierColor: Colors.black.withOpacity(0.8),
  //   builder: (_) =>
  //     DeleteTableCard(timeTable: timeTable),
  // );
  static void showClearTableDialog(BuildContext context, TimeTable timeTable) => 
    showSlideDialog(context, ClearTableCard(timeTable: timeTable));
  // showDialog(
  //   context: context,
  //   barrierColor: Colors.black.withOpacity(0.8),
  //   builder: (_) =>
  //     ClearTableCard(timeTable: timeTable),
  // );

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