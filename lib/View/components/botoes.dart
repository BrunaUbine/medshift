import 'package:flutter/material.dart';

Widget botaoCancelar(context, label) {
  return TextButton(
    onPressed: () => Navigator.pop(context),
    child: Text(label),
  );
}



