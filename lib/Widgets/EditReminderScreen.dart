
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';

import '../Classes/Reminder.dart';
import '../Databases/LocalDatabase.dart';
import '../Globals/Decorations.dart';
import '../Globals/Providers.dart';
import '../Globals/enums.dart';


class EditReminderScreen extends StatefulWidget{
  const EditReminderScreen({
    super.key,
    required this.reminder,
    this.isFirst = false,
  });

  final Reminder reminder;
  final bool isFirst;

  @override
  State<EditReminderScreen> createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {

  late final Reminder_pr remReader;

  @override
  void initState() {
    remReader = context.read<Reminder_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final h = Utils.screenHeightPercentage(context, 1);
    final w = Utils.screenWidthPercentage(context, 1);

    return Scaffold(

      // appBar: AppBar(),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 30, right: w - 95),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          tooltip: 'back',
          child: const Icon(Icons.arrow_back_ios_new, color: Color.fromRGBO(55, 71, 79, 1),),
        ),
      ),

      body: Scrollbar(
        child: SingleChildScrollView(
          
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
      
          child: Column(
          
            crossAxisAlignment: CrossAxisAlignment.stretch,
          
            children: [

              Spaces.vertical(h/10),

              ElevatedButton(
                onPressed: () async {
        
                  if(widget.isFirst){
                    Reminder newRem = await LocalDatabase.instance.addReminder(widget.reminder);
                    //Add the new Reminder (with id) to provider.
                    remReader.add(newRem);
                  }
                  else{
                    //Update in databse amd provider.
                    await LocalDatabase.instance.updateReminder(widget.reminder);
                    remReader.update(widget.reminder);
                    //Remove the outDated reminder from provider.
                    // remReader.remove(widget.reminder);
                    // widget.reminder.id = widget.reminder.id;
                    
                    //Add the updated reminder.
                    // remReader.add(widget.reminder);
                  }
        
                  if(mounted) {
                    Navigator.of(context).pop();
                  }
                }, 
                child: const Icon(Icons.save)
              ),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        widget.reminder.dateTime = dateTime;
                      });
                    },
                    child: const Icon(Icons.date_range)
                  ),
                  
                  ElevatedButton(
                    onPressed: () async {
                      DateTime dt = widget.reminder.dateTime;
                      
                      TimeOfDay? timeOfDay = await showTimePicker(
                        context: context, 
                        initialTime: TimeOfDay(hour: dt.hour, minute: dt.minute)
                      );

                      if(timeOfDay == null){
                        return;
                      }
                      setState(() {
                        widget.reminder.dateTime = DateTime(dt.year, dt.month, dt.day, timeOfDay.hour, timeOfDay.minute);
                      });
                    }, 
                    child: const Icon(Icons.alarm)
                  ),

                ],
              ),
          
              Spaces.vertical(h/10),
        
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2, color: Colors.blueGrey.shade800
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.reminder.title,
                          style: TextStyles.b1,
                        ),
                        const Spacer(),
                        Text(
                          DateFormat.yMEd().format(widget.reminder.dateTime),
                          style: TextStyles.b3(),
                        )
                      ],
                    ),
        
                    Spaces.vertical20,
        
                    Text(
                      widget.reminder.description,
                      style: TextStyles.b4(color: Colors.blueGrey.shade800),
                    )
                  ],
                ),
              ),
        
              Spaces.vertical(h/10),
              
              TextFormField(
                onChanged: (value) => setState(() {
                  widget.reminder.title = value;
                }),
                initialValue: widget.reminder.title,
                decoration: Decorations.textFormField('Title', Colors.purple)
              ),
              
              Spaces.vertical40,
                            
              TextFormField(
                onChanged: (value) => setState(() {
                  widget.reminder.description = value;
                }),
                initialValue: widget.reminder.description,
                decoration: Decorations.textFormField('Description', Colors.purple)
              ),
        
              Spaces.vertical(h/10),
            ],
          ),
        ),
      ),
    );
  }
}