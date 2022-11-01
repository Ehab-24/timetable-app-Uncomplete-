
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Databases/ServicesPref.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';

import '../../../Globals/Providers.dart';
import '../../../Widgets/TimeTableTile.dart';
import '../Globals/Reals.dart';
import '../Widgets/LinearFlowFAB.dart';


class TablesScreen extends StatefulWidget{
  const TablesScreen({Key? key}): super(key: key);

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {

  bool animate1 = false;
  bool animate2 = false;
  
  late final PageController pageController;

  @override
  void initState() {
    delay();
    pageController = PageController(initialPage: Prefs.homeTable);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    
    return SafeArea(

      child: Scaffold(

        resizeToAvoidBottomInset: false,      
        backgroundColor: colorWatch.background,
      
        body: Stack(
          children: [

            SizedBox(height: Utils.screenHeightPercentage(context, 1), width: Utils.screenWidthPercentage(context, 1),),
            
            Column(
              children: [
                
                const TableScreenAppBar(),
            
                Spaces.vertical60,
              
                _TablesList(
                  pageController: pageController, 
                  animate1: animate1,
                  animate2: animate2,
                ),
              ],
            ),
            
            //FAB to add a table
            const _FAB(),
          ],
        ),
      
        //FAB for navigation.
        floatingActionButton: const LinearFlowFAB(),
      ),
    );
  }
  
  Future<void> delay() async {
    await Future.delayed(Durations.d600);
    setState(() {animate1 = true;});
    await Future.delayed(Durations.d300);
    setState(() {animate2 = true;});
  }
}

class _FAB extends StatelessWidget {
  const _FAB({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    
    return Positioned(
      top: Utils.screenHeightPercentage(context, 0.312),
      right: 20,
      child: DecoratedBox(
        decoration: Decorations.FAB(colorWatch.shadow_alt),
        child: FloatingActionButton(
          onPressed: (){
            Utils.showCreateTableDialog(context);
          },
          elevation: 0,
          foregroundColor: colorWatch.foreground,
          backgroundColor: colorWatch.onBackground,
          child: const Icon(Icons.playlist_add),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _TablesList extends StatelessWidget {
  const _TablesList({
    Key? key,
    required this.pageController,
    required this.animate1,
    required this.animate2,
  }) : super(key: key);

  final PageController pageController;
  final bool animate1;
  final bool animate2;

  @override
  Widget build(BuildContext context) {

    final Table_pr tableWatch = context.watch<Table_pr>();

    final w = Utils.screenWidthPercentage(context, 1);

    return Expanded(
      
      child: PageView.builder(
        
        controller: pageController,
        onPageChanged: ((index) => 
          currentTableIndex = index
        ),
        itemCount: tableWatch.tables.length,
        itemBuilder: ((context, index) => 
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.05,),
            child: TimeTableTile(animate1: animate1, animate2: animate2, table: tableWatch.tables[index]),
          )
        )
      ),
    );
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

    print(Prefs.isDarkMode);

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

    return DecoratedBox(

      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.pink,
            blurRadius: 20,
            offset: Offset(0, 5)
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(w/2, h * 0.07),
          bottomRight: Radius.elliptical(w/2, h * 0.07),
        ),
      ),

      child: ClipRRect(
        
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
              
                height: h * 0.322 * animation['scale'].value / animation['scale2'].value,
                decoration: Decorations.tablesScreenAppBar,
              
                child: Opacity(
                  opacity: animation['opacity2'].value,
                  child: Stack(
                    
                    children: [
                    
                      Positioned(
                        top: h * 0.06,
                        left: w * 0.4,
                        child: _RotatedIcon(opacity: 0.25, size: w * 0.15, angle: pi/3,),
                      ),
                      Positioned(
                        top: h * 0.16,
                        left: w * 0.05,
                        child: _RotatedIcon(angle: pi/1.1,size: w * 0.5, opacity: 0.3,)
                      ),
                      Positioned(
                        top: h * 0.14,
                        left: w * 0.65,
                        child: _RotatedIcon(angle: pi/4, size: w * 0.25, opacity: 0.2,)
                      ),
                    
                      Align(
                        alignment: const Alignment(0, 0.6),
                        child: Text(
                          'My Tables',
                          style: TextStyles.h1light(Colors.white.withOpacity(0.9)),
                        ),
                      ), 
                    ],
                  ),
                )
              ),
            );
          }
        ),
      ),
    );
  }
}
//
class _RotatedIcon extends StatelessWidget {
  const _RotatedIcon({
    Key? key,
    required this.angle,
    required this.size,
    required this.opacity
  }) : super(key: key);

  final double size;
  final double opacity;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Icon(
        Icons.pages_rounded, 
        size: size, 
        color: Color.fromRGBO(214, 214, 214, opacity),
      ),
    );
  }
}