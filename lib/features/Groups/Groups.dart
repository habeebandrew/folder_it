import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  String selectedCategory = 'All';
  int? _hoverIndex;
  bool _sortByNewest = true;
  late Future<List<Group>> _groups;

  @override
  void initState() {
    super.initState();
    _groups = fetchGroups(1005); // يمكنك استبدال الرقم 1 برقم ID الديناميكي
  }

  Future<List<Group>> fetchGroups(int id) async {
    final response = await http.get(
      Uri.parse("http://127.0.0.1:8091/group/my-groups?creatorId=$id"),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Group.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load groups');
    }
  }

  List<Group> applyFilters(List<Group> groups) {
    List<Group> filteredGroups = groups.where((group) {
      if (selectedCategory == 'Deleted') {
        return group.recordStatus == false;
      }
      else if (selectedCategory == 'My Groups'){

      //  return group.creator == id; //todo: cache

      }
      return group.recordStatus == true;
    }).toList();

    filteredGroups.sort((a, b) => _sortByNewest
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
        title:
            const Text('Groups', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            onPressed: () {
              context.go('/GroupCreationPage');
            },
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text('create new group',
                style: TextStyle(color: Colors.black)),
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              textStyle: const TextStyle(fontSize: 16),
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
                  _buildCategoryFilterBar(),
                  const SizedBox(width: 10),
                  _buildSortToggle(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Group>>(
                future: _groups,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final groups = applyFilters(snapshot.data!);
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
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilterBar() {
    final categories = ['All', 'My Groups', 'Deleted'];
    return Row(
      children: categories.map((category) {
        return Row(
          children: [
            const SizedBox(width: 15,),
            GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = category;
                });
              },
              child: Chip(
                label: Text(
                  category,
                  style: TextStyle(
                    color:
                        selectedCategory == category ? Colors.white : Colors.black,
                  ),
                ),
                backgroundColor:
                    selectedCategory == category ? Colors.blue : Colors.grey[200],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSortToggle() {
    return Row(
      children: [
        const Text("Sort by: "),
        DropdownButton<bool>(
          value: _sortByNewest,
          items: const [
            DropdownMenuItem(value: true, child: Text("Newest")),
            DropdownMenuItem(value: false, child: Text("Oldest")),
          ],
          onChanged: (value) {
            setState(() {
              _sortByNewest = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildGroupBox(Group group) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoverIndex = group.id;
        });
      },
      onExit: (_) {
        setState(() {
          _hoverIndex = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _hoverIndex == group.id
            ? (Matrix4.identity()..scale(1.05))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: _hoverIndex == group.id
              ? [
                  BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10.0,
                      offset: const Offset(0, 5))
                ]
              : [
                  const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      offset: Offset(0, 2))
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/folder3.png"),
            // يمكنك وضع صورة هنا بدلًا من الأيقونة
            const SizedBox(height: 8),
            Text(
              group.groupName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
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
