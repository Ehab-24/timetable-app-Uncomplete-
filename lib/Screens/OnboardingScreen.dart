import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    fit: BoxFit.fitWidth,
  ),
  RiveAnimation.asset(
    'assets/rive/timetable_app_onBoarding.riv',
    artboard: 'page2',
    fit: BoxFit.fitWidth,
  ),
  RiveAnimation.asset(
    'assets/rive/timetable_app_onBoarding.riv',
    artboard: 'page3',
    fit: BoxFit.fitWidth,
  ),
  RiveAnimation.asset(
    'assets/rive/timetable_app_onBoarding.riv',
    artboard: 'page4',
    fit: BoxFit.fitWidth,
  ),
];

String firstTableTitle = '';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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

    Ticker_pr tickWatch = context.watch<Ticker_pr>();

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          body: DecoratedBox(
            decoration: Decorations.firstTableScreenImage,
            child: Container(
                width: w,
                decoration: Decorations.firstTableScreenGradient,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Form(
                      key: Utils.formKey,
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Page1(
                            animate1: tickWatch.value > 10,
                            animate2: tickWatch.value > 15,
                            controller: pageController,
                          ),
                          Page2(
                            animate1: tickWatch.value > 10,
                            animate2: tickWatch.value > 15,
                            controller: pageController,
                            scaffoldContext: context,
                          ),
                          Page3(
                            animate1: tickWatch.value > 10,
                            animate2: tickWatch.value > 13,
                            controller: pageController,
                            scaffoldContext: context,
                          ),
                          Page4(
                            animate1: tickWatch.value > 10,
                            animate2: tickWatch.value > 15,
                            controller: pageController,
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Page1 extends StatefulWidget {
  const Page1(
      {super.key,
      required this.animate1,
      required this.animate2,
      required this.controller});

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
              onPressed: _onPressedNext,
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.deepPurple,
              ),
            )),
        Positioned(
          top: h * 0.16,
          left: w * 0.2,
          child: _Page1WelcomeHeader(animate: widget.animate1),
        ),
        Positioned(
            right: w * 0.235,
            top: h * 0.45,
            child: _Page1TimerzHeader(animate: widget.animate1)),
        Positioned(
          top: h * 0.55,
          left: w * 0.21,
          child: SizedBox(
            width: w * 0.4,
            child: _Page1BodyText1(animate: widget.animate2),
          ),
        ),
        Positioned(
          top: h * 0.75,
          left: w * 0.21,
          child: SizedBox(
            width: w * 0.4,
            child: _Page1BodyText2(
              animate: widget.animate2,
            ),
          ),
        )
      ],
    );
  }

  void _onPressedNext() {
    if (tickReader.value < 20) {
      return;
    }
    tickReader.reset();
    widget.controller.animateToPage(1,
        duration: Durations.d300, curve: Curves.easeOutQuint);
  }
}

class _Page1WelcomeHeader extends StatelessWidget {
  const _Page1WelcomeHeader({Key? key, required this.animate})
      : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {
    final w = Utils.screenWidthPercentage(context, 1);

    return AnimatedScale(
      scale: animate ? 1 : 0,
      duration: Durations.d1000,
      curve: Curves.elasticOut,
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: 'W',
              style: TextStyles.h0(w * 0.16, color: Colors.blueGrey.shade800)),
          TextSpan(
              text: 'elcome',
              style: TextStyles.h0(w * 0.12, color: Colors.blueGrey.shade800)),
        ]),
      ),
    );
  }
}

class _Page1TimerzHeader extends StatelessWidget {
  const _Page1TimerzHeader({Key? key, required this.animate}) : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {
    final w = Utils.screenWidthPercentage(context, 1);

    return AnimatedScale(
      scale: animate ? 1 : 0,
      duration: Durations.d1000,
      curve: Curves.elasticOut,
      child: ArcText(
          text: 'Timerz',
          startAngle: -pi / 2.2,
          radius: w * 0.1,
          textStyle: TextStyles.h0(w * 0.07, color: Colors.blueGrey.shade800)),
    );
  }
}

class _Page1BodyText1 extends StatelessWidget {
  const _Page1BodyText1({
    Key? key,
    required this.animate,
  }) : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: animate ? 1 : 0,
      duration: Durations.d500,
      child: Text(
          'Welcome to Timerz! A simple app to make the experince of working with time tables easy and friendly.',
          style: TextStyles.b5(const Color.fromRGBO(224, 224, 224, 1))),
    );
  }
}

