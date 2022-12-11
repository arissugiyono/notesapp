import 'package:flutter/material.dart';
import 'package:notes_app/provider/notes.dart';
import 'package:notes_app/screens/add_or_detail_screen.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Notes(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.dark(),
          home: HomeScreen(),
          routes: {
            addOrDetailScreen.routeName: (context) => addOrDetailScreen(),
          }),
    );
  }
}
