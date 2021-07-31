import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webmaster/components/image_picker.dart';

class WriteView extends StatefulWidget {
  @override
  _WriteViewState createState() => _WriteViewState();
}

class _WriteViewState extends State<WriteView> {
  final _picker = ImagePicker();
  XFile? file;

  void pickImage() async {
    file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
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
                    child: Column(
                      children: [ImageInput(pickImage: pickImage, file: file)],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
