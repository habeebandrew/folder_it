import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Group_Browser/presentation/group_pages/members_log.dart';
import 'package:folder_it/features/Groups/presentation/pages/invite_member_page.dart';
import 'package:http/http.dart' as http;

import '../member_model/member_model.dart';

class MembersPage extends StatefulWidget {
  final int groupId;
  final bool isOtherFilter;

  const MembersPage(
      {super.key, required this.groupId, required this.isOtherFilter});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  late Future<List<Member>> _membersFuture;
  String mytoken = CacheHelper().getData(key: 'token');

  @override
  void initState() {
    super.initState();
    _membersFuture = fetchMembers(widget.groupId);
  }

  Future<List<Member>> fetchMembers(int groupId) async {
    final url = Uri.parse(
        'http://localhost:8091/group/get-members-of-group?groupId=$groupId');
    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $mytoken'});
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((member) => Member.fromJson(member)).toList();
      } else {
        throw Exception('Failed to load members');
      }
    } catch (e) {
      throw Exception('Error fetching members: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(''),
        actions: [
          Tooltip(
            message: 'Invite new member',
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return InviteMemberPage(groupId: widget.groupId);
                    },
                  );
                },
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text('Invite member',
                    style: Theme.of(context).textTheme.displayMedium),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Member>>(
        future: _membersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No members found.'));
          }

          final members = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return Tooltip(
                message:  widget.isOtherFilter || member.roleId ==1?'user':'show user log',
                child: InkWell(
                  onTap: widget.isOtherFilter || member.roleId ==1
                  ?null
                  : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MembersLog(
                                groupId: widget.groupId,
                                userId: member.userId,
                              ),
                            ),
                          );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          member.userName[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        member.userName,
                      ),
                      trailing: member.roleId == 1
                          ? const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  'Admin',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : widget.isOtherFilter
                              ? PopupMenuButton<String>(
                                  onSelected: (value) {},
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      const PopupMenuItem<String>(
                                        value: '',
                                        child: Text('Member info'),
                                      ),
                                    ];
                                  },
                                  icon: const Icon(
                                    Icons.info,
                                    color: Colors.blueGrey,
                                  ),
                                )
                              : PopupMenuButton<String>(
                                  onSelected: (value) {
                                    _showDeleteConfirmation(
                                        member.userId, widget.groupId);
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      const PopupMenuItem<String>(
                                        value: 'remove',
                                        child: Text('Remove Member'),
                                      ),
                                    ];
                                  },
                                  icon: const Icon(Icons.more_vert),
                              ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(int userId, int groupId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Removal'),
          content: const Text(
            'Are you sure you want to remove this member? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteMember(userId, groupId);
              },
              child: const Text('Remove'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteMember(int userId, int groupId) async {
    final url = Uri.parse(
        'http://localhost:8091/group/delete-member-from-group?userId=$userId&groupId=$groupId');
    try {
      String mytoken = CacheHelper().getData(key: 'token');
      final response =
          await http.post(url, headers: {'Authorization': "Bearer $mytoken"});

      if (response.statusCode == 200) {
        setState(() {
          _membersFuture = fetchMembers(groupId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Member removed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove member: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
