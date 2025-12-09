import 'package:custom_slidable/custom_slidable/action_pane_motions.dart';
import 'package:custom_slidable/custom_slidable/actions.dart';
import 'package:custom_slidable/custom_slidable/custom_slidable.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Custom Slidable Example")),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return CustomSlidable(
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  CustomSlidableAction(
                    onPressed: (_) {},
                    backgroundColor: Colors.red,
                    icon: SizedBox(child: Icon(Icons.delete)),
                  ),
                ],
              ),
              child: ListTile(
                title: Text("Item \$index"),
                subtitle: const Text("Swipe right → left"),
              ),
            );
          },
        ),
      ),
    );
  }
}
