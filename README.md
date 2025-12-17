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

## Install

Add this line to your **pubspec.yaml**:

```yaml
dependencies:
  custom_slidable: ^0.0.1
```

In your library add the following import:

```dart
import 'package:custom_slidable/custom_slidable/custom_slidable.dart';
```

## Getting started

Example:

```dart
CustomSlidable(
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
```

