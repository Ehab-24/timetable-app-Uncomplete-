
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';

import '../Classes/TimeTable.dart';
import '../Globals/Providers.dart';
import '../Globals/Styles.dart';
import '../Globals/Utils.dart';

class DeleteTableCard extends StatefulWidget {
  const DeleteTableCard({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  State<DeleteTableCard> createState() => _DeleteTableCardState();
}

class _DeleteTableCardState extends State<DeleteTableCard>{

  late Table_pr tableReader;

  @override
  void initState() {
    tableReader = Provider.of<Table_pr>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    String title = widget.timeTable.title;

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

                const Text(
                  'Item will be deleted permnently',
                  style: TextStyles.body4,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20,),
              
                Text(
                  'Do you want to delete table: "$title"?',
                  style: TextStyles.body1,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40,),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    ElevatedButton(
                      onPressed: () {
                        tableReader.removeTable(widget.timeTable);
                        LocalDatabase.instance.deleteTimeTable(widget.timeTable.id!);

                        Navigator.of(context).pop();
                        
                        Utils.showSnackBar(context, 'Deleted table: "$title"', seconds: 2);
                      }, 
                      child: const Text(
                        'Yes',
                      ),
                    ),
                    
                    const SizedBox(width: 40),
                    
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      }, 
                      child: const Text(
                        'No',
                      ),
                    ),
                  ],
                )
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