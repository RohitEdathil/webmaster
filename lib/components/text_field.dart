import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String label;
  final bool large;
  final String? Function(String?) validator;
  final String? current;
  CustomField(
      {required this.label,
      this.large = false,
      required this.validator,
      this.current});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      child: TextFormField(
        validator: validator,
        controller: TextEditingController(text: current),
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

class TypeChooser extends StatelessWidget {
  final Function(int?) validator;
  final int current;
  TypeChooser({required this.validator, required this.current});
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
            'Type',
            style: Theme.of(context).textTheme.headline6,
          ),
          Divider(),
          RadioListTile(
            groupValue: current,
            onChanged: validator,
            activeColor: Theme.of(context).accentColor,
            value: 0,
            title: Text('Event'),
          ),
          RadioListTile(
            groupValue: current,
            onChanged: validator,
            activeColor: Theme.of(context).accentColor,
            value: 1,
            title: Text('Webinar'),
          ),
          RadioListTile(
            groupValue: current,
            onChanged: validator,
            activeColor: Theme.of(context).accentColor,
            value: 2,
            title: Text('Competition'),
          ),
          RadioListTile(
            groupValue: current,
            onChanged: validator,
            activeColor: Theme.of(context).accentColor,
            value: 3,
            title: Text('Post'),
          ),
        ],
      ),
    );
  }
}

class StateChooser extends StatelessWidget {
  final Function(int?) validator;
  final int current;
  StateChooser({required this.validator, required this.current});
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
