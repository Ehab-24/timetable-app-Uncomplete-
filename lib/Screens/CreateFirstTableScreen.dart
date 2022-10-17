
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/TimeTable.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
import 'package:timetable_app/Globals/Providers.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';

class CreateFirstTableScreen extends StatefulWidget{
  const CreateFirstTableScreen({super.key});


  @override
  State<CreateFirstTableScreen> createState() => _CreateFirstTableScreenState();
}

class _CreateFirstTableScreenState extends State<CreateFirstTableScreen> {
  late final PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
    
        controller: controller,
        children: [
          Page1(),
          Page2()
        ]
      ),
    );
  }
}

class Page1 extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purpleAccent,
      alignment: Alignment.center,
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Welcome\n',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w600,
                letterSpacing: 1
              )
            ),
            TextSpan(
              text: 'We will get you started!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.2,
                height: 10,
                fontStyle: FontStyle.italic
              )
            ),
          ]
        )
      ),
    );
  }
}



class Page2 extends StatefulWidget{

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {

  String title = '';
  late final Screen_pr screenReader;
  late final Table_pr tableReader;

  @override
  void initState() {
    tableReader =  context.read<Table_pr>();
    screenReader = context.read<Screen_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final double h = Utils.screenHeightPercentage(context, 1);

    return Container(
      
      color: Colors.amber,
      padding: const EdgeInsets.symmetric(horizontal: 40),

      child: Form(
        key: Utils.formKey,
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
        
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
        
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Here!\n',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    TextSpan(
                      text: 'Enter a name for your first Table.',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                        height: 6,
                        fontStyle: FontStyle.italic
                      )
                    ),
                  ]
                )
              ),
        
              Spaces.vertical80,
        
              TextFormField(
                decoration: const InputDecoration(
                  label: Icon(Icons.label),
                ),
                initialValue: title,
                onSaved: (title) {this.title = title ?? '';},
                validator: ((title){
                  if(title == null || title.isEmpty || title.length > 10){
                    return 'Title must be 1-10 characters long.';
                  }
                }),
              ),
        
              Spaces.vertical40,
        
              ElevatedButton(
                onPressed: () async {
                  Utils.formKey.currentState!.save();

                  await addTable();
                  screenReader.setScreen(Screens.home);
                }, 
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  elevation: 6
                ),
                child: const Icon(Icons.save, color: Colors.amberAccent,)
              ),
      
              Spaces.vertical(h * 0.1)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTable() async {
    final TimeTable newTable = await LocalDatabase.instance.addTimeTable(
      TimeTable(title: title)
    );
    tableReader.addTable(newTable);
  }
}