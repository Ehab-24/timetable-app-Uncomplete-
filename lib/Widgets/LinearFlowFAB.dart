
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            screenReader.setScreen(Screens.home);
          }
        ),
        buildItem(Icons.list_alt, () {
          if(screenWatch.currentScreen == Screens.mytables){
            controller.reverse();
          }
          screenReader.setScreen(Screens.mytables);
        }),
        buildItem(Icons.schedule, () {
          if(screenWatch.currentScreen == Screens.schedule){
            controller.reverse();
          }
          screenReader.setScreen(Screens.schedule);
        }),
        buildItem(Icons.computer, () {

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

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: FloatingActionButton(

        heroTag: icon.toString(),
        elevation: 0.5,
        backgroundColor: screenWatch.currentScreen == Screens.home
        ? Colors.grey.shade200
        : Colors.blueGrey.shade800,
        
        onPressed: onPressed,
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