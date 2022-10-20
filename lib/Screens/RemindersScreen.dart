
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';
import 'package:timetable_app/Widgets/LinearFlowFAB.dart';

import '../Classes/Reminder.dart';
import '../Globals/Providers.dart';
import '../Widgets/ReminderTile.dart';

class RemindersScreen extends StatelessWidget{
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final Reminder_pr remWatch = context.watch<Reminder_pr>();

    final double h = Utils.screenHeightPercentage(context, 1);
    final double w = Utils.screenWidthPercentage(context, 1);

    return SafeArea(
      child: Scaffold(
        
        backgroundColor: Colors.grey.shade200,
    
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: h * 0.1,
                bottom: h * 0.02
              ),
              color: Colors.grey.shade200,
              child: const ReminderHeader(),
            ),
            remWatch.reminders.isEmpty
            ? const Text(
                'No Current Reminders',
                style: TextStyle(
                  fontSize: 50,
                  color: Color.fromRGBO(55, 71, 79, 1),
                  fontWeight: FontWeight.bold
                ),
              )
            : Expanded(
                child: ListView.builder(  
                  physics: const BouncingScrollPhysics(),
                  itemCount: remWatch.reminders.length + 2,
                  itemBuilder: ((context, index) =>
                  index == 0
                  ? Spaces.vertical60
                  : index == remWatch.reminders.length + 1
                  ? Spaces.vertical60
                  : Padding(
                      padding: EdgeInsets.only(bottom: h * 0.02),
                      child: ReminderTile(reminder: remWatch.reminders[index - 1]),
                    )     
                  ),
              ),
            ),
          ],
        ),
    
        floatingActionButton: const LinearFlowFAB(),
      ),
    );
  }
}

class ReminderHeader extends StatelessWidget {
  const ReminderHeader({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final double h = Utils.screenHeightPercentage(context, 1);
    final double w = Utils.screenWidthPercentage(context, 1);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [

        Positioned(
          top: h * -0.09,
          left: -w * 0.02,
          child: Transform.rotate(
            angle: 10,
            child: Icon(
              Icons.timelapse_sharp, 
              size: w * 0.35, 
              color: const Color.fromRGBO(114, 114, 114, 0.4),
            ),
          ),
        ),
      
        Container(

          width: w * 0.764 + 24,
          height: h * 0.352 + 20,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.pink.shade300, Colors.pink.shade400],
              center: Alignment.topLeft,
              radius: 2
            ),
            borderRadius: BorderRadius.circular(w * 0.09),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                color: Colors.black54
              )
            ]
          ),
        ),

        Column(
          children: [
            Container(
              
              width: w * 0.764,
              height: h * 0.24,
              alignment: Alignment.center,
    
              decoration: BoxDecoration(
                gradient: Gradients.reminderHeaderForeground,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black87
                  )
                ],
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(w * 0.146),
                  bottom: const Radius.circular(8),
                ),
              ),
    
              child: const CoinyText(
                text: "Reminders",
              ),
            ),

            Spaces.vertical(h * 0.012),

            Container(

              width: w * 0.764,
              height: h * 0.09,
              clipBehavior: Clip.hardEdge,

              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.amber.shade300, Colors.yellow.shade900],
                  radius: 4,
                  focal: Alignment.center,
                  focalRadius: 0.4
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black87
                  )
                ],
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(w * 0.146),
                  top: const Radius.circular(8),
                )
              ),
              child: Material(
                type: MaterialType.transparency,
                child: IconButton(
                  icon: Icon(Icons.add_alarm_rounded, size: h * 0.06,),
                  splashRadius: w,
                  onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: ((context) =>
                          const CreateReminderScreen() 
                        ) 
                      )
                    );
                  },
                ),
              ),
            )
          ],
        ),

        Positioned(
          top: -w * 0.15,
          child: Container(
            width: w * 0.3,
            height: w * 0.3,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(w * 0.15),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black26
                )
              ],
              color: Colors.pink.shade400
            ),
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.amber.shade300, Colors.yellow.shade500],
                    center: Alignment.topLeft,
                    radius: 1.5
                  ),
                  borderRadius: BorderRadius.circular(w * 0.15),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black87,
                    )
                  ]
                ),
                child: Icon(Icons.notifications_active_rounded, size: w * 0.1, color: Colors.blueGrey.shade800,),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

class CoinyText extends StatelessWidget {
  const CoinyText({
    Key? key,
    required this.text,
    this.strokeColor = const Color.fromRGBO(55, 71, 79, 1),
    this.fillColor = Colors.white
  }) : super(key: key);

  final String text;
  final Color fillColor,
              strokeColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Text(
          text,
          style: TextStyle(
            letterSpacing: 1.2,
            fontFamily: 'Coiny',
            fontWeight: FontWeight.w400,
            fontSize: 40,
            foreground: Paint()
            ..style = PaintingStyle.stroke
            ..color = strokeColor
            ..strokeWidth = 4,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            letterSpacing: 1.2,
            color: fillColor.withOpacity(0.7),
            fontFamily: 'Coiny',
            fontWeight: FontWeight.w400,
            fontSize: 40,
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////

class CreateReminderScreen extends StatefulWidget{
  const CreateReminderScreen({super.key});

  @override
  State<CreateReminderScreen> createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends State<CreateReminderScreen> {

  late final Reminder_pr remReader;
  final Reminder reminder = Reminder.zero;

  @override
  void initState() {
    remReader = context.read<Reminder_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(),

      body: Padding(
        
        padding: const EdgeInsets.symmetric(horizontal: 20),
    
        child: Column(
        
          crossAxisAlignment: CrossAxisAlignment.stretch,
        
          children: [
  
            const Spacer(),

            ElevatedButton(
              onPressed: () async {

                Reminder newRem = await LocalDatabase.instance.addReminder(reminder);
                //Add the new Reminder (with id) to provider.
                remReader.add(newRem);

                if(mounted) {
                  Navigator.of(context).pop();
                }
              }, 
              child: const Icon(Icons.save)
            ),

            ElevatedButton(
              onPressed: () async {
                
                var dateTime = await showDatePicker(
                  context: context, 
                  initialDate: DateTime.now(), 
                  firstDate: DateTime(DateTime.now().year - 5), 
                  lastDate: DateTime(DateTime.now().year + 5),
                );

                if (dateTime == null){
                  return;
                }
                setState(() {
                  reminder.dateTime = dateTime;
                });
              },
              child: const Icon(Icons.date_range)
            ),

            const Spacer(),

            ReminderTile(reminder: reminder),

            const Spacer(),
            
            TextField(
              onChanged: (value) => setState(() {
                reminder.title = value;
              }),
              decoration: Decorations.textFormField('Title', Colors.purple)
            ),
            
            Spaces.vertical40,
                          
            TextField(
              onChanged: (value) => reminder.description = value,
              decoration: Decorations.textFormField('Description', Colors.purple)
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}