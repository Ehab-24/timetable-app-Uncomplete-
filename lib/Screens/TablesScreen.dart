
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
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
  
  late final PageController pageController;

  @override
  void initState() {
    delay();
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  int tableIndex = 0;

  @override
  Widget build(BuildContext context) {
    
    Table_pr tableWatch = context.watch<Table_pr>();
    final double w = Utils.screenWidthPercentage(context, 1);
    final double h = Utils.screenHeightPercentage(context, 1);
    
    return SafeArea(
      
      child: Scaffold(
      
        backgroundColor: Colors.grey.shade200,
    
        body: Stack(
    
          clipBehavior: Clip.none,
    
          children: [
            
            Column(
              children: [
    
                const TableScreenAppBar(),

                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: ((index) => 
                      setState(() {
                        tableIndex = index;
                      })
                    ),
                    itemCount: tableWatch.tables.length,
                    itemBuilder: ((context, index) => 
                      AnimatedOpacity(
                        duration: Durations.d300,
                        curve: Curves.easeInOut,
                        opacity: beginAnimation? 1: 0,
                        child: Padding(
                          padding: EdgeInsets.only(left: w * 0.05, top: h * 0.05),
                          child: TimeTableTile(table: tableWatch.tables[index]),
                        ))
                    )
                  ),
                ),
              ],
            ),
            
            Positioned(
              top: h * 0.38,
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
      ),
    );
  }
  
  Future<void> delay() async {
    Future.delayed(Durations.d800, () {
      setState(() {beginAnimation = true;});
    });
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class TableScreenAppBar extends StatefulWidget {
  const TableScreenAppBar({super.key});

  @override
  State<TableScreenAppBar> createState() => _TableScreenAppBarState();
}

class _TableScreenAppBarState extends State<TableScreenAppBar> 
  with TickerProviderStateMixin {

  late final AnimationController controller;
  late final SequenceAnimation animation;

  @override
  void initState() {
     controller = AnimationController(vsync: this, duration: Durations.d800);

    animation = SequenceAnimationBuilder()
    .addAnimatable(
      animatable: Tween<double>(begin: 0.8, end: 1.1), 
      from: Durations.d200, 
      to: Durations.d600, 
      tag: 'scale',
      curve: Curves.easeOutCubic
    )
    .addAnimatable(
      animatable: Tween<double>(begin: 1, end: 1.1), 
      from: Durations.d500, 
      to: Durations.d800, 
      tag: 'scale2',
      curve: Curves.easeInCubic
    )
    .addAnimatable(
      animatable: Tween<double>(begin: 0, end: 1), 
      from: Durations.zero, 
      to: Durations.d600, 
      tag: 'opacity',
      curve: Curves.easeOutSine
    )
    .addAnimatable(
      animatable: Tween<double>(begin: 0, end: 1), 
      from: Durations.d500, 
      to: Durations.d800, 
      tag: 'opacity2',
      
    )
    .animate(controller);

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final double h = Utils.screenHeightPercentage(context, 1);
    final double w = Utils.screenWidthPercentage(context, 1);

    return ClipRRect(
      
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.elliptical(w/2, h * 0.05),
        bottomRight: Radius.elliptical(w/2, h * 0.05),
      ),
      
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Opacity(
            opacity: animation['opacity'].value,
            child: Container(
              // width: w * animation['scale'].value,
              height: h * 0.382 * animation['scale'].value / animation['scale2'].value,
              decoration: const BoxDecoration(
                gradient: Gradients.primary,
              ),
              child: Opacity(
                opacity: animation['opacity2'].value,
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
                        text: TextSpan(
                          children: [
                            
                            ...appBarHeader('M', 'y'),
                            ...appBarHeader(' T', 'ables')
                          ]
                        )
                      ),
                    ), 
                  ],
                ),
              )
            ),
          );
        }
      ),
    );
  }
}