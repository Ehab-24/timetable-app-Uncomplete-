
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';

import '../../Widgets/LinearFlowFAB.dart';

class ScheduleScreen extends StatefulWidget{
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: const LinearFlowFAB(),

      body: Container(
    
        width: 200,
        height: 400,
        color: Colors.amber,
    
        child: IconButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: ((context) => const Dummy())) 
            );
          },
          icon: const Icon(Icons.golf_course),
        ),
      ),
    );
  }
}



class Dummy extends StatefulWidget{
  const Dummy({super.key});


  @override
  State<StatefulWidget> createState() => _DummyState();
}

class _DummyState extends State<Dummy>{

  bool beginAnimate = false;
  int ticker = 0;

  List<Color>colors = List<Color>.generate(100, (index) => Colors.primaries[Random().nextInt(Colors.primaries.length)]);

  late final Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(
      Durations.d100, 
      ((timer) {setState(() {
        ticker++;
      });
    }));
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final h = Utils.screenHeightPercentage(context, 1);

    return Scaffold(

      appBar: AppBar(backgroundColor: Colors.transparent,),

      body: Stack(
        children: [

          Column(
            children: [

              // Container(
              //   width: double.infinity,
              //   height: h * 0.4,
              //   decoration: const BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage('assets/images/blobs_bk2.png'),
              //       fit: BoxFit.cover,
              //       filterQuality: FilterQuality.high,
              //       colorFilter: ColorFilter.mode(Colors.green, BlendMode.darken)
              //     )
              //   ),
              // ),

              Expanded(
                child: ListView.builder(
              
                  physics: const BouncingScrollPhysics(),
              
                  itemCount: 100,
                  itemBuilder: ((context, index) => 
                    OpacityContainer(
                      beginAnimate: ticker > index + 2, 
                      color: colors[index]
                    )
                  )
                ),
              ),
            ],
          ),

          
          Positioned(

            top: h * 0.5,
            right: 20,
            child: FloatingActionButton(
              onPressed: (){
                setState(() {
                  ticker = 0;
                });
              },
              child: Icon(Icons.restore_outlined, color: Colors.blueGrey.shade800,),
            ),
          ),
        ],
      ),
    );
  }
}

class OpacityContainer extends StatelessWidget {
  const OpacityContainer({
    Key? key,
    required this.beginAnimate,
    required this.color,
  }) : super(key: key);

  final Color color;
  final bool beginAnimate;

  @override
  Widget build(BuildContext context) {

    final double h = Utils.screenHeightPercentage(context, 1);

    return AnimatedPadding(

      duration: Durations.d300,
      curve: Curves.decelerate,
      padding: beginAnimate
      ? const EdgeInsets.only(
        left: 100,
        right: 100,
        top: 20
      )
      : const EdgeInsets.only(
        left: 0,
        right: 200
      ),

      child: AnimatedOpacity(
    
        duration: beginAnimate
        ? Durations.d500
        : const Duration(seconds: 0),
    
        curve: Curves.easeInOut,
        opacity: beginAnimate? 1 :0,
    
        child: Container(
          width: double.infinity,
          height: h * 0.1,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.elliptical(100, 20),
              right: Radius.elliptical(20, 100),
            ),
            border: Border.all(
              width: 4,
              color: Colors.purple,
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 30,
                color: Colors.black,
                offset: Offset(5,10)
              ),
              BoxShadow(
                blurRadius: 20,
                color: Colors.purple,
                offset: Offset(10,-5)
              ),
              BoxShadow(
                blurRadius: 25,
                color: Colors.blue,
                offset: Offset(-5,5)
              ),
              BoxShadow(
                blurRadius: 15,
                color: Colors.green,
                offset: Offset(-5,-10)
              ),
              BoxShadow(
                blurRadius: 10,
                color: Colors.brown,
                offset: Offset(5,-5)
              )
            ]
          ),
          child: Stack(
            children: [
              const Positioned(
                left: 20,
                child: Icon(Icons.access_alarm, size: 200, color: Colors.white38,)
              ),
              Positioned(
                right: 20,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}