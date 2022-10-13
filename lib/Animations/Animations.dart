
// import 'package:flutter/material.dart';
// import 'package:simple_animations/animation_builder/play_animation_builder.dart';
// import 'package:simple_animations/movie_tween/movie_tween.dart';
// import 'package:timetable_app/Globals/enums.dart';

// class FadeIn extends StatelessWidget{

//   final double delay;
//   final Widget child;

//   const FadeIn(this.delay, this.child);

//   @override
//   Widget build(BuildContext context) {
    
//     // final tween = MovieTween()
//     // ..tween('opacity', Tween(begin: 0.0, end: 1.0),
//     //   duration: Durations.d500)
//     // ..tween('x', Tween(begin: 130, end: 0),
//     //   duration: Durations.d500, curve: Curves.decelerate);

//     return PlayAnimationBuilder<double>(
//       delay: Duration(milliseconds: delay.round()),
//       tween: Tween<double>(begin: 0, end: 1), 
//       duration: Durations.d500,
//       curve: Curves.easeOut,
//       builder: ((context, value, child) => 
//         Opacity(
//           opacity: value,
//           child: child,
//         )
//       ),
//       child: child,
//     );
//   }
// }