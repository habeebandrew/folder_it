import 'package:flutter/material.dart';


class GroupCreationPage extends StatefulWidget {
  const GroupCreationPage({super.key});

  @override
  _GroupCreationPageState createState() => _GroupCreationPageState();
}

class _GroupCreationPageState extends State<GroupCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _groupName;
  String? _description;
  bool _isPrivate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Group Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a group name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _groupName = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value;
                },
              ),
              SwitchListTile(
                title: const Text('Private Group'),
                value: _isPrivate,
                onChanged: (value) {
                  setState(() {
                    _isPrivate = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Handle form submission
                    print('Group Name: $_groupName');
                    print('Description: $_description');
                    print('Private: $_isPrivate');
                  }
                },
                child: const Text('Create Group'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
