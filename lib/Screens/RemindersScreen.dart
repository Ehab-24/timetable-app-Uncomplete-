
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';
import 'package:timetable_app/Widgets/LinearFlowFAB.dart';

import '../Classes/Reminder.dart';
import '../Globals/Providers.dart';

class RemindersScreen extends StatelessWidget{
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      
      backgroundColor: Colors.grey.shade200,

      body: AspectRatio(
        aspectRatio: 9/16,
        child: ElevatedButton(
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: ((context) => const CreateReminderScreen()))
            );
          },
          child: const Icon(Icons.add, size: 50),
        ),
      ),

      floatingActionButton: const LinearFlowFAB(),
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

    final Reminder_pr remWatch = context.watch<Reminder_pr>();

    final double h = Utils.screenHeightPercentage(context, 1);
    final double w = Utils.screenWidthPercentage(context, 1);

    return Scaffold(

      appBar: AppBar(),

      body: Padding(
        
        padding: const EdgeInsets.symmetric(horizontal: 20),
    
        child: Column(
        
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        
          children: [
    
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
            Card(
              color: Colors.white,
              elevation: 8,
              child: Column(
                children: [
                  Text(
                    reminder.title,
                    style: TextStyles.h1,
                  ),
                  Text(
                    reminder.dateTime.toIso8601String(),
                    style: TextStyles.b1,
                  )
                ],
              ),
            ),
            
            ElevatedButton(
              onPressed: (){

                showDialog(
                  context: context, 
                  builder: ((context) => 
                    Dialog(
                      
                      child: SingleChildScrollView(

                        padding: EdgeInsets.symmetric(vertical: h * 0.1, horizontal: w * 0.1),

                        child: Column(
                          children: [
                            TextField(
                              onChanged: (value) => reminder.title = value,
                              decoration: Decorations.textFormField('Title', Colors.purple)
                            ),
                            
                            Spaces.vertical40,
                                          
                            TextField(
                              onChanged: (value) => reminder.title = value,
                              decoration: Decorations.textFormField('Description', Colors.purple)
                            ),

                            Spaces.vertical40,

                            ElevatedButton(
                              onPressed: (){
                                remReader.add(reminder);
                              }, 
                              child: const Icon(Icons.save)
                            )
                          ],
                        ),
                      ),
                    )
                  )
                );
              }, 
              child: const Icon(Icons.description)
            )
          ],
        ),
      ),
    );
  }
}