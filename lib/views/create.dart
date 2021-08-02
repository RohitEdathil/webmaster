import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webmaster/components/image_picker.dart';
import 'package:webmaster/components/text_field.dart';

class WriteView extends StatefulWidget {
  @override
  _WriteViewState createState() => _WriteViewState();
}

class _WriteViewState extends State<WriteView> {
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
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

  String? nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name can\'t be empty';
    }
  }

  String? writeUpValidator(String? writeUp) {
    if (writeUp == null || writeUp.isEmpty) {
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

  String? linkValidator(String? link) {
    if (link == null || link.isEmpty) {
      return 'Link can\'t be empty';
    }
    bool isValid =
        Uri.tryParse(link.endsWith('/') ? link : '$link/')?.hasAbsolutePath ??
            false;
    if (!isValid) {
      return 'Invalid Link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () => _formKey.currentState?.validate(),
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
                          CustomField(label: 'Name', validator: nameValidator),
                          CustomField(
                              label: 'Write Up',
                              large: true,
                              validator: writeUpValidator),
                          CustomField(
                              label: 'Registration Link',
                              validator: linkValidator),
                          StateSlider(
                            validator: stateValue,
                            current: state,
                          ),
                          DateInput(
                            validator: dateValue,
                            current: date,
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
