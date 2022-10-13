
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/TimeTable.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';

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
                          Utils.formKey.currentState!.validate();
                          Utils.formKey.currentState!.save();

                          //1) Add to disk
                          //2) Add to provider.
                          LocalDatabase.instance.addTimeTable(
                            TimeTable(title: title)
                          ).then((timeTable) => 
                              Provider.of<Table_pr>(context, listen: false).addTable(timeTable)
                            );
                          
                          Navigator.of(context).pop();
                        }, 
                        child: const Text(
                          'Add',
                        ),
                      ),
                      
                      const SizedBox(width: 40),
                      
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        }, 
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