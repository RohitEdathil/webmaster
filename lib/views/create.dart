import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:webmaster/components/image_picker.dart';
import 'package:webmaster/components/text_field.dart';
import 'package:webmaster/data/events.dart';

class WriteView extends StatefulWidget {
  @override
  _WriteViewState createState() => _WriteViewState();
}

class _WriteViewState extends State<WriteView> {
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  XFile? file;
  String? writeUp;
  String? name;
  String? link;
  int state = 0;
  DateTime date = DateTime.now();
  void pickImage() async {
    file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {});
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

  void stateValue(int? s) {
    setState(() {
      state = s!;
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
            name!,
            writeUp!,
            link!,
            file!.path,
            "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
            state);
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
              title: Text('Create Event'),
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
                            label: 'Registration Link',
                            validator: linkValidator,
                            current: link,
                          ),
                          DateInput(
                            validator: dateValue,
                            current: date,
                          ),
                          StateSlider(
                            validator: stateValue,
                            current: state,
                          ),
                          SizedBox(
                            height: 100,
                          )
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
