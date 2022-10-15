
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/TimeTable.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/enums.dart';

import '../Globals/Decorations.dart';
import '../Globals/Providers.dart';
import '../Globals/Utils.dart';

class CreateTableCard extends StatelessWidget {
  const  CreateTableCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String title = 'Title';

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
            
                  const SizedBox(height: 40,),
                
                  TextFormField(
                    onSaved: (value) {
                      title = value??'';
                    },
                    style: TextStyle(
                      color: Colors.blueGrey.shade800,
                    ),
                    initialValue: title,
                    decoration: Decorations.titleTextField,
                    validator: (title){ 
                      if(title == null || title == ''){
                        return 'Title must not be empty.';
                      }
                    }
                    ),
            
                  const SizedBox(height: 40,),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      ElevatedButton(
                        onPressed: () {

                          try{
                            Table_pr tableReader = context.read<Table_pr>();

                            Utils.formKey.currentState!.validate();
                            Utils.formKey.currentState!.save();

                            tableReader.validateTitle(title);

                            //1) Add to disk
                            //2) Add to provider.
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
                        }, 
                        child: const Text(
                          'Add',
                        ),
                      ),
                      
                      Spaces.horizontal20,
                      
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyles.closeButton(Colors.blueGrey.shade800),
                        child: const Text(
                          'Cancel',
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
              backgroundColor: Colors.purple,
              radius: 30,
              child: Icon(Icons.playlist_add, size: 30,),
            ),
          )
        ],
      ),
    );
  }
}