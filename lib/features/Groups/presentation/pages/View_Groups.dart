import 'package:flutter/material.dart';
import 'package:folder_it/features/Group_Browser/presentation/pages/group_form.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../core/databases/cache/cache_helper.dart';
import '../../../Group_Browser/presentation/pages/group_form.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  String selectedCategory = 'Other';
  int? hoverIndex;
  bool sortByNewest = true;
  late Future<List<Group>> groups;
  int myId = CacheHelper().getData(key: "myid")??1;

  @override
  void initState() {
    super.initState();
    groups = _loadDataForCategory();
  }

  Future<List<Group>> _loadDataForCategory() async {
    if (selectedCategory == 'Other') {
      return fetchOtherGroups();
    } else if (selectedCategory == 'My Groups') {
      return fetchMyGroups();
    } else if (selectedCategory == 'Deleted') {
      return fetchDeletedGroups();
    }
    return [];
  }

  Future<List<Group>> fetchOtherGroups() async {
    final url = "http://127.0.0.1:8091/group/fetch-all-my-groups?userId=$myId";
    return _fetchGroups(url, (group) => group.recordStatus);
  }

  Future<List<Group>> fetchMyGroups() async {
    final url = "http://127.0.0.1:8091/group/my-groups?creatorId=$myId";
    return _fetchGroups(url, (group) => group.recordStatus);
  }

  Future<List<Group>> fetchDeletedGroups() async {
    final url = "http://127.0.0.1:8091/group/my-groups?creatorId=$myId";
    return _fetchGroups(url, (group) => !group.recordStatus);
  }

  Future<List<Group>> _fetchGroups(
      String url, bool Function(Group) filterCondition) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List jsonResponse = json.decode(response.body);
        final groups =
        jsonResponse.map((data) => Group.fromJson(data)).toList();
        return groups.where(filterCondition).toList();
      } else {
        throw Exception('Failed to load groups');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  List<Group> applyFilters(List<Group> groups) {
    List<Group> filteredGroups = groups;

    filteredGroups.sort((a, b) => sortByNewest
        ? b.creationDate.compareTo(a.creationDate)
        : a.creationDate.compareTo(b.creationDate));

    return filteredGroups;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int columns = screenWidth > 870
        ? 5
        : screenWidth > 600
        ? 4
        : screenWidth > 378
        ? 3
        : 2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Groups',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Tooltip(
              message: 'Create New Group',
              child: TextButton.icon(
                onPressed: () {
                  context.go('/GroupCreationPage');
                },
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text('Create Group',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildCategoryFilterBar(),
                  const SizedBox(width: 10),
                  buildSortToggle(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Group>>(
                future: groups,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error.toString(),
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final groups = applyFilters(snapshot.data!);
                    if (groups.isEmpty) {
                      return const Center(child: Text('No groups available'));
                    }
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        return _buildGroupBox(groups[index]);
                      },
                    );
                  } else {
                    return const Center(child: Text('Unexpected error occurred'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryFilterBar() {
    final categories = ['Other', 'My Groups', 'Deleted'];

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                      groups = _loadDataForCategory();
                    });
                  },
                  child: Chip(
                    label: Text(
                      category,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: selectedCategory == category
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                    backgroundColor: selectedCategory == category
                        ? Theme.of(context).primaryColor
                        : Colors.grey[200],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildSortToggle() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.sort, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                "Sort by:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<bool>(
                value: sortByNewest,
                icon: Icon(Icons.arrow_drop_down,
                    color: Theme.of(context).primaryColor),
                underline: Container(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(
                    value: true,
                    child: Text("Newest"),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Text("Oldest"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    sortByNewest = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupBox(Group group) {
    bool isHovered = hoverIndex == group.id;

    return MouseRegion(
      onEnter: (_) => setState(() => hoverIndex = group.id),
      onExit: (_) => setState(() => hoverIndex = null),
      child: GestureDetector(
        onTap: () {
          if (selectedCategory == 'My Groups') {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupForm(groupId: group.id),
              ),
            );
          }
          else if(selectedCategory == 'Other'){
            Navigator.push(
                context,
                MaterialPageRoute(
                builder: (context) => GroupForm(
              groupId: group.id,
              isOtherFilter: true,
            ),
          ),);
          }
          else if (selectedCategory == 'Deleted') {
          _showDeletedGroupAlert();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: isHovered
                ? [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                blurRadius: 20.0,
                spreadRadius: 5.0,
                offset: const Offset(0, 10),
              ),
            ]
                : [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Image.asset(
                        'assets/images/group/group_pic2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      group.groupName.isNotEmpty ? group.groupName : "لا اسم للغروب",
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('yyyy-MM-dd').format(group.creationDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedCategory == 'My Groups')
                Positioned(
                  top: 8,
                  right: 8,
                  child: Tooltip(
                    message: 'delete this group',
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.blueGrey),
                      onPressed: () {
                        _showDeleteConfirmation(group.id);
                      },
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }


  void _showDeleteConfirmation(int groupId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
            'Are you sure you want to delete this group? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteGroup(groupId);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteGroup(int groupId) async {
    final url = Uri.parse('http://127.0.0.1:8091/group/delete?groupId=$groupId');
    final url1 = "http://127.0.0.1:8091/group/my-groups?creatorId=$myId";

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        setState(() {
          groups = _fetchGroups(url1, (group) => group.recordStatus);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete group: ${response.statusCode}'),
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
  void _showDeletedGroupAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Group Deleted'),
          content: const Text(
            'This group has been deleted and its information is no longer available.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class Group {
  final int id;
  final String groupName;
  final int creator;
  final DateTime creationDate;
  final bool recordStatus;

  Group({
    required this.id,
    required this.groupName,
    required this.creator,
    required this.creationDate,
    required this.recordStatus,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      groupName: json['groupName'],
      creator: json['creator'],
      creationDate: DateTime.parse(json['creationDate']),
      recordStatus: json['recordStatus'],
    );
  }
}
