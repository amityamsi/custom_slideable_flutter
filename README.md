# 📦 custom_slidable

A lightweight, customizable, and easy-to-use slideable widget for Flutter — inspired by `flutter_slidable`, but simpler, cleaner, and fully flexible.

`custom_slidable` lets you add smooth swipe actions (delete, edit, archive, etc.) to any widget such as ListTiles, cards, or custom containers with minimal setup.

---

## ✨ Features

- ✔️ Smooth left/right swipe gestures  
- ✔️ Customizable action panes  
- ✔️ Multiple motion types (e.g., **ScrollMotion**)  
- ✔️ Build your own action widgets  
- ✔️ Works with lists, cards, and all widgets  
- ✔️ Lightweight & simple API  
- ✔️ Null-safety ready  

---

## 🚀 Getting Started

Add this line to your **pubspec.yaml**:

dependencies:
  custom_slidable: ^0.0.1


Import the package:
import 'package:custom_slidable/custom_slidable.dart';

Example:

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
                    icon: const Icon(Icons.delete, color: Colors.white),
                  ),
                ],
              ),
              child: ListTile(
                title: Text("Item $index"),
                subtitle: const Text("Swipe right → left"),
              ),
            );
          },
        ),
      ),
    );
  }
}
