import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmaster/data/events.dart';

class UnlockPrompt extends StatefulWidget {
  const UnlockPrompt({Key? key}) : super(key: key);

  @override
  _UnlockPromptState createState() => _UnlockPromptState();
}

class _UnlockPromptState extends State<UnlockPrompt> {
  bool loading = false;
  bool error = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login(BuildContext context) {
    setState(() {
      loading = true;
      error = false;
      Provider.of<EventModel>(context, listen: false)
          .login(emailController.text, passwordController.text)
          .then((success) {
        if (success) {
          Navigator.of(context).pop();
        } else if (this.mounted) {
          setState(() {
            error = true;
            loading = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Write Access'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: Navigator.of(context).pop,
        ),
        TextButton(
          child: loading ? CircularProgressIndicator() : Text('Unlock'),
          onPressed: loading ? null : () => login(context),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Email ID'),
            controller: emailController,
            autofocus: true,
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(labelText: 'Password'),
            controller: passwordController,
            obscureText: true,
          ),
          if (error)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                'Unlock Failed',
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
            )
        ],
      ),
    );
  }
}

class LockPrompt extends StatelessWidget {
  const LockPrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Lock'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).primaryColor,
      content: Text('Do you really wish to lock Write Access?'),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: Navigator.of(context).pop,
        ),
        TextButton(
          child: Text('Confirm'),
          onPressed: () {
            Provider.of<EventModel>(context, listen: false).logout();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class ServerToggle extends StatelessWidget {
  final bool setTo;
  const ServerToggle({required this.setTo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Maintenance Mode'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(
          'Do you really want to turn ${!setTo ? "on" : "off"} maintenance mode?'),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: Navigator.of(context).pop,
        ),
        TextButton(
          child: Text('Confirm'),
          onPressed: () {
            Provider.of<EventModel>(context, listen: false)
                .toggleServerStatus();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class DeletePrompt extends StatefulWidget {
  final id;
  const DeletePrompt({required this.id});

  @override
  _DeletePromptState createState() => _DeletePromptState();
}

class _DeletePromptState extends State<DeletePrompt> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Event'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Theme.of(context).primaryColor,
      content: Text('Do you really wish to delete this Event?'),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed:
              loading ? null : () => Navigator.of(context).pop<bool>(false),
        ),
        TextButton(
          child: loading ? CircularProgressIndicator() : Text('Confirm'),
          onPressed: loading
              ? null
              : () async {
                  setState(() => loading = true);
                  await Provider.of<EventModel>(context, listen: false)
                      .deleteEvent(widget.id);
                  setState(() => loading = false);
                  Navigator.of(context).pop<bool>(true);
                },
        ),
      ],
    );
  }
}
