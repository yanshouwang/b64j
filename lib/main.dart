import 'package:flutter/cupertino.dart';

import 'view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(title: 'B64J', home: HomeView());
  }
}
