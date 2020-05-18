import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final String label;
  final Function(String) validator;
  final bool isSecure;
  final TextInputType inputType;
  final double fontSize;
  final IconData icon;
  final int maxLines;
  final String hintText;

  const InputText({
    Key key,
    @required this.label,
    this.validator,
    this.isSecure = false,
    this.inputType = TextInputType.text,
    this.fontSize = 17,
    this.icon = Icons.perm_identity,
    this.maxLines = 1,
    this.hintText = '',
  }) : super(key: key);

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      keyboardType: widget.inputType,
      obscureText: widget.isSecure,
      validator: widget.validator,
      decoration: InputDecoration(
          hintText: widget.hintText,
          icon: Icon(widget.icon),
          labelText: widget.label,
          alignLabelWithHint: true,
          labelStyle: TextStyle(fontSize: widget.fontSize),
          contentPadding: EdgeInsets.symmetric(vertical: 10)),
    );
  }
}
