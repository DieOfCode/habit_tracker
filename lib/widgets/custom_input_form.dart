import 'package:flutter/material.dart';

class CustomInputForm extends StatefulWidget {
  final String formName;
  final String label;
  final Function onChanged;
  final String initialValue;

  CustomInputForm(
      {@required this.formName,
      @required this.label,
      this.onChanged,
      this.initialValue});

  @override
  _CustomInputFormState createState() => _CustomInputFormState();
}

class _CustomInputFormState extends State<CustomInputForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.formName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.start,
            ),
            TextFormField(
              initialValue: widget.initialValue,
              onChanged: widget.onChanged,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Эти поля нельзя оставлять пустыми';
                }
                return null;
              },
              decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide()),
                  labelStyle: TextStyle(color: Colors.black38),
                  labelText: widget.label,
                  floatingLabelBehavior: FloatingLabelBehavior.never),
            ),
          ],
        ),
      ),
    );
  }
}
