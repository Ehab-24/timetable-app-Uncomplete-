
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Globals/Providers.dart';
import '../../Widgets/LinearFlowFAB.dart';
import 'HomeBody.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late final Screen_pr screenReader;

  @override
  void initState() {
    screenReader = context.read<Screen_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final double w = MediaQuery.of(context).size.width;

    return Container(

      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home_bk.jpg'),
          fit: BoxFit.cover
        ),
      ),

      child: const Scaffold(

        backgroundColor: Colors.transparent,
      
        // appBar: AppBar(
        //   title: const Text('Time Table', style: TextStyle(fontSize: 32),),
        //   centerTitle: true,
        //   toolbarHeight: w * 0.75,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //       bottomLeft: Radius.elliptical(w/2, 50),
        //       bottomRight: Radius.elliptical(w/2, 50),
        //     )
        //   ),
        // ),

        body: HomeBody(),

        floatingActionButton: LinearFlowFAB(),
      ),
    );
  }
}
