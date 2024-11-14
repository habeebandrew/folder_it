import 'package:flutter/material.dart';

//todo:الزمو ب11حرف وجرب لشوف التنسيق من الحرق لل11 اذا بيتغير شطل الصورة وحجما
class GroupCreationPage extends StatefulWidget {
  const GroupCreationPage({super.key});

  @override
  _GroupCreationPageState createState() => _GroupCreationPageState();
}

class _GroupCreationPageState extends State<GroupCreationPage> {
  final TextEditingController groupNameController = TextEditingController();
  bool isAgreed = false;
  bool isNameEntered = false;

  @override
  void initState() {
    super.initState();
    groupNameController.addListener(() {
      setState(() {
        isNameEntered = groupNameController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Group",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        // backgroundColor: Color(value),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                width: constraints.maxWidth > 600 ? 600 : constraints.maxWidth * 0.9,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: groupNameController,
                      decoration: const InputDecoration(
                        labelText: 'Group Name',
                        border: OutlineInputBorder(),
                        hintText: 'Enter group name',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          "Usage Policy:\n\n"
                              "By creating a group, you agree to the terms and conditions stated in the usage policy. "
                              "Please ensure that your group complies with our community standards and usage guidelines. "
                              "Inappropriate or illegal content is strictly prohibited.",
                          style: TextStyle(color: Colors.grey[700]),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: isAgreed,
                          onChanged: isNameEntered
                              ? (value) {
                            setState(() {
                              isAgreed = value ?? false;
                            });
                          }
                              : null,
                        ),
                        Expanded(
                          child: Text(
                            "I agree to the terms and conditions",
                            style: TextStyle(color: isNameEntered ? Colors.grey[700] : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isAgreed && isNameEntered
                          ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Group "${groupNameController.text}" created successfully!'),
                          ),
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: isAgreed && isNameEntered
                            ? Colors.teal
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Create Group',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}