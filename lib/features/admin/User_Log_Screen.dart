import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserLogScreen extends StatefulWidget {
  final int userId;

  const UserLogScreen({required this.userId});

  @override
  _UserLogScreenState createState() => _UserLogScreenState();
}

class _UserLogScreenState extends State<UserLogScreen> {
  final int pageSize = 3; // عدد الأسطر في كل صفحة
  int currentPage = 0; // الصفحة الحالية
  List<dynamic> logs = [];
  int totalRows = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserLogs();
  }

  Future<void> fetchUserLogs() async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'http://localhost:8091/user-log/user-log?size=$pageSize&start=$currentPage&userId=${widget.userId}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalRows = data['extraData'];
          logs.addAll(data['list']);
        });
      } else {
        throw Exception('Failed to load user logs');
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
    if (logs.length < totalRows) {
      currentPage++;
      fetchUserLogs();
    }
  }

  Widget buildLogCard(Map<String, dynamic> log) {
    String formattedDate = DateFormat('yyyy-MM-dd – hh:mm a')
        .format(DateTime.parse(log['creationDate']));

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4, // Add shadow for a better look
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   'Action: ${log['action']}',
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 16,
                //     color: Colors.black87,
                //   ),
                // ),
                Icon(
                  Icons.event_note,
                  color: Colors.blue.shade700,
                ),
              ],
            ),
            const Divider(), // Add a divider for better separation
            const SizedBox(height: 8),
            // Text(
            //   'Group: ${log['relatedGroup']}',
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.grey.shade600,
            //   ),
            // ),
            // const SizedBox(height: 4),
            Text(
              'Date: $formattedDate',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Note: ${log['logNote'] ?? "No notes available"}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Logs'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: logs.isEmpty && isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: logs.length + (logs.length < totalRows ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < logs.length) {
                        return buildLogCard(logs[index]);
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
