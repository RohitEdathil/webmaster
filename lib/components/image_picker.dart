import 'dart:io';
import 'package:flutter/material.dart';

class ImageInput extends StatelessWidget {
  final Function pickImage;
  final String? file;
  const ImageInput({required this.pickImage, this.file});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: GestureDetector(
          onTap: () => pickImage(),
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: file == null
                ? Container(
                    height: 250,
                    color: Colors.black87.withOpacity(0.3),
                    child: Center(
                      child: Icon(Icons.photo_album_rounded),
                    ),
                  )
                : (file!.substring(0, 4) == 'http'
                    ? Image.network(file!)
                    : Image.file(File(file ?? ''))),
          ),
        ),
      ),
    );
  }
}