class _Page1BodyText2 extends StatelessWidget {
  const _Page1BodyText2({
    Key? key,
    required this.animate,
  }) : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: animate ? 1 : 0,
      duration: Durations.d500,
      child: Text('Build your own time table and let Timerz handle the rest.',
          style: TextStyles.b5(const Color.fromRGBO(224, 224, 224, 1))),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Page2 extends StatefulWidget {
  const Page2(
      {super.key,
      required this.animate1,
      required this.animate2,
      required this.controller,
      required this.scaffoldContext});

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

    final bool isKeyboardVisible =
        MediaQuery.of(widget.scaffoldContext).viewInsets.bottom > 200;

    return Stack(
      children: [
        animations[1],
        Align(
            alignment: const Alignment(0.9, 0.9),
            child: FloatingActionButton(
              onPressed: _onPressedNext,
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.deepPurple,
              ),
            )),
        Align(
            alignment: const Alignment(-0.86, 0.9),
            child: FloatingActionButton(
              heroTag: 'back-btn',
              onPressed: _onPressedBack,
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.deepPurple,
              ),
            )),
        Positioned(
          top: isKeyboardVisible ? h * 0.21 : h * 0.4,
          right: w * 0.16,
          child: _Page2NameText(
            animate: widget.animate1,
          ),
        ),
        Positioned(
            top: isKeyboardVisible ? h * 0.34 : h * 0.53,
            right: w * 0.1,
            child: SizedBox(
              height: 100,
              width: 200,
              child: TextFormField(
                initialValue: '',
                style: TextStyles.bUltra(Colors.blueGrey.shade800),
                maxLength: 10,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                decoration: Decorations.textFieldBold(
                    hint: '',
                    errorColor: Colors.red.shade100,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: w * 0.03, vertical: h * 0.05)),
                onSaved: (value) {
                  Prefs.setUsername(value?.trim() ?? '');
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onFieldSubmitted: (val) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                validator: (name) {
                  if (name == null || name == '') {
                    return 'Name can not be empty.';
                  }
                  return null;
                },
                buildCounter: ((context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) =>
                    Container(
                      transform: Matrix4.translationValues(16, -114, 0),
                      child: Text(
                        '$currentLength/$maxLength',
                        style: TextStyles.toast(Colors.blueGrey.shade800),
                      ),
                    )),
              ),
            )),
        _Page2HeaderQuote(
          animate: widget.animate2,
          isKeyboardVisible: isKeyboardVisible,
        ),
      ],
    );
  }

  void _onPressedNext() {
    if (tickReader.value < 20) {
      return;
    }
    bool isValid = Utils.formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    Utils.formKey.currentState!.save();
    FocusManager.instance.primaryFocus?.unfocus();

    tickReader.reset();
    widget.controller
        .animateToPage(2, duration: Durations.d300, curve: Curves.easeOutQuint);
  }

  void _onPressedBack() {
    if (tickReader.value < 20) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    tickReader.reset();
    widget.controller
        .animateToPage(0, duration: Durations.d300, curve: Curves.easeOutQuint);
  }
}

class _Page2NameText extends StatelessWidget {
  const _Page2NameText({
    Key? key,
    required this.animate,
  }) : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {
    final w = Utils.screenWidthPercentage(context, 1);

    return AnimatedScale(
      scale: animate ? 1 : 0,
      duration: Durations.d1000,
      curve: Curves.elasticOut,
      child: RichText(
          text: TextSpan(children: [
        TextSpan(text: 'N', style: TextStyles.h0(w * 0.15)),
        TextSpan(text: 'ame?', style: TextStyles.h0(w * 0.1)),
      ])),
    );
  }
}

class _Page2HeaderQuote extends StatelessWidget {
  const _Page2HeaderQuote(
      {Key? key, required this.animate, required this.isKeyboardVisible})
      : super(key: key);

