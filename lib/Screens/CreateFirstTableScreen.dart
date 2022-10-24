
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_arc_text/flutter_arc_text.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:timetable_app/Classes/TimeTable.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
import 'package:timetable_app/Databases/ServicesPref.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';

import '../Globals/Providers.dart';
import '../Globals/enums.dart';



List<Widget> animations = const [
  RiveAnimation.asset(
    'assets/rive/timetable_app_onBoarding.riv',
    artboard: 'page1',
  ),
  RiveAnimation.asset(
    'assets/rive/timetable_app_onBoarding.riv',
    artboard: 'page2',
  ),
  RiveAnimation.asset(
    'assets/rive/timetable_app_onBoarding.riv',
    artboard: 'page3',
  ),
  RiveAnimation.asset(
    'assets/rive/timetable_app_onBoarding.riv',
    artboard: 'page4',
  ),
];

String firstTableTitle = '';


class CreateFirstTableScreen extends StatefulWidget {
  const CreateFirstTableScreen({super.key});

  @override
  State<CreateFirstTableScreen> createState() => _CreateFirstTableScreenState();
}

class _CreateFirstTableScreenState extends State<CreateFirstTableScreen> {

  late final Timer timer;
  late final PageController pageController;
  late final Ticker_pr tickReader;

  @override
  void initState() {
    super.initState();

    tickReader = context.read<Ticker_pr>();

    timer = Timer.periodic(Durations.d100, (timer) {
      tickReader.increment();
    });
    pageController = PageController();
  }

