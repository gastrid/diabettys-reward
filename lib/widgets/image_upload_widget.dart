import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:diabettys_reward/utils/constants.dart';


typedef Progress = Function(double percent);

class ImageUploadWidget extends StatefulWidget {

  final ValueChanged<String> onChanged;

  const ImageUploadWidget({
    super.key,
    required this.onChanged,
  });

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}
class _ImageUploadWidgetState extends State<ImageUploadWidget> {

  bool _imagePicked = false;
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextButton(
                  child: Text('Pick an image'),
                  onPressed: () => {
                    _pickImage(),
                  },
                ),
          _imagePath == null ? Icon(Icons.photo, size: 120, color: Colors.grey,) : Image.file(File(_imagePath!), width: 120, height: 120),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = pickedFile.name;
        final filePath = "${directory.path}/$fileName";
        final file = File(filePath);
        final savedImage = await  File(pickedFile.path).copy(filePath);
        setState(() {
        _imagePath = filePath;
        _imagePicked = true;
        widget.onChanged(filePath);
        
      });
    }
    
    }
}

 