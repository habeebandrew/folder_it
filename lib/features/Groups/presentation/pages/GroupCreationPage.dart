// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../../core/databases/cache/cache_helper.dart';
//
// class GroupCreationPage extends StatefulWidget {
//   const GroupCreationPage({super.key});
//
//   @override
//   _GroupCreationPageState createState() => _GroupCreationPageState();
// }
//
// class _GroupCreationPageState extends State<GroupCreationPage> {
//   final TextEditingController groupNameController = TextEditingController();
//   bool isAgreed = false;
//   bool isNameValid = false;
//   bool isLoading = false; // حالة لتحميل البيانات
//
//   @override
//   void initState() {
//     super.initState();
//     groupNameController.addListener(() {
//       setState(() {
//         isNameValid = groupNameController.text.isNotEmpty &&
//             groupNameController.text.length <= 11;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     groupNameController.dispose();
//     super.dispose();
//   }
//
//   Future<void> createGroup() async {
//     setState(() {
//       isLoading = true; // بدأ التحميل
//     });
//     int myid=CacheHelper().getData(key: "myid");
//
//     const String apiUrl = 'http://127.0.0.1:8091/group/add';
//
//
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {        'Content-Type': 'application/x-www-form-urlencoded',
//       'Accept':'application/json'},
//         body:{
//           'groupName': groupNameController.text,
//           'creator': myid.toString(), // تحويل myid إلى String
//
//         },
//       );
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Group "${groupNameController.text}" created successfully!')),
//         );
//         groupNameController.clear(); // إعادة تعيين حقل النص
//         setState(() {
//           isAgreed = false; // إعادة تعيين الاتفاقية
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to create group: ${response.body}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error occurred: $e')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false; // انتهاء التحميل
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Center(
//               child: Container(
//                 width: constraints.maxWidth > 600 ? 600 : constraints.maxWidth * 0.9,
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 5,
//                       blurRadius: 7,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: groupNameController,
//                       maxLength: 11,
//                       inputFormatters: [
//                         LengthLimitingTextInputFormatter(11),
//                       ],
//                       decoration: InputDecoration(
//                         labelText: 'Group Name',
//                         hintText: 'Enter group name',
//                         counterText: '',
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(color: Colors.black, width: 1.5),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: const BorderSide(color: Colors.blue, width: 2),
//                         ),
//                       ),
//                     ),
//                     if (!isNameValid)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text(
//                           "Group name must be between 1 and 11 characters.",
//                           style: TextStyle(color: Colors.red[700], fontSize: 12),
//                         ),
//                       ),
//                     const SizedBox(height: 20),
//                     Flexible(
//                       child: SingleChildScrollView(
//                         child: Text(
//                           "Usage Policy:\n\n"
//                               "By creating a group, you agree to the terms and conditions stated in the usage policy. "
//                               "Please ensure that your group complies with our community standards and usage guidelines. "
//                               "Inappropriate or illegal content is strictly prohibited.",
//                           style: TextStyle(color: Colors.grey[700]),
//                           textAlign: TextAlign.justify,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: isAgreed,
//                           onChanged: isNameValid
//                               ? (value) {
//                             setState(() {
//                               isAgreed = value ?? false;
//                             });
//                           }
//                               : null,
//                         ),
//                         Expanded(
//                           child: Text(
//                             "I agree to the terms and conditions",
//                             style: TextStyle(color: isNameValid ? Colors.grey[700] : Colors.grey),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: isAgreed && isNameValid && !isLoading
//                           ? createGroup
//                           : null,
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size(double.infinity, 50),
//                         backgroundColor: isAgreed && isNameValid ? Color(0xff2196f3) : Colors.grey,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: isLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text(
//                         'Create Group',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../../core/databases/cache/cache_helper.dart';

class GroupCreationPage extends StatefulWidget {
  const GroupCreationPage({super.key});

  @override
  _GroupCreationPageState createState() => _GroupCreationPageState();
}

class _GroupCreationPageState extends State<GroupCreationPage> {
  final TextEditingController groupNameController = TextEditingController();
  bool isAgreed = false;
  bool isNameValid = false;
  bool isLoading = false; // حالة لتحميل البيانات

  @override
  void initState() {
    super.initState();
    groupNameController.addListener(() {
      setState(() {
        isNameValid = groupNameController.text.isNotEmpty &&
            groupNameController.text.length <= 8;
      });
    });
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  Future<void> createGroup() async {
    setState(() {
      isLoading = true; // بدأ التحميل
    });
    int myid=CacheHelper().getData(key: "myid");

    const String apiUrl = 'http://127.0.0.1:8091/group/add';


    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {        'Content-Type': 'application/x-www-form-urlencoded',
          'Accept':'application/json'},
        body:{
          'groupName': groupNameController.text,
          'creator': myid.toString(), // تحويل myid إلى String

        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green,content: Text('Group "${groupNameController.text}" created successfully!')),
        );
        groupNameController.clear(); // إعادة تعيين حقل النص
        setState(() {
          isAgreed = false; // إعادة تعيين الاتفاقية
        });
        Future.delayed(Duration(seconds: 2), () {
          context.go('/home'); // الانتقال إلى مسار معين
          print('تم تنفيذ العملية بعد ثانية واحدة');
        });

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create group: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    } finally {
      setState(() {
        isLoading = false; // انتهاء التحميل
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                width: constraints.maxWidth > 600 ? 600 : constraints.maxWidth * 0.9,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
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
                      maxLength: 8,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(8),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Group Name',
                        hintText: 'Enter group name',
                        counterText: '',

                      ),
                    ),
                    if (!isNameValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Group name must be between 1 and 8 characters.",
                          style: TextStyle(color: Colors.red[700], fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Text(
                          "Usage Policy:\n\n"
                              "By creating a group, you agree to the terms and conditions stated in the usage policy. "
                              "Please ensure that your group complies with our community standards and usage guidelines. "
                              "Inappropriate or illegal content is strictly prohibited.",
                          style: TextStyle(color: Colors.grey[500]),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: isAgreed,
                          onChanged: isNameValid
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
                            style: TextStyle(color: isNameValid ? Colors.grey[600] : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isAgreed && isNameValid && !isLoading
                          ? createGroup
                          : null,
                      style:
                      isAgreed && isNameValid
                      ?Theme.of(context).elevatedButtonTheme.style
                      :ElevatedButton.styleFrom(
                        //minimumSize: const Size(double.infinity, 50),
                        backgroundColor:  Colors.grey,
                        foregroundColor:Colors.grey ,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          :  Text(
                        'Create Group',
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize
                        )
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
