
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/TimeTable.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
import 'package:timetable_app/Globals/Reals.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/enums.dart';

import '../Databases/ServicesPref.dart';
import '../Globals/Decorations.dart';
import '../Globals/Providers.dart';
import '../Globals/Utils.dart';

class CreateTableCard extends StatelessWidget {
  const  CreateTableCard({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    String title = '';

    return Dialog(

      backgroundColor: Colors.transparent,
      child: Container(

        margin: EdgeInsets.symmetric(horizontal: Utils.screenWidthPercentage(context, 0.04)),  
        decoration: Decorations.decoratedContainer_alt(colorWatch.onBackground),
        
        child: Form(
          key: Utils.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children:[
              
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(Icons.close, color: colorWatch.foreground, size: 28,),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add a new Time Table.',
                      style: TextStyles.h2light(colorWatch.foreground),
                      textAlign: TextAlign.center,
                    ),
      
                    Spaces.vertical40,
                  
                    TextFormField(
                      onSaved: (value) {
                        title = value??'';
                      },
                      style: TextStyle(
                        color: colorWatch.foreground,
                      ),
                      initialValue: title,
                      decoration: Decorations.textFieldBold(hint: 'Title', color: Colors.pink.shade100.withOpacity(0.75)),
                      validator: (title){ 
                        if(title == null || title == ''){
                          return 'Title must not be empty.';
                        }
                      }
                    ),
        
                    Spaces.vertical40,

                    ElevatedButton(
                      onPressed: () => _onPressed(context, title),
                      child: const Text('Add',),
                    ),   
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPressed (BuildContext context, String title) {
    bool isValid = Utils.formKey.currentState!.validate();
    if(!isValid){
      return;
    }
    try{
      Table_pr tableReader = context.read<Table_pr>();
    
      Utils.formKey.currentState!.save();
    
      tableReader.validateTitle(title);

      FocusManager.instance.primaryFocus!.unfocus();
    
      LocalDatabase.instance.addTimeTable(
        TimeTable(title: title)
      ).then((timeTable) => 
          tableReader.addTable(timeTable)
      );
    
      Navigator.of(context).pop();
    }
    catch (e){
      Utils.showErrorDialog(context, e.toString());
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////

class EditTableCard extends StatefulWidget {
  const  EditTableCard({
    Key? key,
  }) : super(key: key);

  @override
  State<EditTableCard> createState() => _EditTableCardState();
}

class _EditTableCardState extends State<EditTableCard> {
  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    final Table_pr tableWatch = context.watch<Table_pr>();
    String title = tableWatch.tables[currentTableIndex].title;

    return Dialog(

      backgroundColor: Colors.transparent,

      child: Stack(

        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,

        children: [

          Container(
            margin: EdgeInsets.symmetric(horizontal: Utils.screenWidthPercentage(context, 0.04)),
            
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
          
            decoration: Decorations.popUpCard,
            
            child: Form(
              key: Utils.formKey,
              child: Column(
                      
                mainAxisSize: MainAxisSize.min,
                children: [
            
                  Spaces.vertical40,

                  Text(
                    'Change title of Time Table.',
                    style: TextStyles.b1(colorWatch.foreground),
                  ),

                  Spaces.vertical40,
                
                  TextFormField(
                    
                    initialValue: title,
                    decoration: Decorations.titleTextField,
                    
                    onSaved: (value) {
                      title = value??'';
                    },
                    style: TextStyle(
                      color: colorWatch.foreground,
                    ),
                    validator: (title){ 
                      if(title == null || title == ''){
                        return 'Title must not be empty.';
                      }
                      return null;
                    }
                    ),
            
                  Spaces.vertical40,
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                        ),
                      ),

                      Spaces.horizontal20,

                      ElevatedButton(
                        onPressed: () async {
                          try{
                            Table_pr tableReader = context.read<Table_pr>();

                            Utils.formKey.currentState!.validate();
                            Utils.formKey.currentState!.save();

                            tableReader.validateTitle(title);

                            //Update in provider and database.
                            tableReader.updateTable(currentTableIndex, title);                               
                            await LocalDatabase.instance.updateTimeTable(
                              tableReader.tables[currentTableIndex]
                            );
                          
                            if(mounted){
                              Navigator.of(context).pop();
                            }
                          }
                          catch (e){
                            Utils.showErrorDialog(context, e.toString());
                          }
                        },
                        child: const Text(
                          'Save',
                        ),
                      ),                      
                    ],
                  )
                ],
              ),
            ),
          ),
          
          //Circular Indicator
          const Positioned(
            top: -30,
            child: CircleAvatar(
              foregroundColor: Color.fromRGBO(238, 238, 238, 1),
              backgroundColor: Color.fromRGBO(0, 176, 255, 1),
              radius: 30,
              child: Icon(Icons.edit_note, size: 30,),
            ),
          )
        ],
      ),
    );
  }
}