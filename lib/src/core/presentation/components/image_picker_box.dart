import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils.dart';
class ImagePickerBox extends StatefulWidget {
  const ImagePickerBox({
    super.key,
    required this.imgUrl,
    this.onChanged,
    this.size = 120.0,
    this.isNetworkImage = false,
  });

  final String? imgUrl;
  final bool isNetworkImage;
  /// return local image path, remember to use [File] to get image file
  /// 
  /// call only when image is changed
  final ValueChanged<String>? onChanged;
  final double size;

  @override
  State<ImagePickerBox> createState() => _ImagePickerBoxState();
}

class _ImagePickerBoxState extends State<ImagePickerBox> {
  String? _imgUrl;

  @override
  void initState() {
    super.initState();
    _imgUrl = widget.imgUrl;
  }

  @override
  Widget build(BuildContext context) {
    return _imgUrl != null
        ? InkWell(
            onTap: () async {
              await FileUtils.showImagePicker().then((value) {
                if (value != null) {
                  setState(() {
                    _imgUrl = value.path;
                    // _param.changeImage = true;
                  });
                  widget.onChanged?.call(value.path);
                }
              });
            },
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              padding: const EdgeInsets.all(4),
              height: widget.size,
              width: widget.size,
              // child: Image.file(File(_imgUrl!)),
              child: widget.isNetworkImage ? Image.network(_imgUrl!) : Image.file(File(_imgUrl!)),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey),
            ),
            height: widget.size,
            width: widget.size,
            child: IconButton(
              onPressed: () async {
                await FileUtils.showImagePicker().then((value) {
                  if (value != null) {
                    setState(() {
                      _imgUrl = value.path;
                      // _param.changeImage = true;
                    });
                    widget.onChanged?.call(value.path);
                  }
                });
              },
              icon: const Icon(Icons.add_a_photo),
              iconSize: 24,
            ),
          );
  }
}
