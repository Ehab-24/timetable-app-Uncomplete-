
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';

import '../Globals/Providers.dart';
import '../Globals/enums.dart';


const double buttonSize = 50;


class LinearFlowFAB extends StatefulWidget{
  const LinearFlowFAB({super.key});

  @override
  State<LinearFlowFAB> createState() => _LinearFlowFABState();
}

class _LinearFlowFABState extends State<LinearFlowFAB> 
  with SingleTickerProviderStateMixin {

  late final AnimationController controller;
  late final Animation animation;

  late final Screen_pr screenReader;

  @override
  void initState() {

    screenReader = context.read<Screen_pr>();
    
    controller = AnimationController(vsync: this, duration: Durations.d200, reverseDuration: Durations.d150);

    animation = Tween<double>(begin: 1, end: 5)
    .animate(CurvedAnimation(parent: controller, curve: Curves.decelerate));

    controller.addListener(() {
      setState(() {
        isExpanded = controller.status == AnimationStatus.completed;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    final Screen_pr screenWatch = context.watch<Screen_pr>();
    
    return Hero(

      tag: 'main-btn',
      child: AnimatedBuilder(
        
        animation: controller,
        builder: (context, child) {
    
          return Container(
            
            clipBehavior: Clip.hardEdge,
            height: animation.value * buttonSize + 10,
            width: buttonSize,
            margin: const EdgeInsets.only(bottom: 20),
          
            decoration: BoxDecoration(
              gradient: screenWatch.currentScreen == Screens.home
              ? Gradients.linearFlowFAB_alt
              : Gradients.linearFlowFAB,
              borderRadius: BorderRadius.circular(buttonSize/2),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  offset: const Offset(0,2),
                  color: screenWatch.currentScreen == Screens.home 
                  ? Colors.white.withOpacity(0.5)
                  : colorWatch.shadow_alt.withOpacity(0.5),
                )
              ]
            ),
          
            child: Material(
              type: MaterialType.transparency,
              child: SingleChildScrollView(
              
                physics: const NeverScrollableScrollPhysics(),
                reverse: true,
              
                child: Column(
                  
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  
                  children: [
          
                    ExpandedChildren(
                      controller: controller,
                    ),
              
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: _Item(
                        icon: AnimatedIcon(
                          progress: controller,
                          icon: AnimatedIcons.menu_close,
                        ),
                        onPressed: () {
                          isExpanded
                          ? controller.reverse()
                          : controller.forward();
                        },
                      ),
                    ),
                  ]
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ExpandedChildren extends StatefulWidget{
  const ExpandedChildren({
    super.key,
    required this.controller
  });

  final AnimationController controller;

  @override
  State<ExpandedChildren> createState() => _ExpandedChildrenState();
}

class _ExpandedChildrenState extends State<ExpandedChildren> {

  late final Screen_pr screenReader; 

  @override
  void initState() {
    screenReader = context.read<Screen_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final Screen_pr screenWatch = context.watch<Screen_pr>();

    return AnimatedOpacity(

      opacity: widget.controller.value,
      duration: Durations.d100,
      
      child: Column(
        children: [
            
        _Item(icon: const Icon(Icons.person_outline_outlined), onPressed: (){
            if(screenWatch.currentScreen == Screens.profile){
              widget.controller.reverse();
            }
            else{
              screenReader.setScreen(Screens.profile);
            }
          },
        ),

        _Item(icon: const Icon(Icons.browse_gallery_outlined), onPressed: (){
          if(screenWatch.currentScreen == Screens.reminders){
              widget.controller.reverse();
            }
            else{
              screenReader.setScreen(Screens.reminders);
            }
          },
        ),
        
        _Item(icon: const Icon(Icons.list_alt), onPressed: (){
          if(screenWatch.currentScreen == Screens.mytables){
              widget.controller.reverse();
            }
            else{
              screenReader.setScreen(Screens.mytables);
            }
        }),
        
        _Item(icon: const Icon(Icons.home_outlined), onPressed: (){
          if(screenWatch.currentScreen == Screens.home){
            widget.controller.reverse();
          }
          else{
            screenReader.setScreen(Screens.home);
          }
        }),
      ]),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class _Item extends StatelessWidget {
  const _Item({
    Key? key,
    required this.icon,
    required this.onPressed
  }) : super(key: key);

  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {

    return IconButton(
      onPressed: onPressed,
      icon: icon,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}