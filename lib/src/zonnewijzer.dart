import 'package:flutter/material.dart';
import 'schermen/thuis_scherm.dart';

class Zonnewijzer extends StatelessWidget {
  const Zonnewijzer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zonnewijzer',
      theme: ThemeData.dark(),
      home: ThuisScherm(),
    );
  }
}
