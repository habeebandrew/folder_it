import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'User_Log_Screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final int pageSize = 3; // عدد الأسطر في كل صفحة
  int currentPage = 0; // الصفحة الحالية
  List<dynamic> users = [];
  int totalRows = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'http://localhost:8091/user/get-all-users?size=$pageSize&start=$currentPage');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalRows = data['extraData'];
          users.addAll(data['list']);
        });
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void loadMore() {
    if (users.length < totalRows) {
      currentPage++;
      fetchUsers();
    }
  }

  Widget buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(user['userName'][0].toUpperCase()),
        ),
        title: Text(user['userName']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email']),
            Text('Created: ${user['creationDate']}'),
            Text(
              user['recordStatus'] ? 'Active' : 'Inactive',
              style: TextStyle(
                color: user['recordStatus'] ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserLogScreen(userId: user['id']),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: users.isEmpty && isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: users.length + (users.length < totalRows ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < users.length) {
                        return buildUserCard(users[index]);
                      } else {
                        return Center(
                          child: ElevatedButton(
                            onPressed: isLoading ? null : loadMore,
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text('Load More'),
                          ),
                        );
                      }
                    },
                  ),
                ),
                if (isLoading) CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
