import 'package:flutter/material.dart';
import '../group_pages/browse_page.dart';
import '../group_pages/members_page.dart';
import '../group_pages/settings_page.dart';

class GroupForm extends StatefulWidget {
  const GroupForm({super.key});

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  Widget _selectedPage = const BrowsePage();
  String _selectedLabel = "Browse"; // لتعقب الزر المحدد حاليًا

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
                color: Theme.of(context).primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // الصورة والاسم
                    Column(
                      children: [
                         CircleAvatar(
                          radius: 40,
                          backgroundColor:  Theme.of(context).primaryColor,
                          child: Image.asset("assets/images/group/group_pic2.png")
                        ),
                        if (!isMobile) ...[
                          const SizedBox(height: 10),
                          Text(
                            "group name",
                            style: const TextStyle(
                              color: Colors.white ,
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
                            label: "Browse",
                            icon: Icons.home,
                            isMobile: isMobile,
                            onTap: () => _changePage(const BrowsePage(), "Browse"),
                          ),
                          _buildMenuButton(
                            label: "Members",
                            icon: Icons.people,
                            isMobile: isMobile,
                            onTap: () => _changePage(const MembersPage(), "Members"),
                          ),
                          _buildMenuButton(
                            label: "Setting",
                            icon: Icons.settings,
                            isMobile: isMobile,
                            onTap: () => _changePage(const SettingsPage(), "Setting"),
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
    final bool isSelected = _selectedLabel == label; // تحقق مما إذا كان الزر هو المحدد حاليًا
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // إضافة مسافة حول الزر
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent, // لون الخلفية بناءً على الحالة
          borderRadius: BorderRadius.circular(12), // حواف دائرية
          border: Border.all(
            color: isSelected ? Colors.blueGrey[900]! : Colors.white, // لون الإطار
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
          children: [
            // الأيقونة والنص الأساسيين
            Row(
              children: [
                Icon(icon, color: isSelected ? Colors.blueGrey[900] : Colors.white, size: 24),
                if (!isMobile) ...[
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.blueGrey[900] : Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
            // الأيقونة على اليمين
            if (!isMobile)
              Icon(
                Icons.arrow_forward_ios, // أيقونة على اليمين
                size: 16,
                color: isSelected ? Colors.blueGrey[900] : Colors.white,
              ),
          ],
        ),
      ),
    );
  }


  void _changePage(Widget page, String label) {
    setState(() {
      _selectedPage = page;
      _selectedLabel = label; // تحديث الزر المحدد حاليًا
    });
  }
}
