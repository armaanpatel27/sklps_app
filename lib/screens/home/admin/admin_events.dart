import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../shared/size_config.dart';
class AdminEvents extends StatefulWidget {
  const AdminEvents({Key? key}) : super(key: key);

  @override
  State<AdminEvents> createState() => _AdminEventsState();
}

class _AdminEventsState extends State<AdminEvents> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: SizeConfig.safeBlockVertical * 92,
        width: SizeConfig.safeBlockHorizontal * 100,
        child: TableCalendar(
          calendarFormat: CalendarFormat.month,
          firstDay: DateTime.utc(2023, 1, 1),
          focusedDay: DateTime.now(),
          lastDay: DateTime.utc(2024, 1, 1),
        ),
      ),
    );
  }
}
