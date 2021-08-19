import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:webmaster/components/image_picker.dart';
import 'package:webmaster/components/prompts.dart';
import 'package:webmaster/components/text_field.dart';
import 'package:webmaster/data/events.dart';

class WriteView extends StatefulWidget {
  final Map<String, dynamic>? data;
  final int? id;
  WriteView({this.data, this.id});
  @override
  _WriteViewState createState() => _WriteViewState();
}

class _WriteViewState extends State<WriteView> {
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String? file;
  String? writeUp;
  String? name;
  String? link;
  String? action;
  int state = 0;
  int type = 0;
  DateTime date = DateTime.now();
  bool editMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      editMode = true;
      writeUp = widget.data!['write_up'];
      name = widget.data!['name'];
      action = widget.data!['action'];
      link = widget.data!['link'];
      file = widget.data!['poster'];
      state = widget.data!['status'];
      type = widget.data!['type'];
      date = DateTime.parse(widget.data!['date']);
    }
  }

  void deleteEvent(BuildContext context) async {
    bool? result = await showDialog<bool>(
        context: context, builder: (context) => DeletePrompt(id: widget.id));
    if (result ?? false) {
      Navigator.of(context).pop();
    }
  }

  void pickImage() async {
    final _file = await _picker.pickImage(source: ImageSource.gallery);

    if (_file != null) {
      setState(() => file = _file.path);
    }
  }

  String? nameValidator(String? n) {
    name = n;
    if (n == null || n.isEmpty) {
      return 'Name can\'t be empty';
    }
  }

  String? writeUpValidator(String? w) {
    writeUp = w;
    if (w == null || w.isEmpty) {
      return 'Write Up can\'t be empty';
    }
  }

  String? actionValidator(String? w) {
    action = w;
    if (w == null || w.isEmpty) {
      return 'Action Up can\'t be empty';
    }
  }

  void stateValue(int? s) {
    setState(() {
      state = s!;
    });
  }

  void typeValue(int? s) {
    setState(() {
      type = s!;
    });
  }

  void dateValue(DateTime d) {
    setState(() {
      date = d;
    });
  }

  String? linkValidator(String? l) {
    link = l;
    if (l == null || l.isEmpty) {
      return 'Link can\'t be empty';
    }
    bool isValid =
        Uri.tryParse(l.endsWith('/') ? l : '$l/')?.hasAbsolutePath ?? false;
    if (!isValid) {
      return 'Invalid Link';
    }
  }

  void snackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      backgroundColor: Theme.of(context).errorColor,
      duration: Duration(seconds: 2),
    ));
  }

  void toggleLoading() {
    setState(() {
      loading = !loading;
    });
  }

  void handleSubmit(BuildContext context) async {
    toggleLoading();
    bool formOk = _formKey.currentState?.validate() ?? false;
    bool posterOk = file != null;
    if (!formOk) {
      snackBar('Please recheck the fields');
      toggleLoading();
      return;
    }
    if (!posterOk) {
      snackBar('Please select a poster');
      toggleLoading();
      return;
    }

    final response = await Provider.of<EventModel>(context, listen: false)
        .createEvent(
            widget.id,
            name!,
            writeUp!,
            link!,
            action!,
            file!,
            "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
            state,
            type);
    if (response != null) {
      snackBar(response);
      toggleLoading();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        floatingActionButton: FloatingActionButton(
          child: loading
              ? CircularProgressIndicator(
                  color: Theme.of(context).primaryColorDark,
                )
              : Icon(Icons.check),
          onPressed: loading ? null : () => handleSubmit(context),
        ),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: Text(editMode ? "Edit Event" : 'Create Event'),
              centerTitle: true,
              elevation: 0,
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          ImageInput(pickImage: pickImage, file: file),
                          CustomField(
                            label: 'Name',
                            validator: nameValidator,
                            current: name,
                          ),
                          CustomField(
                            label: 'Write Up',
                            large: true,
                            validator: writeUpValidator,
                            current: writeUp,
                          ),
                          CustomField(
                            label: 'Action',
                            validator: actionValidator,
                            current: action,
                          ),
                          CustomField(
                            label: 'Link',
                            validator: linkValidator,
                            current: link,
                          ),
                          DateInput(
                            validator: dateValue,
                            current: date,
                          ),
                          StateChooser(
                            validator: stateValue,
                            current: state,
                          ),
                          TypeChooser(
                            validator: typeValue,
                            current: type,
                          ),
                          editMode
                              ? TextButton.icon(
                                  onPressed: () => deleteEvent(context),
                                  icon: Icon(Icons.delete),
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
                                  label: Text('Delete Event'))
                              : Container(),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
