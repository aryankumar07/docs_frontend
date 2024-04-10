import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Loader extends StatelessWidget{
  Loader({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: CircularProgressIndicator(),
      );
  }
}