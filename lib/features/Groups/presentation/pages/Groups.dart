import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  String selectedCategory = 'All';
  int? _hoverIndex; // Track the index of the hovered box

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int columns = screenWidth > 870
        ? 5
        : screenWidth > 600
            ? 4
        : screenWidth > 378 ?3
            : 2;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups',style: TextStyle(fontWeight:FontWeight.bold ),),
        actions: [
          TextButton.icon(
            onPressed: () {
              context.go('/GroupCreationPage');
            },
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text(
              'create new group',
              style: TextStyle(color: Colors.black),
            ),
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
              child: _buildCategoryFilterBar(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: 20, // Replace with dynamic item count
                itemBuilder: (context, index) {
                  return _buildGroupBox(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilterBar() {
    final categories = ['All', 'My Groups', 'Others', 'Deleted'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: categories.map((category) {
        return Row(
          children: [
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
                    color: selectedCategory == category
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                backgroundColor: selectedCategory == category
                    ? Colors.blue
                    : Colors.grey[200],
              ),
            ),
            const SizedBox(width: 15),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildGroupBox(int index) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoverIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          _hoverIndex = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: _hoverIndex == index
            ? (Matrix4.identity()
              ..scale(
                  1.05)) // Ensure that `..scale(1.05)` is within parentheses
            : Matrix4.identity(),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: _hoverIndex == index
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10.0,
                    offset: const Offset(0, 5),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Image.network(
                'data:image/jpeg;base64,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',
                // Placeholder image URL
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Group Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
