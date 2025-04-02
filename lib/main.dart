import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InventoryHomePage(),
    );
  }
}

class InventoryHomePage extends StatefulWidget {
  const InventoryHomePage({super.key});

  @override
  State<InventoryHomePage> createState() => _InventoryHomePageState();
}

class _InventoryHomePageState extends State<InventoryHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final CollectionReference _inventory = FirebaseFirestore.instance.collection(
    'items',
  );

  void _addItem() {
    if (_nameController.text.isNotEmpty) {
      _inventory.add({'name': _nameController.text});
      _nameController.clear();
    }
  }

  void _deleteItem(String id) {
    _inventory.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inventory Management')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _inventory.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView(
            children:
                snapshot.data!.docs.map((doc) {
                  return ListTile(
                    title: Text(doc['name']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteItem(doc.id),
                    ),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
