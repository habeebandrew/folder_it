import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/databases/cache/cache_helper.dart';

class NewUpdate extends StatefulWidget {
  const NewUpdate({super.key});

  @override
  _NewUpdateState createState() => _NewUpdateState();
}

class _NewUpdateState extends State<NewUpdate> {
  int _currentPage = 0;
  final int _pageSize = 3;
  bool _isLoading = false;
  bool _hasMore = true;
  List<dynamic> _notifications = [];
  final String token = CacheHelper().getData(key: 'token');

  Future<void> _fetchNotifications() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    final url =
        'http://localhost:8091/notification/get-my-notifications?relatedUser=1&size=$_pageSize&start=$_currentPage';

    try {
      final response = await http.get(Uri.parse(url),headers: {

        'Authorization': 'Bearer $token',

      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> fetchedNotifications = data['list'];

        setState(() {
          _currentPage += _pageSize;
          _notifications.addAll(fetchedNotifications);
          _hasMore = fetchedNotifications.length == _pageSize;
        });
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Notifications',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          children: [
            Expanded(
              child: _notifications.isEmpty && !_isLoading
                  ? const Center(
                child: Text('No notifications available.'),
              )
                  : ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        notification['notification'] ?? 'No Notification',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Date: ${notification['creationDate'] ?? 'No Date'}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            if (_hasMore && !_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _fetchNotifications,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Load More'),
                  ),
                ),
              ),
            if (!_hasMore)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No more notifications.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: 100,
          height: 30,
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
