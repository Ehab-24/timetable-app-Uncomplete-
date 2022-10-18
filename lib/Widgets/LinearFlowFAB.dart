
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';

import '../Globals/Providers.dart';
import '../Globals/enums.dart';


const double buttonSize = 50;

class LinearFlowFAB extends StatefulWidget{
  const LinearFlowFAB({
    Key? key,
  }) : super(key: key);

  @override
  State<LinearFlowFAB> createState() => _LinearFlowFABState();
}

class _LinearFlowFABState extends State<LinearFlowFAB>
  with SingleTickerProviderStateMixin {

  late final Screen_pr screenReader;
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {

    screenReader = context.read<Screen_pr>();

    controller = AnimationController(
      duration: Durations.d300,
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1)
      .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOutQuint));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Screen_pr screenWatch = context.watch<Screen_pr>();

    return Flow(
      delegate: FlowMenuDelegate(controller: controller, animation: animation),

      children: [
        buildItem(
          Icons.home_outlined, (){
          if(screenWatch.currentScreen == Screens.home){
            controller.reverse();
          }
          else{
            screenReader.setScreen(Screens.home);
          }}
        ),
        buildItem(Icons.list_alt, () {
          if(screenWatch.currentScreen == Screens.mytables){
            controller.reverse();
          }
          else{
            screenReader.setScreen(Screens.mytables);
          }
        }),
        buildItem(Icons.schedule, () {
          if(screenWatch.currentScreen == Screens.schedule){
            controller.reverse();
          }
          else{
            screenReader.setScreen(Screens.schedule);
          }
        }),
        buildItem(Icons.browse_gallery_outlined, () {
          if(screenWatch.currentScreen == Screens.reminders){
            controller.reverse();
          }
          else{
            screenReader.setScreen(Screens.reminders);
          }
        }),
        buildItem(Icons.menu, () {
          if(controller.status == AnimationStatus.completed){
            controller.reverse();
          }
          else{
            controller.forward();
          }
        })
      ]
    );
  }
  
  Widget buildItem(IconData icon, VoidCallback onPressed) {

    Screen_pr screenWatch = context.watch<Screen_pr>();

    Color splashColor = screenWatch.currentScreen == Screens.home
    ? Colors.black38
    : Colors.white30;

    return Material(
      type: MaterialType.transparency,
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(buttonSize/2),
      child: InkResponse(
    
        splashColor: splashColor,
        highlightColor: splashColor,
        containedInkWell: true,
        borderRadius: BorderRadius.circular(buttonSize/2),
        onTap: onPressed,
    
        child: Ink(
      
          width: buttonSize,
          height: buttonSize,
      
          decoration: BoxDecoration(
            gradient: screenWatch.currentScreen == Screens.home
            ? LinearGradient(colors: [Colors.white, Colors.grey.shade300])
            : Gradients.linearFlowFAB,
            borderRadius: BorderRadius.circular(buttonSize/2),
          ),
      
          child: Center(
            child: icon == Icons.menu
            ? AnimatedIcon(
                icon: AnimatedIcons.menu_close, 
                progress: controller, 
                color: screenWatch.currentScreen == Screens.home
                ? Colors.blueGrey.shade800
                : Colors.white,
                )
            : Icon(
              icon, 
              color: screenWatch.currentScreen == Screens.home
              ? Colors.blueGrey.shade800
              : Colors.white
              ),
          )
        ),
      ),
    );
  }
}


class FlowMenuDelegate extends FlowDelegate{

  FlowMenuDelegate({
    required this.controller,
    required this.animation
  }): super(repaint: controller);

  final AnimationController controller;
  final Animation<double> animation;

  @override
  void paintChildren(FlowPaintingContext context) {
    
    final Size size = context.size;
    const marginy = 70;


    for(int i = 0; i < context.childCount - 1; i++){
    
      final dx = size.width - buttonSize;
      final dy = size.height - marginy - ((i + 1) * (buttonSize + 14)) * animation.value;

      context.paintChild(i, transform: Matrix4.translationValues(dx, dy, 0));
    }
    context.paintChild(
      context.childCount - 1,
      transform: Matrix4.translationValues(size.width - buttonSize, size.height - marginy, 0)
    );
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}