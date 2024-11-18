import 'package:flutter/material.dart';
import '../group_pages/browse_page.dart';
import '../group_pages/members_page.dart';
import '../group_pages/settings_page.dart';
import '../group_pages/tasks_page.dart';

class GroupForm extends StatefulWidget {
  const GroupForm({super.key});

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  Widget _selectedPage = const BrowsePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // تحديد إذا كان الجهاز هاتفاً أو جهازاً لوحياً/حاسوباً
          bool isMobile = constraints.maxWidth < 600;

          return Row(
            children: [
              // القائمة الجانبية
              Container(
                width: isMobile ? 80 : constraints.maxWidth * 0.25, // عرض ديناميكي
                color: Colors.blueGrey[900],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // الصورة والاسم
                    Column(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                        if (!isMobile) ...[
                          const SizedBox(height: 10),
                          Text(
                            "اسم المستخدم",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    // الأزرار
                    Expanded(
                      child: ListView(
                        children: [
                          _buildMenuButton(
                            label: "تصفح",
                            icon: Icons.home,
                            isMobile: isMobile,
                            onTap: () => _changePage(const BrowsePage()),
                          ),
                          _buildMenuButton(
                            label: "الأعضاء",
                            icon: Icons.people,
                            isMobile: isMobile,
                            onTap: () => _changePage(const MembersPage()),
                          ),
                          _buildMenuButton(
                            label: "الإعدادات",
                            icon: Icons.settings,
                            isMobile: isMobile,
                            onTap: () => _changePage(const SettingsPage()),
                          ),
                          _buildMenuButton(
                            label: "المهمات",
                            icon: Icons.task,
                            isMobile: isMobile,
                            onTap: () => _changePage(const TasksPage()),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // الشاشة اليمنى
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _selectedPage,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuButton({
    required String label,
    required IconData icon,
    required bool isMobile,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            if (!isMobile) ...[
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _changePage(Widget page) {
    setState(() {
      _selectedPage = page;
    });
  }
}