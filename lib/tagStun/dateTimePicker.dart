import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  DateTimePicker(
      {Key key,
        this.labelText,
        this.selectDate,
        this.selectTime})
      : super(key: key);

  final String labelText;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  @override
  State<StatefulWidget> createState() => DateTimeState();
}

class DateTimeState extends State<DateTimePicker> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(1970, 8),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) {
      widget.selectDate(picked);
      setState(() =>
        selectedDate = picked
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
    await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime){
      widget.selectTime(picked);
      setState(() =>
        selectedTime = picked
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: widget.labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        new Expanded(
          flex: 3,
          child: new _InputDropdown(
            valueText: selectedTime.format(context),
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
        this.child,
        this.labelText,
        this.valueText,
        this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}