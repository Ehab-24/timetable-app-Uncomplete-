
import 'package:flutter/material.dart';
import 'package:timetable_app/Widgets/ErrorCard.dart';
import '../Classes/TimeSlot.dart';
import '../Classes/TimeTable.dart';
import '../Widgets/CreateTablePopUpCard.dart';
import '../Widgets/DeleteTableCard.dart';
import '../Widgets/TimeSlotDeleteCard.dart';
import '../Widgets/TimeSlotPopUpCard.dart';

typedef IndexedWidgetBuilder = Widget Function(BuildContext context, int index);

class Utils{

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
  
  static void showEditDialog(context, TimeSlot timeSlot, {required Color color, bool isfirst = false}) => showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    barrierDismissible: false,
    builder: (_) =>
      TimeSlotPopUpCard(timeSlot: timeSlot, color: color, isfirst: isfirst)
    );

  static void showDeleteDialog(context, TimeSlot timeSlot) => showDialog(
    context: context, 
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (_) =>
      TimeSlotDeleteCard(timeSlot: timeSlot),
  );

  static void showErrorDialog(context, String content) => showDialog(
    context: context,
    builder: (_) =>
      ErrorCard(content: content),
  );

  static double screenWidthPercentage(BuildContext context, double percentage){
    return MediaQuery.of(context).size.width * percentage;
  }
  static double screenHeightPercentage(BuildContext context, double percentage){
    return MediaQuery.of(context).size.height * percentage;
  }

  static void showCreateTableDialog(BuildContext context) => showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    barrierDismissible: false,
    builder: (_) =>
      const CreateTableCard()
  );

  static void showDeleteTableDialog(BuildContext context, TimeTable timeTable) => showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (_) =>
      DeleteTableCard(timeTable: timeTable),
  );

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