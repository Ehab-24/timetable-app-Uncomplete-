
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Globals/Providers.dart';
import '../../Widgets/LinearFlowFAB.dart';
import 'HomeBody.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(

      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home_bk.jpg'),
          fit: BoxFit.cover
        ),
      ),

      child: Scaffold(

        backgroundColor: Colors.transparent,
      
        body: HomeBody(homeTable: Provider.of<Table_pr>(context).tables[0]),

        floatingActionButton: const LinearFlowFAB(),
      ),
    );
  }
}
