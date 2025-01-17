
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../../core/databases/cache/cache_helper.dart';
import '../../../../localization/localization.dart';

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
  String mytoken =CacheHelper().getData(key: 'token');
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
        headers: {       
          'Authorization':'Bearer $mytoken', 
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept':'application/json'
        },
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
        Future.delayed(const Duration(milliseconds: 500), () {
          context.go('/home');
        });
      }
      else {
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
    return Scaffold(appBar: AppBar(
      //backgroundColor: Theme.of(context).primaryColor,
      title: Row(
        children: [
          const Icon(Icons.folder, color: Colors.yellow, size: 30),
          const SizedBox(width: 10),
          Text(
            AppLocalization.of(context)?.translate(
                "app_title") ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
            ),
          ),
        ],
      ),
      actions: [
        // Tooltip(
        //   message: 'Instructions',
        //   child: TextButton(
        //     onPressed: () {},
        //     child:
        //     const Icon(Icons.question_mark_sharp, color: Colors.yellow),
        //   ),
        // ),
      ],
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
                      decoration:  InputDecoration(
                        labelText: AppLocalization.of(context)?.translate(
                            "group_name") ?? "",
                        hintText: AppLocalization.of(context)?.translate(
                            "enter_group_name") ?? "",
                        counterText: '',

                      ),
                    ),
                    if (!isNameValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          AppLocalization.of(context)?.translate(
                              "between") ?? ""
                          ,
                          style: TextStyle(color: Colors.red[700], fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                            AppLocalization.of(context)?.translate("Usage_Policy") ?? " ",

                              style: TextStyle(color: Colors.grey[500]),
                              textAlign: TextAlign.justify,
                            ),
                            Text(

                                  AppLocalization.of(context)?.translate("policy_info")?? "",
                              style: TextStyle(color: Colors.grey[500]),
                              textAlign: TextAlign.justify,
                            ),
                          ],
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
        AppLocalization.of(context)?.translate("I_agree")??"",
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
                          :  Text(//
                          AppLocalization.of(context)?.translate("createGroupButton")??"",
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
