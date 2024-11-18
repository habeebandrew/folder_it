import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../core/databases/cache/cache_helper.dart';

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
  int myid=CacheHelper().getData(key: "myid");
  double? maxCardHeight;

  @override
  void initState() {
    super.initState();
    _groups = fetchGroups(myid); // يمكنك استبدال الرقم 1 برقم ID الديناميكي
  }

  Future<List<Group>> fetchGroups(int id) async {
    final response = await http.get(
      Uri.parse("http://127.0.0.1:8091/group/my-groups?creatorId=1"),
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

        return group.recordStatus != false; //todo: cache

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
        title: const Text(
          'Groups',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Tooltip(
                message: 'Create a new group',
                textStyle: const TextStyle(color: Colors.white),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    context.go('/GroupCreationPage');
                  },
                  icon: const Icon(Icons.add_box_outlined, color: Color(0xff2196f3)),


                  label: const Text(
                    'Create Group',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
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
                            : Colors.blueAccent,
                      ),
                    ),
                    backgroundColor: selectedCategory == category
                        ? Colors.blueAccent
                        : Colors.grey[200],
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  Widget _buildSortToggle() {
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
              const Icon(Icons.sort, color: Colors.blueAccent),
              const SizedBox(width: 8),
              const Text(
                "Sort by:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButton<bool>(
                  value: _sortByNewest,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
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
                      _sortByNewest = value!;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildGroupBox(Group group) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverIndex = group.id),
      onExit: (_) => setState(() => _hoverIndex = null),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // تحديث maxCardHeight بأكبر ارتفاع بين البطاقات
          if (maxCardHeight == null || constraints.maxHeight > maxCardHeight!) {
            maxCardHeight = constraints.maxHeight;
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: constraints.maxWidth, // عرض ثابت بناءً على العرض المتاح
            height: maxCardHeight, // تعيين أكبر ارتفاع
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: _hoverIndex == group.id
                  ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10.0,
                  offset: const Offset(0, 5),
                )
              ]
                  : [
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.asset(
                    'assets/images/group.png', // رابط لصورة أيقونة المجموعة
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  group.groupName.isNotEmpty ? group.groupName : "لا اسم للغروب",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('yyyy-MM-dd').format(group.creationDate)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        },
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
      groupName: json['groupName'] ?? "لا اسم للغروب", // إذا كانت null تعيين النص الافتراضي
      creator: json['creator'],
      creationDate: DateTime.parse(json['creationDate']),
      recordStatus: json['recordStatus'],
    );
  }
}
