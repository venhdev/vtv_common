import 'package:flutter/material.dart';

class FullScreenTextField extends StatelessWidget {
  const FullScreenTextField({super.key, this.title, this.initialText});

  final String? title;
  final String? initialText;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: initialText ?? '');

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: title != null ? Text(title!) : null,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
