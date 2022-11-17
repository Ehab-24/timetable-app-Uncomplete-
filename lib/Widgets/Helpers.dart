
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Databases/ServicesPref.dart';
import '../Globals/Decorations.dart';
import '../Globals/Providers.dart';
import '../Globals/Styles.dart';
import '../Globals/Utils.dart';
import '../Globals/enums.dart';


class BackgroundText extends StatelessWidget {
  const BackgroundText({
    Key? key,
    required this.title,
    required this.color
  }) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title\n',
            style: TextStyles.bk2(color: color)
          ),
        ]
      ),
    );
  }
}


class BackgroundTextMini extends StatelessWidget {
  const BackgroundTextMini({
    Key? key,
    required this.title,
    required this.color
  }) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title\n',
            style: TextStyles.bk4(color)
          ),
        ]
      ),
    );
  }
}


class HorzDividerMini extends StatelessWidget {
  const HorzDividerMini({
    Key? key,
    this.color = Colors.pink
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      indent: 10, endIndent: 10,
      height: 40,
    );
  }
}

class HorzDivider extends StatelessWidget {
  const HorzDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(color: Colors.pink, indent: 20, endIndent: 20, thickness: 3, height: 120,);
  }
}

class VertDividerMini extends StatelessWidget {
  const VertDividerMini({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(thickness: 1, color: Colors.black54, indent: 55, endIndent: 55,);
  }
}


class AnimatedDualFAB extends StatelessWidget {
  const AnimatedDualFAB({
    Key? key,
    required this.onSave,
    required this.scaleSomparator
  }) : super(key: key);

  final VoidCallback onSave;
  final bool scaleSomparator;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 200;

    return Row(
      children: [
        
        AnimatedScale(

          duration: isKeyboardVisible? Durations.zero: Durations.d500,
          curve: Curves.easeOutQuint,
          scale: isKeyboardVisible? 0: 1,

          child: DecoratedBox(
          decoration: Decorations.FAB(colorWatch.foreground.withOpacity(0.5)),

            child: FloatingActionButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              elevation: 0,
              heroTag: 'main-btn',
              splashColor: colorWatch.splash,
              backgroundColor: colorWatch.onBackground,
              foregroundColor: colorWatch.foreground,
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
        ),

        const Spacer(),

        AnimatedScale(

          duration: Durations.d500,
          curve: Curves.easeOutQuint,
          scale: scaleSomparator? 0: 1,

          child: DecoratedBox(
            decoration: Decorations.FAB(colorWatch.foreground.withOpacity(0.5)),
            child: FloatingActionButton(
              heroTag: 'save-button',
              onPressed: onSave,
              tooltip: 'Save',
              elevation: 0,
              splashColor: colorWatch.splash,
              backgroundColor: colorWatch.onBackground,
              foregroundColor: colorWatch.foreground,
              child: const Icon(Icons.save_outlined),
            ),
          ),
        )
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class CustomSlider extends StatefulWidget{
  const CustomSlider({
    super.key,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.divisions,
    required this.initialValue,
  });

  final void Function(double)? onChanged;
  final double min, max;
  final int divisions, initialValue;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}
class _CustomSliderState extends State<CustomSlider> {

  late double value = widget.initialValue.toDouble();

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    const Color activeColor = Colors.pink;
    final Color inactiveColor = Prefs.isDarkMode
      ? Utils.lighten(colorWatch.background): Utils.darken(colorWatch.background);

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 8,
        
        thumbColor: activeColor,
        activeTrackColor: activeColor,
        activeTickMarkColor: activeColor,

        inactiveTrackColor: inactiveColor,
        inactiveTickMarkColor: inactiveColor,
        
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 12,
          disabledThumbRadius: 12,
        ),
        rangeThumbShape: const RoundRangeSliderThumbShape(
          enabledThumbRadius: 6,
          disabledThumbRadius: 6
        )
      ) ,
      child: buildSlider()
    );
  }

  Widget buildSlider(){

    return Slider(
      max: widget.max,
      min: widget.min,
      divisions: widget.divisions,
      value: value,
      onChanged: ((_value) { 
        setState(() {
          value = _value;
        });
        widget.onChanged;
      }),
    );
  }
}
///
class TimePicker extends StatefulWidget{
  const TimePicker({
    super.key,
  });

  @override
  State<TimePicker> createState() => _TimePickerState();
}
class _TimePickerState extends State<TimePicker> {
  
