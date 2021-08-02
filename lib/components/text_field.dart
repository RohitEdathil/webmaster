import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final label;
  final large;
  final validator;
  CustomField(
      {required this.label, this.large = false, required this.validator});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      child: TextFormField(
        validator: validator,
        minLines: large ? 20 : 1,
        maxLines: large ? 200 : 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelText: label,
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

class StateSlider extends StatelessWidget {
  final Function(int?) validator;
  final int current;
  StateSlider({required this.validator, required this.current});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Event Status',
            style: Theme.of(context).textTheme.headline6,
          ),
          Divider(),
          RadioListTile(
            groupValue: current,
            onChanged: validator,
            activeColor: Theme.of(context).accentColor,
            value: 0,
            title: Text('Registration Open'),
          ),
          RadioListTile(
            groupValue: current,
            onChanged: validator,
            activeColor: Theme.of(context).accentColor,
            value: 1,
            title: Text('Registration Closed'),
          ),
          RadioListTile(
            groupValue: current,
            onChanged: validator,
            activeColor: Theme.of(context).accentColor,
            value: 2,
            title: Text('Event Ended'),
          ),
        ],
      ),
    );
  }
}

class DateInput extends StatelessWidget {
  final Function(DateTime) validator;
  final DateTime current;
  DateInput({required this.validator, required this.current});
  void showDateDialog(BuildContext context) async {
    final selected = await showDatePicker(
        context: context,
        initialDate: current,
        firstDate: current.subtract(Duration(days: 365)),
        lastDate: current.add(Duration(days: 365)));
    validator(selected ?? current);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      padding: const EdgeInsets.all(20),
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Event Date', style: Theme.of(context).textTheme.subtitle1),
          VerticalDivider(),
          Text(
            "${current.year.toString()}-${current.month.toString().padLeft(2, '0')}-${current.day.toString().padLeft(2, '0')}",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          VerticalDivider(),
          IconButton(
              onPressed: () => showDateDialog(context),
              icon: Icon(Icons.date_range))
        ],
      ),
    );
  }
}
