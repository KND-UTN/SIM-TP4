import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_montecarlo/controllers/table_controller.dart';
import 'package:web_montecarlo/pages/table_page.dart';
 
void main() => runApp(MonteCarlo());
 
class MonteCarlo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Material App',
      home: ChangeNotifierProvider(
        create: (_) => TableController(),
        child: TablePage(),
        ),
    );
  }
}

