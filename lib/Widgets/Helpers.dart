
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Databases/ServicesPref.dart';
import '../Globals/Decorations.dart';
import '../Globals/Providers.dart';
import '../Globals/Styles.dart';
import '../Globals/enums.dart';


class BackgroundText extends StatelessWidget {
  const BackgroundText({
    Key? key,
    required this.title,
    this.subtitle = ''
  }) : super(key: key);

  final String title, subtitle;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$title\n',
            style: TextStyles.bk2(color: Prefs.isDarkMode? Colors.white30: Colors.black12)
          ),
          TextSpan(
            text: subtitle,
            style: TextStyles.bk4(Prefs.isDarkMode? Colors.white54: Colors.black26)
          )
        ]
      ),
    );
  }
}


class BackgroundTextMini extends StatelessWidget {
  const BackgroundTextMini({
    Key? key,
    required this.title,
    this.subtitle = '',
    required this.color
  }) : super(key: key);

  final String title, subtitle;
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
              splashColor: colorWatch.splash,
              backgroundColor: colorWatch.onBackground,
              foregroundColor: colorWatch.foreground,
              tooltip: 'back',
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


class TextFieldBold extends StatelessWidget {
  const TextFieldBold({
    Key? key,
    required this.onChanged,
    this.initialValue,
    this.validator,
  }) : super(key: key);

  final String? initialValue;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return PhysicalModel(

      color: Colors.transparent,
      shadowColor: colorWatch.shadow,
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
        )
      ),
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

    return PhysicalModel(

      color: Colors.transparent,
      shadowColor: colorWatch.shadow_alt,
      elevation: 12,
      borderRadius: BorderRadius.circular(60),

      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
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