
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';

import '../../../Globals/Providers.dart';
import '../../../Widgets/TimeTableTile.dart';
import '../Widgets/LinearFlowFAB.dart';


class TablesScreen extends StatefulWidget{
  const TablesScreen({Key? key}): super(key: key);

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {

  bool beginAnimation = false;

  @override
  void initState() {
    delay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    Table_pr tableWatch = context.watch<Table_pr>();
    final double w = Utils.screenWidthPercentage(context, 1);
    final double h = Utils.screenHeightPercentage(context, 1);
    
    return Scaffold(
    
      backgroundColor: Colors.grey.shade200,

      appBar: TableScreenAppBar(h: h),
    
      body: Stack(

        clipBehavior: Clip.none,

        children: [
          
          ListView.builder(
            
            // onPageChanged: ((value) => currentTableId = value),
            physics: const BouncingScrollPhysics(),

            itemCount: tableWatch.tables.length + 1,
            itemBuilder: ((context, index) => index == 0
            ? SizedBox(height: h * 0.01,)
            : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12
              ),
              child: AnimatedOpacity(
        
                duration: Durations.d500,
                curve: Curves.easeInOut,
                opacity: beginAnimation? 1: 0,
        
                child: TimeTableTile(
                  table: tableWatch.tables[index - 1]
                )
              ),
            )
            )
          ),
          
          Positioned(
            top: -10,
            right: 20,
            child: FloatingActionButton(
              onPressed: (){
                Utils.showCreateTableDialog(context);
              },
              child: const Icon(Icons.playlist_add, color: Color.fromRGBO(55, 71, 79, 1),),
            ),
          ),
        ],
      ),
  
      floatingActionButton: const LinearFlowFAB(),
    );
  }
  
  Future<void> delay() async {
    Future.delayed(Durations.d500, () {
      setState(() {beginAnimation = true;});
    });
  }
}

class TableScreenAppBar extends StatelessWidget 
  implements PreferredSizeWidget{

  const TableScreenAppBar({
    Key? key,
    required this.h
  }) : super(key: key);

  final double h;

  @override
  Size get preferredSize => Size.fromHeight(h * 0.4);

  @override
  Widget build(BuildContext context) {

    final double w = Utils.screenWidthPercentage(context, 1);

    return Container(

      decoration: BoxDecoration(
        gradient: Gradients.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(w/2, h * 0.05),
          bottomRight: Radius.elliptical(w/2, h * 0.05),
        ),
      ),
      child: Stack(
        children: [

          Positioned(
            top: h * 0.12,
            left: w * 0.4,
            child: Transform.rotate(
              angle: 29,
              child: Icon(
                Icons.pages_rounded, 
                size: w * 0.15, 
                color: const Color.fromRGBO(214, 214, 214, 0.4),
              ),
            ),
          ),
          Positioned(
            top: h * 0.22,
            left: w * 0.05,
            child: Transform.rotate(
              angle: 75,
              child: Icon(
                Icons.pages_rounded, 
                size: w * 0.5, 
                color: const Color.fromRGBO(214, 214, 214, 0.4),
              ),
            ),
          ),
          Positioned(
            top: h * 0.2,
            left: w * 0.65,
            child: Transform.rotate(
              angle: 175,
              child: Icon(
                Icons.pages_rounded, 
                size: w * 0.25, 
                color: const Color.fromRGBO(214, 214, 214, 0.4),
              ),
            ),
          ),

          Positioned(
            left: w * 0.32,
            top: h * 0.27,
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'M', 
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                  TextSpan(
                    text: 'y',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  TextSpan(
                    text: '  T', 
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                  TextSpan(
                    text: 'ables',
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ]
              )
            ),
          ), 
        ],
      )
    );
  }
}