import 'package:aya_flutter_v2/constants/colors.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Text("List Page"),
      ),
    );
  }
}
