
import 'package:flutter/material.dart';
import 'package:timetable_app/Globals/Styles.dart';

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
        children: pages.map((page)
          => _Page(page: page,)).toList()
      ),
    );
  }
}

class _Page extends StatelessWidget{
  _Page({
    Key? key,
    required this.page
  }) : super(key: key);

  Page page;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: page.color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            page.title,
            style: TextStyles.h1,
          ),
          Text(
            page.content,
            style: TextStyles.b3,
          )
        ],
      ),
    );
  }
}


List<Page> pages = [
  Page(color: Colors.blue.shade700, title: 'Welcome', content: 'We will get you started!'),
  Page(color: Colors.amber, title: 'Here!', content: 'Enter the title for your first table.')
];

class Page{
  Color color;
  String title;
  String content;

  Page({
    required this.color,
    required this.content,
    required this.title
  });
}