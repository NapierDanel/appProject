import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    var planiantEvents = Provider.of<List<PlaniantEvent>>(context);

  }

}