import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';



class ImageUploadWidget extends StatefulWidget {

  final ValueChanged<String> onChanged;
  final String? imagePath;

  const ImageUploadWidget({
    super.key,
    required this.onChanged,
    this.imagePath,
  });

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}
class _ImageUploadWidgetState extends State<ImageUploadWidget> {

  String? _imagePath;
  bool _imageClicked = false;

    @override
  void initState() {
    super.initState();
    _imagePath = widget.imagePath;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 8.0,
        children: <Widget>[
        Text('Cover image:', style: Theme.of(context).textTheme.titleSmall,),
        if (_imagePath == null) 
        OutlinedButton(
          onPressed: _pickImage,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(70, 70),
            maximumSize: Size(70, 70),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          // PICKUP: too much padding to the left
          child: Icon(Icons.add, size: 50),
        )
        else if (_imageClicked == false)
        GestureDetector(
          onTap: () {
            setState(() {
              _imageClicked = true;
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(File(_imagePath!), width: 70, height: 70),
          ),
        )   
        else 
        OutlinedButton(
          onPressed: () {
            setState(() {
              _imagePath = null;
              _imageClicked = false;
              widget.onChanged('');
            });
          },
          style: OutlinedButton.styleFrom(
            minimumSize: Size(70, 70),
            maximumSize: Size(70, 70),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Icon(Icons.delete, size: 40,
          color: Theme.of(context).colorScheme.error,),
        )

        //   TextButton(
        //           child: Text('Pick an image'),
        //           onPressed: () => {
        //             _pickImage(),
        //           },
        //         ),
        //   _imagePath == null ? Icon(Icons.photo, size: 120, color: Colors.grey,) : Image.file(File(_imagePath!), width: 120, height: 120),
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
        widget.onChanged(filePath);
        
      });
    }
    
    }
}

 