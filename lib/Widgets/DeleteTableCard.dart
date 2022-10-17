
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';

import '../Classes/TimeTable.dart';
import '../Globals/Providers.dart';
import '../Globals/Styles.dart';
import '../Globals/Utils.dart';

class DeleteTableCard extends StatelessWidget {
  const DeleteTableCard({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  Widget build(BuildContext context) {
    
    return Dialog(

      backgroundColor: Colors.transparent,

      child: Stack(

        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,

        children: [

          Container(
            margin: EdgeInsets.symmetric(horizontal: Utils.screenWidthPercentage(context, 0.04)),
            
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
          
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            
            child: Column(
          
              mainAxisSize: MainAxisSize.min,
          
              children: [

                const SizedBox(height: 40,),

                Text(
                  'Item will be deleted permnently',
                  style: TextStyles.b4(),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20,),
              
                Text(
                  'Do you want to delete table: "${timeTable.title}"?',
                  style: TextStyles.b1,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40,),
            
                _Actions(timeTable: timeTable)
              ],
            ),
          ),
          
          //Circular Indicator
          const Positioned(
            top: -30,
            child: CircleAvatar(
              foregroundColor: Color.fromRGBO(238, 238, 238, 1),
              backgroundColor: Color.fromRGBO(66, 66, 66, 1),
              radius: 30,
              child: Icon(Icons.delete, size: 30,),
            ),
          )
        ],
      ),
    );
  }
}

class _Actions extends StatefulWidget {
  const _Actions({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  State<_Actions> createState() => _ActionsState();
}

class _ActionsState extends State<_Actions> {

  late final Table_pr tableReader;

  @override
  void initState() {
    tableReader = context.read<Table_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        ElevatedButton(
          onPressed: () {
            if(tableReader.tables.length == 1){
              Navigator.of(context).pop();
              Utils.showErrorDialog(context, 'You must have atleast one table :(');
              return;
            }
            tableReader.removeTable(widget.timeTable);
            LocalDatabase.instance.deleteTimeTable(widget.timeTable.id!);

            Navigator.of(context).pop();
            
            Utils.showSnackBar(context, 'Deleted table: "${widget.timeTable.title}"', seconds: 2);
          }, 
          child: const Text(
            'Yes',
          ),
        ),
        
        const SizedBox(width: 40),
        
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ButtonStyles.closeButton(Colors.blueGrey.shade800),
          child: const Text(
            'No',
          ),
        ),
      ],
    );
  }
}