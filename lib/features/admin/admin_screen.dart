import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
    String formattedDate = DateFormat('MMMM d, y').format(DateTime.parse(user['creationDate']));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4, // Add slight shadow for a 3D effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners for better UI
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjust padding for better spacing
        leading: CircleAvatar(
          radius: 30, // Slightly larger avatar
          backgroundColor: Colors.blue.shade100,
          child: Text(
            user['userName'][0].toUpperCase(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
        ),
        title: Text(
          user['userName'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user['email'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Created: $formattedDate',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: user['recordStatus'] ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  user['recordStatus'] ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: user['recordStatus'] ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey.shade400,
          size: 20,
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
        title: const Center(child: Text('Users List')),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: users.isEmpty && isLoading
                      ? const Center(child: CircularProgressIndicator())
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
                                ? const CircularProgressIndicator()
                                : const Text('Load More'),
                          ),
                        );
                      }
                    },
                  ),
                ),
                if (isLoading) const CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
