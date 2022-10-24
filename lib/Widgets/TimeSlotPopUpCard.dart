
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/TimeSlot.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/enums.dart';

import '../Globals/Providers.dart';
import '../Globals/Reals.dart';
import '../Globals/Utils.dart';

class TimeSlotPopUpCard extends StatefulWidget {
  TimeSlotPopUpCard({
    Key? key,
    required this.timeSlot,
    required this.isfirst,
    required this.color
  }) : newDay = timeSlot.day, previousDay = timeSlot.day, super(key: key);

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

  Future<void> onSave() async {       
   
    bool isvalid = Utils.formKey.currentState!.validate();
    if(isvalid){
      try{
        Table_pr provider = Provider.of<Table_pr>(context, listen: false);
        
        widget.timeSlot.parentId = currentTableId;

        Utils.formKey.currentState!.save();
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
  }

  @override
  Widget build(BuildContext context) {
  
    return StatefulBuilder(
      builder: (context, setState) {

        return Dialog(

          backgroundColor: Colors.white,

          child: Stack(

            clipBehavior: Clip.none,
            alignment: Alignment.center,

            children: [

              Form(
                key: Utils.formKey,
                child: Scrollbar(

                  thickness: 4,

                  child: SingleChildScrollView(
                
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                
                    child: Column(
                      children: [
                
                        Spaces.vertical10,
                          
                          //Title Field
                        _InputField(
                          label: 'Title', 
                          onSaved: (value) => widget.timeSlot.title = value ?? 'Title', 
                          color: widget.color, 
                          initialValue: widget.timeSlot.title,
                          validator: (title) {
                            if(title == null || title == ''){
                              return 'Title must not be empty.';
                            }
                            return null;
                          },
                        ),

                        Spaces.vertical20,
                
                        //Subtitle Field
                        _InputField(
                          initialValue: widget.timeSlot.subtitle,
                          color: widget.color,
                          label: 'Subtitle',
                          onSaved: (value) => widget.timeSlot.subtitle = value ?? '',
                        ),

                        Spaces.vertical20,
                
                        //Venue Field
                        _InputField(
                          label: 'Venue', 
                          onSaved: (value) => widget.timeSlot.venue = value ?? '', 
                          color: widget.color, 
                          initialValue: widget.timeSlot.venue
                        ),
                        
                        Spaces.vertical20,
                
                        //Day Selector
                        Container(
                          
                          width: 200,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: Decorations.dropdownButton(Utils.lighten(widget.color)),
                          
                          child: _DropdownButton(
                            color: widget.color,
                            currentDay: days[widget.newDay],
                            onChanged: (newValue) {
                              if(newValue != null){
                                setState((){
                                  widget.newDay = days.indexOf(newValue);
                                });
                              }
                            },
                          ),
                        ),
                
                        Spaces.vertical40,
                      
                        //StartTime modifier
                        _TimerRow(
                          label: 'Start Time:',
                          color: widget.color, 
                          initialValue: widget.timeSlot.startTime, 
                          onChange: (newValue) =>
                            setState(() => widget.timeSlot.startTime = newValue)
                        ),
                
                        const SizedBox(height: 2,),
                      
                        //EndTime modifier
                        _TimerRow(
                          color: widget.color, 
                          label: 'End Time:', 
                          initialValue: widget.timeSlot.endTime, 
                          onChange: (newValue) =>
                            setState(() => widget.timeSlot.endTime = newValue)
                        ),
                
                        const SizedBox(height: 80,),
                        
                        //Actions:-
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, 
                              style: ButtonStyles.closeButton(widget.color),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: widget.color
                                ),
                              ),
                            ),
                            
                            Spaces.horizontal40,

                            ElevatedButton(
                              
                              onPressed: onSave,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.color
                              ),
                              child: Text(
                                widget.isfirst
                                ? 'Add'
                                : 'Save',
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

///////////////////////////////////////////////////////////////////////////////////////////////////

class _TimerRow extends StatelessWidget {
  const _TimerRow({
    Key? key,
    required this.color,
    required this.label,
    required this.initialValue,
    required this.onChange,
  }) : super(key: key);

  final Color color;
  final String label;
  final TimeOfDay initialValue;
  final void Function(TimeOfDay) onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
                
      children: [
                
        Text(
          label,
          style: TextStyles.b4(color: color),
        ),
                
        const Spacer(flex: 1),
                
        Text(
          initialValue.toString().substring(10,15),
          style: TextStyles.b3()
        ),
                
        const Spacer(flex: 3),
        
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).push(
              showPicker(
                // iosStylePicker: true,
                hourLabel: '',
                minuteLabel: '',
                accentColor: color,
                value: initialValue,
                displayHeader: false,
                onChange: onChange,
                buttonsSpacing: 8,
                buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                ),
                cancelButtonStyle: ElevatedButton.styleFrom()
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: color
          ),
          child: const Icon(Icons.edit, color: Colors.white),
        ),
      ],
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class _DropdownButton extends StatelessWidget {
  const _DropdownButton({
    Key? key,
    required this.color,
    required this.onChanged,
    required this.currentDay,
  }) : super(key: key);

  final Color color;
  final String currentDay;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
    
        value: currentDay,
        isExpanded: true,
                      
        style: TextStyle(
          color: Colors.blueGrey.shade800
        ),
    
        iconSize: 32,
        iconEnabledColor: color,
        
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
        
        onChanged: onChanged
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

class _InputField extends StatelessWidget {
  const _InputField({
    Key? key,
    required this.label,
    required this.onSaved,
    required this.color,
    required this.initialValue,
    this.validator,
  }) : super(key: key);

  final String label;
  final String initialValue;
  final Color color;
  final Function(String?) onSaved;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      style: TextStyle(
        color: Colors.blueGrey.shade800,
      ),
      initialValue: initialValue,
      validator: validator,
      decoration: Decorations.textFormField(label, color),
    );
  }
}