  @override
  void dispose() {

    pageController.dispose();
    
    timer.cancel();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final w = Utils.screenWidthPercentage(context, 1);
    final h = Utils.screenHeightPercentage(context, 1);

    Ticker_pr tickWatch = context.watch<Ticker_pr>();

    return SafeArea(

      child: GestureDetector(

        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },

        child: Scaffold(
      
          body: Container(
            
            width: w,
            decoration: Decorations.firstTableScreen,
            
            child: Stack(
              clipBehavior: Clip.none,
              children: [
            
                Positioned(
                  top: h * 0.05,
                  right: w * -0.03,
                  child: BackgroundBlob(radius: h * 0.1, center: const Alignment(0.2, 0.7),)
                ),
                
                Positioned(
                  top: h * 0.04,
                  right: w * 0.42,
                  child: BackgroundBlob(radius: h * 0.045, center: const Alignment(0.5, 0.5),)
                ),
        
                Positioned(
                  top: h * 0.28,
                  right: w * 0.2,
                  child: BackgroundBlob(radius: h * 0.06, center: const Alignment(0.2, 0.5),)
                ),
                
                Positioned(
                  bottom: h * -0.15,
                  left: w * -0.3,
                  child: BackgroundBlob(radius: w * 0.5, center: const Alignment(0.4, -0.2),)
                ),
                
                Positioned(
                  top: h * 0.54,
                  left: w * 0.4,
                  child: BackgroundBlob(radius: w * 0.12, center: Alignment.center,)
                ),
                
                Positioned(
                  top: h * 0.62,
                  left: w * 0.62,
                  child: BackgroundBlob(radius: w * 0.16, center: Alignment.center,)
                ),
      
                Form(
                  key: Utils.formKey,
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Page1(
                        animate1: tickWatch.value > 10, animate2: tickWatch.value > 15,
                        controller: pageController,
                      ),
                      Page2(
                        animate1: tickWatch.value > 10, animate2: tickWatch.value > 15,
                        controller: pageController,
                        scaffoldContext: context,
                      ),
                      Page3(
                        animate1: tickWatch.value > 10, animate2: tickWatch.value > 13,
                        controller: pageController,
                        scaffoldContext: context,
                      ),
                      Page4(
                        animate1: tickWatch.value > 10, animate2: tickWatch.value > 15,
                        controller: pageController,
                      )
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Page1 extends StatefulWidget{
  const Page1({
    super.key,
    required this.animate1,
    required this.animate2,
    required this.controller
  });

  final bool animate1;
  final bool animate2;
  final PageController controller;

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {

  late final Ticker_pr tickReader;

  @override
  void initState() {
    tickReader = context.read<Ticker_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final h = Utils.screenHeightPercentage(context, 1);
    final w = Utils.screenWidthPercentage(context, 1);
    
    return Stack(
      children: [

        animations[0],

        Align(
          alignment: const Alignment(0.9, 0.9),
          child: FloatingActionButton(
            onPressed: (){
              if(tickReader.value < 20){
                return;
              }
              tickReader.reset();
              widget.controller.animateToPage(1, duration: Durations.d300, curve: Curves.easeOutQuint);
            },
            child: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple,),
          )
        ),

        Positioned(
        
          top: h * 0.16,
          left: w * 0.2,
        
          child: AnimatedScale(

            scale: widget.animate1 ? 1: 0,
            duration: Durations.d1000,
            curve: Curves.elasticOut,

            child: RichText(
              text: TextSpan(
                children: [
                  
                  TextSpan(
                    text: 'W',
                    style: TextStyles.h0(w * 0.16, color: Colors.blueGrey.shade800)
                  ),
                  TextSpan(
                    text: 'elcome',
                    style: TextStyles.h0(w * 0.12, color: Colors.blueGrey.shade800)
                  ),
                ]
              ),
            ),
          ),
        ),

        Positioned(
          right: w * 0.235,
          top: h * 0.45,
          
          child: AnimatedScale(

            scale: widget.animate1 ? 1: 0,
            duration: Durations.d1000,
            curve: Curves.elasticOut,

            child: ArcText(
              text: 'Timerz',
              startAngle: -pi/2.2,
              radius: w * 0.1,
              textStyle: TextStyles.h0(w * 0.07, color: Colors.blueGrey.shade800)
            ),
          )
        ),

        Positioned(
          top: h * 0.55,
          left: w * 0.21,
          child: SizedBox(
            width: w * 0.4,

            child: AnimatedOpacity(

              opacity: widget.animate2? 1: 0,
              duration: Durations.d500,
            
              child: const Text(
                'Welcome to Timerz! A simple app to make the experince of working with time tables easy and friendly.',
                style: TextStyles.b5
              ),
            ),
          ),
        ),
        
        Positioned(
          top: h * 0.75,
          left: w * 0.21,
          child: SizedBox(
            width: w * 0.4,
            
            child: AnimatedOpacity(

              opacity: widget.animate2? 1: 0,
              duration: Durations.d500,

              child: const Text(
                'Build your own time table and let Timerz handle the rest.',
                style: TextStyles.b5
              ),
            ),
          ),
        )
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class Page2 extends StatefulWidget{
  const Page2({
    super.key,
    required this.animate1,
    required this.animate2,
    required this.controller,
    required this.scaffoldContext
  });

  final bool animate1;
  final bool animate2;
  final PageController controller;
  final BuildContext scaffoldContext;

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  
  late final Ticker_pr tickReader;

  @override
  void initState() {
    tickReader = context.read<Ticker_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final h = Utils.screenHeightPercentage(context, 1);
    final w = Utils.screenWidthPercentage(context, 1);

    final bool isKeyboardVisible = MediaQuery.of(widget.scaffoldContext).viewInsets.bottom > 200;

    return Stack(
      children: [
    
        animations[1],
        
        Align(
          alignment: const Alignment(0.9,0.9),
          child: FloatingActionButton(
            onPressed: (){

              if(tickReader.value < 20){
                return;
              }

              bool isValid = Utils.formKey.currentState!.validate();

              if(!isValid){
                return;
              }

              Utils.formKey.currentState!.save();

              FocusManager.instance.primaryFocus?.unfocus();
              
              tickReader.reset();
              widget.controller.animateToPage(2, duration: Durations.d300, curve: Curves.easeOutQuint);
            },
            child: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple,),
          )
        ),
    
        Positioned(
    
          top: isKeyboardVisible? h * 0.23: h * 0.38,
          left: w * 0.5,
    
          child: AnimatedScale(
    
            scale: widget.animate1? 1: 0,
            duration: Durations.d1000,
            curve: Curves.elasticOut,
    
            child: RichText(
              text: TextSpan(
                
                children: [
                  TextSpan(
                    text: 'N',
                    style: TextStyles.h0(w * 0.15)
                  ),
                  TextSpan(
                    text: 'ame?',
                    style: TextStyles.h0(w * 0.1)
                  ),
                ]
              )
            ),
          ),
        ),
    
        Positioned(
    
          top: isKeyboardVisible? h * 0.35: h * 0.5,
          left: w * 0.47,
    
          child: SizedBox(
            height: 100,
            width: 200,
            child: TextFormField(

              initialValue: Prefs.getUsername(),
              
              onSaved: (value) {
                Prefs.setUsername(value ?? '');
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onFieldSubmitted: (val){
                FocusManager.instance.primaryFocus?.unfocus();
              },
              validator: (name) {
                if(name == null || name == ''){
                  return 'Name can not be empty.';
                }
                return null;
              },
              decoration: Decorations.onboardingTextField(w, h)
            ),
          )
        ),
    
        AnimatedAlign(
    
          duration: Durations.d300,
          curve: Curves.easeOut,
          alignment: Alignment(0, widget.animate2? -0.9: -0.8),
    
          child: AnimatedOpacity(
    
            opacity: widget.animate2 && !isKeyboardVisible? 1: 0,
            duration: Durations.d500,
    
            child: Text(
              '-- Respect the abstract.',
              style: TextStyles.b3(color: Colors.grey.shade300)
            ),
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class Page3 extends StatefulWidget{

  const Page3({
    super.key,
    required this.animate1,
    required this.animate2,
    required this.controller,
    required this.scaffoldContext
  });

  final bool animate1;
  final bool animate2;
  final PageController controller;
  final BuildContext scaffoldContext;

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  
  late final Ticker_pr tickReader;

  bool isKeyboardVisible = false;

  @override
  void initState() {
    tickReader = context.read<Ticker_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final h = Utils.screenHeightPercentage(context, 1);
    final w = Utils.screenWidthPercentage(context, 1);

    final bool isKeyboardVisible = MediaQuery.of(widget.scaffoldContext).viewInsets.bottom > 200;

    return Stack(
      children: [

        Align(child: animations[2]),
        
        Align(
          alignment: const Alignment(0.9,0.9),
          child: FloatingActionButton(
            onPressed: (){
              
              if(tickReader.value < 20){
                return;
              }
             
              final bool isValid = Utils.formKey.currentState!.validate();
             
              if(!isValid){
                return;
              }
        
              FocusManager.instance.primaryFocus?.unfocus();
              
              Utils.formKey.currentState!.save();
        
              tickReader.reset();
              widget.controller.animateToPage(3, duration: Durations.d300, curve: Curves.easeOutQuint);
            },
            child: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple,),
          )
        ),

        AnimatedAlign(

          duration: Durations.d300,
          curve: Curves.easeOut,
          alignment: Alignment(0, widget.animate2? -0.9: -0.8),
          
          child: AnimatedOpacity(

            opacity: widget.animate2? 1: 0,
            duration: Durations.d500,

            child: Text(
              '-- We take pride in your schedules.',
              style: TextStyles.b3(color: Colors.grey.shade300),
            ),
          )
        ),

        Positioned(

          top: h * 0.37,
          left: w * 0.33,

          child: AnimatedScale(

            scale: widget.animate1 && !isKeyboardVisible? 1: 0,
            duration: Durations.d1000,
            curve: Curves.elasticOut,

            child: RichText(
              text: TextSpan(
                
                children: [
                  TextSpan(
                    text: 'H',
                    style: TextStyles.h0(w * 0.16, color: Colors.blueGrey.shade800)
                  ),
                  TextSpan(
                    text: 'ere!',
                    style: TextStyles.h0(w * 0.12, color: Colors.blueGrey.shade800)
                  ),
                ]
              )
            ),
          ),
        ),

        Align(
          alignment: const Alignment(0, 0.15),
          child: AnimatedScale(

            scale: widget.animate2 && !isKeyboardVisible? 1: 0,
            duration: Durations.d500,
            curve: Curves.easeOutCirc,

            child: const Text(
              'Enter a name for your first Time Table.',
              style: TextStyles.h5,
            ),
          ),
        ),

        AnimatedScale(

          duration: Durations.d2000,
          curve: Curves.elasticOut,
          scale: widget.animate2? 1: 0,

          child: Align(
            
            alignment: const Alignment(0, 0.4),
            
            child: SizedBox(
            
              height: 120,
              width: 260,

              child: TextFormField(
               
                initialValue: firstTableTitle,
                decoration: Decorations.onboardingTextField(w, h),
                
                onSaved: (value) {
                  firstTableTitle = value ?? '';
                },
                onFieldSubmitted: (val){
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                validator: (name) {
                  if(name == null || name == ''){
                    return 'Title must not be empty.';
                  }
                  return null;
                },
              ),
            )
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class Page4 extends StatefulWidget{
  const Page4({
    super.key,
    required this.animate1,
    required this.animate2,
    required this.controller
  });

  final bool animate1;
  final bool animate2;
  final PageController controller;

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  
  late final Table_pr tableReader;
  late final Ticker_pr tickReader;

  @override
  void initState() {

    tableReader = context.read<Table_pr>();

    tickReader = context.read<Ticker_pr>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final w = Utils.screenWidthPercentage(context, 1);
    final h = Utils.screenHeightPercentage(context, 1);

    return Stack(
      children: [

        animations[3],

        Align(
          alignment: const Alignment(0,0.9),
          
          child: FloatingActionButton.extended(
            
            label: const Text(
              'Get Started!',
              style: TextStyles.b0,
            ),
            onPressed: () async {
              
              if(tickReader.value < 20){
                return;
              }

              //Add the first timetable to provider and local database.
              tableReader.addTable(
                await LocalDatabase.instance.addTimeTable(TimeTable(title: firstTableTitle))
              );

              // tickReader.reset();
              // widget.controller.animateToPage(0, duration: Durations.d300, curve: Curves.easeOutQuint);
            },
          ),
        ),

        AnimatedAlign(

          duration: Durations.d300,
          curve: Curves.easeOut,
          alignment: Alignment(0, widget.animate2? -0.9: -0.8),
          
          child: AnimatedOpacity(

            opacity: widget.animate2? 1: 0,
            duration: Durations.d500,

            child: Text(
              '-- Spend time to save some.',
              style: TextStyles.b3(color: Colors.grey.shade300),
            ),
          )
        ),

        Align(
          child: AnimatedScale(

            scale: widget.animate1? 1: 0,
            duration: Durations.d800,
            curve: Curves.easeOutCirc,

            child: RichText(
              text: TextSpan(
                
                children: [
                  TextSpan(
                    text: 'R',
                    style: TextStyles.h0(w * 0.16)
                  ),
                  TextSpan(
                    text: 'eady',
                    style: TextStyles.h0(w * 0.12)
                  ),
                ]
              )
            ),
          ),
        ),

        AnimatedScale(

          scale: widget.animate2? 1: 0,
          duration: Durations.d500,
          curve: Curves.easeOutCirc,

          child: Align(
            alignment: const Alignment(0, 0.15),
            child: Text(
              'To  Go',
              style: TextStyles.h0(w * 0.07),
            ),
          ),
        ),

        Align(
          alignment: const Alignment(0.6, 0.04),
          child: AnimatedScale(

            duration: Durations.d1000,
            curve: Curves.elasticOut,
            scale: widget.animate1? 1: 0,

            child: Text(
              '!',
              style: TextStyles.h0(w * 0.25),
            ),
          )
        ),

        AnimatedAlign(

          duration: Durations.d300,
          curve: Curves.easeOut,
          alignment: Alignment(widget.animate2? 0: 1, 0.5),

          child: AnimatedOpacity(

            duration: Durations.d500,
            opacity: widget.animate2? 1: 0,

            child: SizedBox(

              width: w * 0.75,
              child: const Text(
                'Let\'s go, the clock is ticking.\nNavigate through the app and have a little fun.',
                style: TextStyles.h5,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class BackgroundBlob extends StatelessWidget {
  const BackgroundBlob({
    super.key,
    required this.radius,
    required this.center
  });

  final double radius;
  final AlignmentGeometry center;

  @override
  Widget build(BuildContext context) {
    return Container(

      width: radius * 2,
      height: radius * 2,

      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(radius),
        gradient: Gradients.backgroundBlob(center)
      ),
    );  
  }
}


















// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:provider/provider.dart';
// import 'package:timetable_app/Globals/Providers.dart';
// import 'package:timetable_app/Globals/Utils.dart';
// import 'package:timetable_app/Globals/enums.dart';


// List<Widget> pages = [
//   const Page1(),
//   const Page2()
// ];

// late final Timer timer;

// int currentPage = 0;

// class CreateFirstTableScreen extends StatefulWidget{
//   const CreateFirstTableScreen({super.key});


//   @override
//   State<CreateFirstTableScreen> createState() => _CreateFirstTableScreenState();
// }

// class _CreateFirstTableScreenState extends State<CreateFirstTableScreen> {

//   late final Ticker_pr tickReader;

//   @override
//   void initState() {

//     tickReader = context.read<Ticker_pr>();

//     timer = Timer.periodic(Durations.d100, (timer) {
//       tickReader.increment();
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {

//     final Ticker_pr tickWatch = context.watch<Ticker_pr>();

//     final h = Utils.screenHeightPercentage(context, 1);
//     final w = Utils.screenWidthPercentage(context, 1);

//     return SafeArea(

//       child: Scaffold(

//         floatingActionButton: Padding(
//           padding: const EdgeInsets.only(left: 40, bottom: 20),
//           child: Row(
//             children: [
              
//               AnimatedScale(

//                 duration: Durations.d300,
//                 curve: Curves.easeOutQuint,
//                 scale: currentPage == 1? 1: 0,

//                 child: FloatingActionButton(
//                   heroTag: 'btn-back',
//                   onPressed: (){
//                     tickReader.reset();
//                     setState(() {
//                       currentPage = 0;
//                     });
//                   },
//                   child: const Icon(Icons.arrow_back_ios_new, color: Colors.deepPurple,),
//                 ),
//               ),

//               const Spacer(),

//               FloatingActionButton(
//                 onPressed: (){
//                   tickReader.reset();
//                   setState(() {
//                     switch(currentPage){
//                       case 0:
//                       currentPage = 1;
//                       break;
//                       case 1:
//                       currentPage = 2;
//                       break;
//                       // case 2:
//                     }
//                   });
//                 },
//                 child: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple,),
//               ),
//             ],
//           ),
//         ),
      
//         body: Container(
          
//           width: w,
//           decoration: const BoxDecoration(
//             gradient: RadialGradient(
//               colors: [Color.fromRGBO(103, 58, 183, 1), Color.fromRGBO(69, 39, 160, 1)],
//               center: Alignment(0.85, 0.9),
//               radius: 3
//             )
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 40),
          
//           child: pages[currentPage],
//           // child: Stack(
//           //   clipBehavior: Clip.none,
//           //   children: [

//           //     Positioned(
//           //       top: h * 0.3,
//           //       child: Transform(
//           //         transform: Matrix4.rotationZ(0.2),
//           //         child: const Icon(Icons.menu_book, size: 150, color: Color.fromRGBO(255, 255, 255, 0.3),)
//           //       )
//           //     ),
//           //     Positioned(
//           //       bottom: h * 0.25,
//           //       left: w * 0.7,
//           //       child: Transform(
//           //         transform: Matrix4.rotationZ(0.7),
//           //         child: const Icon(Icons.my_library_books_outlined, size: 120, color: Color.fromRGBO(255, 255, 255, 0.3),)
//           //       )
//           //     ),

//           //     pages[currentPage],
//           //   ],
//           // )
//         )
//       ),
//     );
//   }
// }

// // ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// // class Page2 extends StatelessWidget {
// //   const Page2({
// //     Key? key,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
    
// //       crossAxisAlignment: CrossAxisAlignment.center,
    
// //       children: [

// //         Spaces.vertical60,
    
// //         SizedBox(
// //           height: 24,
// //           child: ticker > 10
// //           ? AnimatedTextKit(
// //             totalRepeatCount: 1,
// //             animatedTexts: [
// //               TypewriterAnimatedText(
// //                 'Respect the abstract.',
// //                 speed: Durations.d50,
// //                 textStyle: const TextStyle(
// //                   color: TextStyles.b5pacing: 0.8
// //                 ),
// //               )
// //             ]
// //           )
// //           : null
// //         ),

// //         const Divider(endIndent: 2, height: 30, color: Color.fromRGBO(255, 255, 255, 0.8),),
        
// //         const Spacer(flex: 3,),
    
// //         AnimatedPadding(

// //           duration: Durations.d300,
// //           padding: EdgeInsets.only(left: ticker > 2? 0: 40),

// //           child: AnimatedOpacity(
            
// //             opacity: ticker > 2 ? 1:0,
// //             duration: Durations.d400,
        
// //             child: const Text(
// //               'WELCOME!',
// //               style: TextStyle(
// //                 fontSize: 46,
// //                 letterSpacing: 1.5,
// //                 fontWeight: FontWeight.bold,
// //                 color: Color.fromRGBO(255, 255, 255, 1)
// //               )
// //             ),
// //           ),
// //         ),
    
// //         AnimatedPadding(

// //           duration: Durations.d300,
// //           padding: EdgeInsets.only(left: ticker > 6? 0: 40),

// //           child: AnimatedOpacity(
            
// //             opacity: ticker > 6 ? 1:0,
// //             duration: Durations.d400,
// //             child: const Text(
// //               'To Timerz',
// //               style: TextStyle(
// //                 color: Color.fromRGBO(255,255,255,0.8),
// //                 letterSpacing: 1.2,
// //                 fontSize: 20,
// //                 height: 1.3,
// //                 fontWeight: FontWeight.w600,
// //               )
// //             ),
// //           ),
// //         ),
    
// //         Spaces.vertical20,
    
// //         AnimatedPadding(

// //           duration: Durations.d300,
// //           padding: EdgeInsets.only(left: ticker > 6? 0: 40),

// //           child: AnimatedOpacity(
        
// //             duration: Durations.d400,
// //             opacity: ticker > 6? 1: 0,
        
// //             child: const Text(
// //               'Build your own time table',
// //               style: TextStyle(
// //                 color: Color.fromRGBO(255,255,255,0.7),
// //                 fontSize: 18,
// //                 letterSpacing: 1,
// //                 wordSpacing: 1,
// //                 fontWeight: FontWeight.w500
// //               ),
// //             ),
// //           ),
// //         ),
    
// //         const Spacer(flex: 1),
    
// //         AnimatedPadding(

// //           duration: Durations.d300,
// //           padding: EdgeInsets.only(left: ticker > 2? 0: 40),

// //           child: AnimatedOpacity(
        
// //             duration: Durations.d400,
// //             opacity: ticker > 2? 1: 0,
        
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 const Text(
// //                   'Let\'s start without ',
// //                   style: TextStyle(
// //                     color: Color.fromRGBO(255, 255, 255, 0.9),
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.w600,
// //                     letterSpacing: 1,
// //                   ),
// //                 ),
                
// //                 DefaultTextStyle(
// //                   style: const TextStyle(
// //                     color: Color.fromRGBO(255, 255, 255, 0.9),
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.w600,
// //                     letterSpacing: 1,
// //                   ),
// //                   child: AnimatedTextKit(
// //                     repeatForever: true,
// //                     animatedTexts: [
// //                       WavyAnimatedText('waiting')
// //                     ]
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),


// //         AnimatedPadding(

// //           duration: Durations.d300,
// //           padding: EdgeInsets.only(left: ticker > 2? 0: 40),

// //           child: AnimatedOpacity(
        
// //             duration: Durations.d400,
// //             opacity: ticker > 2? 1: 0,
        
// //             child: const Text(
// //               ' any furthur.',
// //               style: TextStyle(
// //                 color: Color.fromRGBO(255, 255, 255, 0.9),
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.w600,
// //                 letterSpacing: 1,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //           )
// //         ),

// //         const Spacer(flex: 4,)
// //       ],
// //     );
// //   }
// // }

// // ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// // class Page1 extends StatelessWidget {
// //   const Page1({
// //     Key? key,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {

// //     return Column(
    
// //       crossAxisAlignment: CrossAxisAlignment.center,
    
// //       children: [

// //         Spaces.vertical60,
    
// //         SizedBox(
// //           height: 24,
// //           child: ticker > 10
// //           ? AnimatedTextKit(
// //             totalRepeatCount: 1,
// //             animatedTexts: [
// //               TypewriterAnimatedText(
// //                 'We take pride in your schedules.',
// //                 speed: Durations.d50,
// //                 textStyle: const TextStyle(
// //                   color: TextStyles.b5pacing: 0.8
// //                 ),
// //               )
// //             ]
// //           )
// //           : null
// //         ),

// //         const Divider(endIndent: 2, height: 30, color: Color.fromRGBO(255, 255, 255, 0.8),),
        
// //         const Spacer(flex: 3,),
    
// //         AnimatedPadding(

// //           duration: Durations.d300,
// //           padding: EdgeInsets.only(left: ticker > 2? 0: 40),

// //           child: AnimatedOpacity(
            
// //             opacity: ticker > 2 ? 1:0,
// //             duration: Durations.d400,
        
// //             child: const Text(
// //               'WELCOME!',
// //               style: TextStyle(
// //                 fontSize: 46,
// //                 letterSpacing: 1.5,
// //                 fontWeight: FontWeight.bold,
// //                 color: Color.fromRGBO(255, 255, 255, 1)
// //               )
// //             ),
// //           ),
// //         ),
    
// //         AnimatedPadding(

// //           duration: Durations.d300,
// //           padding: EdgeInsets.only(left: ticker > 6? 0: 40),

// //           child: AnimatedOpacity(
            
// //             opacity: ticker > 6 ? 1:0,
// //             duration: Durations.d400,
// //             child: const Text(
// //               'To Timerz',
// //               style: TextStyle(
// //                 color: Color.fromRGBO(255,255,255,0.8),
// //                 letterSpacing: 1.2,
// //                 fontSize: 20,
// //                 height: 1.3,
// //                 fontWeight: FontWeight.w600,
// //               )
// //             ),
// //           ),
// //         ),
    
// //         Spaces.vertical20,
    
// //         AnimatedPadding(

// //           duration: Durations.d300,
// //           padding: EdgeInsets.only(left: ticker > 6? 0: 40),

// //           child: AnimatedOpacity(
        
// //             duration: Durations.d400,
// //             opacity: ticker > 6? 1: 0,
        
// //             child: const Text(
// //               'Build your own time table',
// //               style: TextStyle(
// //                 color: Color.fromRGBO(255,255,255,0.7),
// //                 fontSize: 18,
// //                 letterSpacing: 1,
// //                 wordSpacing: 1,
// //                 fontWeight: FontWeight.w500
// //               ),
// //             ),
// //           ),
// //         ),
    
// //         const Spacer(flex: 1),
    
// //         AnimatedPadding(

// //           duration: Durations.d300,
// //           padding: EdgeInsets.only(left: ticker > 2? 0: 40),

// //           child: AnimatedOpacity(
        
// //             duration: Durations.d400,
// //             opacity: ticker > 2? 1: 0,
        
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 const Text(
// //                   'Let\'s start without ',
// //                   style: TextStyle(
// //                     color: Color.fromRGBO(255, 255, 255, 0.9),
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.w600,
// //                     letterSpacing: 1,
// //                   ),
// //                 ),
// //                 DefaultTextStyle(
// //                   style: const TextStyle(
// //                     color: Color.fromRGBO(255, 255, 255, 0.9),
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.w600,
// //                     letterSpacing: 1,
// //                   ),
// //                   child: AnimatedTextKit(
// //                     repeatForever: true,
// //                     animatedTexts: [
// //                       WavyAnimatedText('waiting')
// //                     ]
// //                   ),
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),


// //         AnimatedPadding(

// //           duration: Durations.d300,
// //           padding: EdgeInsets.only(left: ticker > 2? 0: 40),

// //           child: AnimatedOpacity(
        
// //             duration: Durations.d400,
// //             opacity: ticker > 2? 1: 0,
        
// //             child: const Text(
// //               ' any furthur.',
// //               style: TextStyle(
// //                 color: Color.fromRGBO(255, 255, 255, 0.9),
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.w600,
// //                 letterSpacing: 1,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //           )
// //         ),

// //         const Spacer(flex: 4,)
// //       ],
// //     );
// //   }
// // }