  final Color color = Colors.pink;
  final opacity = 0.5;
  bool isHourSelected = true;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return Dialog (

      backgroundColor: Colors.transparent,

      child: Container(
        
        margin: EdgeInsets.symmetric(horizontal: Utils.screenWidthPercentage(context, 0.04)),          
        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),  
        decoration: Decorations.decoratedContainer_alt(colorWatch.onBackground),
    
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: Icon(Icons.close, color: colorWatch.foreground, size: 28,),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Hours
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            isHourSelected = true;
                          });
                        },
                        child: Text(
                          'audh',
                          // widget.timeOfDay.hour.toString(),
                          style: TextStyles.h1(
                            isHourSelected? colorWatch.foreground: colorWatch.foreground.withOpacity(opacity)
                          ),
                        ),
                      ),
                      Spaces.horizontal10,
                      Text(
                        ':',
                        style: TextStyles.b1(colorWatch.foreground.withOpacity(opacity)),
                      ),
                      Spaces.horizontal10,
                      //Minute
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            isHourSelected = false;
                          });
                        },
                        child: Text(
                          'sifu',
                          // widget.timeOfDay.minute.toString(),
                          style: TextStyles.h1(
                            !isHourSelected? colorWatch.foreground: colorWatch.foreground.withOpacity(opacity)
                          ),
                        ),
                      )
                    ],
                  ),

                  Spaces.vertical20,

                  CustomSlider(
                    onChanged: ((value) => 
                      setState(() {
                        // isHourSelected
                        // ? widget.timeOfDay.replacing(hour: value.round())
                        // : widget.timeOfDay.replacing(minute: value.round());
                      })
                    ), 
                    min: 0, 
                    max: isHourSelected? 23: 59, 
                    divisions: isHourSelected? 24: 4, 
                    initialValue: 12,
                    // initialValue: isHourSelected? widget.timeOfDay.hour: widget.timeOfDay.minute
                  ),

                  Spaces.vertical20,

                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Ok',),
                  ),   
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class TextFieldBold extends StatelessWidget {
  const TextFieldBold({
    Key? key,
    required this.onChanged,
    this.initialValue,
    this.validator,
    this.maxLength,

  }) : super(key: key);

  final String? initialValue;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return PhysicalModel(

      color: Colors.transparent,
      shadowColor: maxLength == null
      ? colorWatch.shadow
      : Colors.transparent,
      elevation: 16,
      borderRadius: BorderRadius.circular(80),

      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        initialValue: initialValue,
        style: TextStyle(color: colorWatch.foreground),
        decoration: Decorations.textFieldBold(
          hint: '',
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          color: colorWatch.onBackground
        ),
        maxLength: maxLength,
        buildCounter: maxLength == null
        ? null
        : ((context, {required currentLength, required isFocused, maxLength}) => 
            Transform.translate(
              offset: const Offset(0, -140),
              child: Text(
                '$currentLength/$maxLength',
                style: TextStyles.toast(
                  colorWatch.foreground.withOpacity(0.75),
                  background: colorWatch.onBackground
                ),
              ),
            )
          ),
      ),
    );
  }
}


class SmallButton extends StatelessWidget{
  const SmallButton({
    super.key,
    required this.onTap,
    required this.width,
    required this.height,
    required this.icon,
    this.footer = '',
  });

  final double width, height;
  final Icon icon;
  final String footer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return Column(
      children: [

        PhysicalModel(
          color: Colors.transparent,
          shadowColor: Colors.black,
          elevation: 8,
          borderRadius: BorderRadius.circular(16),

          child: Material(
            type: MaterialType.transparency,
            
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              
              child: Ink(
                width: width,
                height: height,
                decoration: Decorations.smallButton,
                child: icon,
              ),
            ),
          ),
        ),

        Spaces.vertical(8),

        Text(
          footer,
          style: TextStyles.h8(colorWatch.background),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class LargeButton extends StatelessWidget {
  const LargeButton({
    Key? key,
    required this.onTap,
    required this.height,
    required this.width,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final double width, height;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    Color _splashColor = Prefs.isDarkMode? const Color.fromRGBO(55, 71, 79, 0.3): Colors.white30;

    return PhysicalModel(

      color: Colors.transparent,
      shadowColor: colorWatch.shadow_alt,
      elevation: 12,
      borderRadius: BorderRadius.circular(60),

      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          splashColor: _splashColor,
          highlightColor: _splashColor,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            
            width: width,
            height: height,
            decoration: Decorations.decoratedContainer,
            
            child: Stack(
              children: [

                Positioned(
                  right: -40,
                  bottom: -40,
                  child: Icon(icon, size: 160, color: Colors.black.withOpacity(0.06),)
                ),
                
                Align(child: Icon(icon, size: 40, color: colorWatch.onBackground.withOpacity(0.7),)),
                
                Spaces.vertical10,
                
                Align(
                  alignment: const Alignment(0, 0.4),
                  child: Text(
                    label,
                    style: TextStyles.h4(colorWatch.onBackground.withOpacity(0.7)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}