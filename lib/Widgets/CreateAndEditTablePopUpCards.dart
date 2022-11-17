
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

class CreateTableCard extends StatefulWidget {
  const CreateTableCard({Key? key,}) : super(key: key);

  @override
  State<CreateTableCard> createState() => _CreateTableCardState();
}

class _CreateTableCardState extends State<CreateTableCard> {
  
  String title = '';

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

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
      
                    Spaces.vertical60,
                  
                    TextFormField(
                      maxLength: 10,
                      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => 
                        Transform.translate(
                          offset: const Offset(0, -110),
                          child: Text(
                            '$currentLength/$maxLength',
                            style: TextStyles.toast(
                              colorWatch.foreground,
                              background: colorWatch.background
                            ),
                          ),
                        ),
                      onSaved: (value) {
                        setState(() {
                          title = value??'';
                        });
                      },
                      style: TextStyle(
                        color: colorWatch.foreground,
                      ),
                      initialValue: title,
                      decoration: Decorations.textFieldBold(
                        hint: 'Title', 
                        color: Prefs.isDarkMode
                        ? Colors.black12
                        : Colors.pink.shade100.withOpacity(0.75)
                      ),
                      validator: (title) {
                        if(title == null || title == ''){
                          return 'Title must not be empty.';
                        }
                        return null;
                      }
                    ),

                    ElevatedButton(
                      onPressed: () => _onPressed(context),
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

  void _onPressed (BuildContext context) {
    
    Utils.formKey.currentState!.save();
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
        TimeTable(title: title, lastModified: DateTime.now())
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class EditTableCard extends StatefulWidget {
  const  EditTableCard({
    Key? key,
  }) : super(key: key);

  @override
  State<EditTableCard> createState() => _EditTableCardState();
}

class _EditTableCardState extends State<EditTableCard> {

  late String title;

  @override
  void initState() {
    title = context.read<Table_pr>().tables[currentTableIndex].title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

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
                      'Enter the new title.',
                      style: TextStyles.h2light(colorWatch.foreground),
                      textAlign: TextAlign.center,
                    ),
      
                    Spaces.vertical60,
                  
                    TextFormField(
                      maxLength: 10,
                      buildCounter: (context, {required currentLength, required isFocused, maxLength}) => 
                        Transform.translate(
                          offset: const Offset(0, -110),
                          child: Text(
                            '$currentLength/$maxLength',
                            style: TextStyles.toast(
                              colorWatch.foreground,
                              background: colorWatch.background
                            ),
                          ),
                        )
                      ,
                      onChanged: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                      style: TextStyle(
                        color: colorWatch.foreground,
                      ),
                      initialValue: title,
                      decoration: Decorations.textFieldBold(
                        hint: 'Title', 
                        color: Prefs.isDarkMode
                        ? Colors.black12
                        : Colors.pink.shade100.withOpacity(0.75)
                      ),
                      validator: (title){ 
                        if(title == null || title == ''){
                          return 'Title must not be empty.';
                        }
                      }
                    ),
                    
                    ElevatedButton(
                      onPressed: () => _onPressed(context),
                      child: const Text('Save',),
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

  void _onPressed (BuildContext context) {

    bool isValid = Utils.formKey.currentState!.validate();
    
    if(!isValid){
      return;
    }
    try{
      Table_pr tableReader = context.read<Table_pr>();
    
      tableReader.validateTitle(title);

      FocusManager.instance.primaryFocus!.unfocus();
    
      //No need to await it.
      LocalDatabase.instance.updateTimeTable(
        tableReader.tables[currentTableIndex].copyWith(title: title, lastModified: DateTime.now())
      );
      tableReader.updateTable(currentTableIndex, title, DateTime.now());
    
      Navigator.of(context).pop();
    }
    catch (e){
      Utils.showErrorDialog(context, e.toString());
    }
  }
}