  final bool animate, isKeyboardVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: Durations.d300,
      curve: Curves.easeOut,
      alignment: Alignment(0, animate ? -0.9 : -0.8),
      child: AnimatedOpacity(
        opacity: animate && !isKeyboardVisible ? 1 : 0,
        duration: Durations.d500,
        child: Text('-- Respect the abstract.',
            style: TextStyles.b3(Colors.grey.shade300)),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Page3 extends StatefulWidget {
  const Page3(
      {super.key,
      required this.animate1,
      required this.animate2,
      required this.controller,
      required this.scaffoldContext});

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

    final bool isKeyboardVisible =
        MediaQuery.of(widget.scaffoldContext).viewInsets.bottom > 200;

    return Stack(
      children: [
        Align(child: animations[2]),
        Align(
            alignment: const Alignment(0.9, 0.9),
            child: FloatingActionButton(
              onPressed: () {
                if (tickReader.value < 20) {
                  return;
                }
                final bool isValid = Utils.formKey.currentState!.validate();
                if (!isValid) {
                  return;
                }
                FocusManager.instance.primaryFocus?.unfocus();
                Utils.formKey.currentState!.save();

                tickReader.reset();
                widget.controller.animateToPage(3,
                    duration: Durations.d300, curve: Curves.easeOutQuint);
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.deepPurple,
              ),
            )),
        Align(
            alignment: const Alignment(-0.86, 0.9),
            child: FloatingActionButton(
              heroTag: 'back-btn',
              onPressed: () {
                if (tickReader.value < 20) {
                  return;
                }
                FocusManager.instance.primaryFocus?.unfocus();

                tickReader.reset();
                widget.controller.animateToPage(1,
                    duration: Durations.d300, curve: Curves.easeOutQuint);
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.deepPurple,
              ),
            )),
        AnimatedAlign(
            duration: Durations.d300,
            curve: Curves.easeOut,
            alignment: Alignment(0, widget.animate2 ? -0.9 : -0.8),
            child: AnimatedOpacity(
              opacity: widget.animate2 ? 1 : 0,
              duration: Durations.d500,
              child: Text(
                '-- We take pride in your schedules.',
                style: TextStyles.b3(Colors.grey.shade300),
              ),
            )),
        Positioned(
          top: isKeyboardVisible ? h * 0.16 : h * 0.37,
          left: w * 0.33,
          child: AnimatedScale(
            scale: widget.animate1 ? 1 : 0,
            duration: Durations.d1000,
            curve: Curves.elasticOut,
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'H',
                  style:
                      TextStyles.h0(w * 0.16, color: Colors.blueGrey.shade800)),
              TextSpan(
                  text: 'ere!',
                  style:
                      TextStyles.h0(w * 0.12, color: Colors.blueGrey.shade800)),
            ])),
          ),
        ),
        Align(
          alignment: const Alignment(0, 0.15),
          child: AnimatedScale(
            scale: widget.animate2 && !isKeyboardVisible ? 1 : 0,
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
          scale: widget.animate2 ? 1 : 0,
          child: Align(
              alignment: const Alignment(0, 0.5),
              child: SizedBox(
                height: 120,
                width: 320,
                child: TextFormField(
                  initialValue: firstTableTitle,
                  decoration: Decorations.textFieldBold(
                      hint: '',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: w * 0.03, vertical: h * 0.05)),
                  maxLength: 20,
                  style: TextStyles.bUltra(Colors.blueGrey.shade800),
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  onSaved: (title) {
                    firstTableTitle = title ?? '';
                  },
                  onFieldSubmitted: (val) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  validator: (title) {
                    if (title == null || title == '') {
                      return 'Title must not be empty.';
                    }
                    return null;
                  },
                  buildCounter: ((context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) =>
                      Container(
                        transform: Matrix4.translationValues(16, -134, 0),
                        child: Text(
                          '$currentLength/$maxLength',
                          style: TextStyles.toast(Colors.blueGrey.shade800),
                        ),
                      )),
                ),
              )),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Page4 extends StatefulWidget {
  const Page4(
      {super.key,
      required this.animate1,
      required this.animate2,
      required this.controller});

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

    return Stack(
      children: [
        animations[3],
        Align(
          alignment: const Alignment(0, 0.85),
          child: FloatingActionButton.extended(
            label: const Text(
              'Get Started!',
              style: TextStyles.b0,
            ),
            onPressed: () async {
              if (tickReader.value < 20) {
                return;
              }
              //Add the first timetable to provider and local database.
              tableReader.addTable(await LocalDatabase.instance.addTimeTable(
                  TimeTable(
                      title: firstTableTitle, lastModified: DateTime.now())));
              Prefs.setDateCreated(DateTime.now());
            },
            backgroundColor: Colors.white,
          ),
        ),
        AnimatedAlign(
            duration: Durations.d300,
            curve: Curves.easeOut,
            alignment: Alignment(0, widget.animate2 ? -0.9 : -0.8),
            child: AnimatedOpacity(
              opacity: widget.animate2 ? 1 : 0,
              duration: Durations.d500,
              child: Text(
                '-- Spend time to save some.',
                style: TextStyles.b3(Colors.grey.shade300),
              ),
            )),
        Align(
          child: AnimatedScale(
            scale: widget.animate1 ? 1 : 0,
            duration: Durations.d800,
            curve: Curves.easeOutCirc,
            child: RichText(
                text: TextSpan(children: [
              TextSpan(text: 'R', style: TextStyles.h0(w * 0.16)),
              TextSpan(text: 'eady', style: TextStyles.h0(w * 0.12)),
            ])),
          ),
        ),
        AnimatedScale(
          scale: widget.animate2 ? 1 : 0,
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
              scale: widget.animate1 ? 1 : 0,
              child: Text(
                '!',
                style: TextStyles.h0(w * 0.25),
              ),
            )),
        AnimatedAlign(
            duration: Durations.d300,
            curve: Curves.easeOut,
            alignment: Alignment(widget.animate2 ? 0 : 1, 0.5),
            child: AnimatedOpacity(
              duration: Durations.d500,
              opacity: widget.animate2 ? 1 : 0,
              child: SizedBox(
                width: w * 0.75,
                child: const Text(
                  'Let\'s go, the clock is ticking.\nNavigate through the app and have a little fun.',
                  style: TextStyles.h5,
                  textAlign: TextAlign.center,
                ),
              ),
            )),
      ],
    );
  }
}
