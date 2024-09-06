import 'package:flutter/material.dart';

import '../../../shared/size_config.dart';
class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: SizeConfig.safeBlockVertical * 92,
        width: SizeConfig.safeBlockHorizontal * 100,
        color: Colors.blue,
      ),
    );
  }
}
