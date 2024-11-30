import 'package:flutter/material.dart';
import '../group_pages/browse_page.dart';
import '../group_pages/members_page.dart';
import '../group_pages/settings_page.dart';

class GroupForm extends StatefulWidget {
  final int groupId;
  final bool isOtherFilter;

  const GroupForm({super.key, required this.groupId, this.isOtherFilter = false});

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  Widget _selectedPage =  BrowsePage();
  String _selectedLabel = "Browse";

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return Row(
            children: [
              Container(
                width: isMobile ? 80 : constraints.maxWidth * 0.25,
                color:Theme.of(context).appBarTheme.backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Image.asset("assets/images/group/group_pic2.png"),
                        ),
                        if (!isMobile) ...[
                          const SizedBox(height: 10),
                          Text(
                            "Group ID: ${widget.groupId}",
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

                    Expanded(
                      child: ListView(
                        children: [
                          _buildMenuButton(
                            label: "Browse",
                            icon: Icons.open_in_browser,
                            isMobile: isMobile,
                            onTap: () => _changePage( BrowsePage(), "Browse"),
                          ),
                          _buildMenuButton(
                            label: "Members",
                            icon: Icons.people,
                            isMobile: isMobile,
                            onTap: () => _changePage(
                              MembersPage(
                                groupId: widget.groupId,
                                isOtherFilter: widget.isOtherFilter,
                              ),
                              "Members",
                            ),
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
    final bool isSelected = _selectedLabel == label;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.white,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
          children: [
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
            if (!isMobile)
              Icon(
                Icons.arrow_forward_ios,
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
      _selectedLabel = label;
    });
  }
}
