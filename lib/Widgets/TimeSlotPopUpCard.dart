
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/TimeSlot.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';

import '../Globals/Providers.dart';
import '../Globals/Reals.dart';
import '../Globals/Utils.dart';

class TimeSlotPopUpCard extends StatefulWidget {
  TimeSlotPopUpCard({
    Key? key,
    required this.formKey,
    required this.timeSlot,
    required this.isfirst,
    required this.color
  }) : newDay = timeSlot.day, previousDay = timeSlot.day, super(key: key);

  final GlobalKey<FormState> formKey;
  final TimeSlot timeSlot;
  final bool isfirst;
  final Color color;
  
  //1)We need 'previousDay' to keep track from which list/day the slot was removed.
  //2)We use 'newDay' for late assignment to 'timeSlot.day' (thus, in case of 
  //clash error, we do not save the changed day as 'timeSlot.day'). 
  int previousDay, newDay;

  @override
  State<TimeSlotPopUpCard> createState() => _TimeSlotPopUpCardState();
}

class _TimeSlotPopUpCardState extends State<TimeSlotPopUpCard> {


  @override
  Widget build(BuildContext context) {

  
  final Day_pr dayWatch = context.watch<Day_pr>();
  
    return StatefulBuilder(
      builder: (context, setState) {

        return Dialog(

          backgroundColor: Colors.white,

          child: Stack(

            clipBehavior: Clip.none,
            alignment: Alignment.center,

            children: [

              Form(
                key: widget.formKey,
                child: Scrollbar(

                  thickness: 4,

                  child: SingleChildScrollView(
                
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                    physics: const BouncingScrollPhysics(),
                
                    child: Column(
                      children: [
                
                        const SizedBox(height: 10),
                          
                        TextFormField(
                          onSaved: (value) {
                            widget.timeSlot.title = value??'Title';
                          },
                          style: TextStyle(
                            color: Colors.blueGrey.shade800,
                          ),
                          initialValue: widget.timeSlot.title,
                          validator: (title) {
                            if(title == null || title == ''){
                              return 'Title must not be empty.';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(
                              color: Utils.darken(widget.color)
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                        const SizedBox(height: 20,),
                
                        TextFormField(
                          onSaved: (value) {
                            widget.timeSlot.subtitle = value??'';
                          },
                          style: TextStyle(
                            color: Colors.blueGrey.shade800,
                          ),
                          initialValue: widget.timeSlot.subtitle,
                          decoration: InputDecoration(
                            labelText: 'Subtitle',
                            labelStyle: TextStyle(
                              color: Utils.darken(widget.color)
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                        const SizedBox(height: 20,),
                
                        TextFormField(
                
                          onSaved: (newValue){
                           widget.timeSlot.venue = newValue ?? '';
                          },
                          style: TextStyle(
                            color: Colors.blueGrey.shade800,
                          ),
                          initialValue: widget.timeSlot.venue,
                          decoration: InputDecoration(
                            labelText: 'Venue',
                            labelStyle: TextStyle(
                              color: Utils.darken(widget.color)
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                        const SizedBox(height: 20,),
                
                        Container(
                          
                          width: 200,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Utils.lighten(widget.color),
                            ),
                            borderRadius: BorderRadius.circular(6)
                          ),
                
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                          
                              value: days[dayWatch.selectedDay],
                              isExpanded: true,
                                            
                              style: TextStyle(
                                color: Colors.blueGrey.shade800
                              ),
                          
                              iconSize: 32,
                              iconEnabledColor: widget.color,
                              
                              items: days.map((day)
                                => DropdownMenuItem<String>(
                                  value: day,
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      color: Colors.blueGrey.shade800
                                    ),
                                  ),
                                )).toList(),
                              
                              onChanged: (newValue) {
                                if(newValue != null){
                                  setState((){
                                    widget.newDay = days.indexOf(newValue);
                                  });
                                }
                              }
                            ),
                          ),
                        ),
                
                        const SizedBox(height: 40,),
                      
                        Row(
                
                          children: [
                
                            Text(
                              'Start Time:',
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.w400,
                                color: Utils.darken(widget.color),
                              ),
                            ),
                
                            const Spacer(flex: 1),
                
                            Text(
                              widget.timeSlot.startTime.toString().substring(10,15),
                              style: const TextStyle(
                                color: Color.fromRGBO(55, 71, 79, 1),
                                fontSize: 18,
                                letterSpacing: 1.2,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                
                            const Spacer(flex: 3),
                            
                            ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).push(
                                  showPicker(
                                    accentColor: widget.color,
                                    value: widget.timeSlot.startTime,
                                    displayHeader: false, 
                                    onChange: (newValue){
                                      widget.timeSlot.startTime = newValue;
                                      setState((){});
                                    }
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.color
                              ),
                              child: const Icon(Icons.edit, color: Colors.white),
                            ),
                          ],
                        ),
                
                        const SizedBox(height: 2,),
                      
                        Row(
                          children: [
                
                            Text(
                              'End Time:',
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.w400,
                                color: Utils.darken(widget.color),
                              ),
                            ),
                
                            const Spacer(flex: 1),
                
                            Text(
                              widget.timeSlot.endTime.toString().substring(10, 15),
                              style: const TextStyle(
                                color: Color.fromRGBO(55, 71, 79, 1),
                                fontSize: 18,
                                letterSpacing: 1.2,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                
                            const Spacer(flex: 3),
                            
                            ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).push(
                                  showPicker(
                                    accentColor: widget.color,
                                    value: widget.timeSlot.endTime, 
                                    displayHeader: false,
                                    onChange: (newValue){
                                      widget.timeSlot.endTime = newValue;
                                      setState((){});
                                    }
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.color
                              ),
                              child: const Icon(Icons.edit, color: Colors.white,),
                            ),
                          ],
                        ),
                
                        const SizedBox(height: 80,),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              
                              onPressed: () async {
                
                                bool isvalid = widget.formKey.currentState!.validate();
                                if(isvalid){
                                  widget.formKey.currentState!.save();
                
                                  try{
                
                                    Table_pr provider = Provider.of<Table_pr>(context, listen: false);
                                    
                                    widget.timeSlot.parentId = currentTableId;
                
                                    widget.timeSlot.validate();
                                    provider.validate(widget.timeSlot.copyWith(day: widget.newDay));
                
                                    widget.timeSlot.day = widget.newDay;

                
                                    if(widget.isfirst){
                                      //1) Save to disk
                                      //2) Save to provider.
                                      TimeSlot newSlot = await LocalDatabase.instance.addSlot(widget.timeSlot);
                                      provider.addSlot(newSlot);
                                    }
                                    else{
                                      await LocalDatabase.instance.updateSlot(widget.timeSlot);                                   
                                      provider.reformList(widget.timeSlot, widget.previousDay);
                                    }
                                    
                                    //Sort the TimeTable
                                    provider.sort(widget.timeSlot.day, widget.timeSlot.parentId);
                                    
                                    if(!mounted){
                                      return;
                                    }
                                    Navigator.of(context).pop();
                                  }
                                  catch (e){
                                    Utils.showErrorDialog(context, e.toString());
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.color
                              ),
                              child: Text(
                                widget.isfirst
                                ? 'Add'
                                : 'Save',
                              ),
                            ),
                            const SizedBox(width: 40),
                            TextButton(
                              
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, 
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: widget.color
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const Positioned(
                top: -30,
                child: CircleAvatar(
                  foregroundColor: Color.fromRGBO(238, 238, 238, 1),
                  backgroundColor: Colors.green,
                  radius: 30,
                  child: Icon(Icons.edit_attributes_rounded, size: 36,),
                ),
              )
            ],
          )
        );
      }
    );
  }
}
