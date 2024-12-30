import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'FileListScreen.dart';
import 'admin_screen.dart';

class CombinedScreen extends StatefulWidget {
  @override
  _CombinedScreenState createState() => _CombinedScreenState();
}

class _CombinedScreenState extends State<CombinedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Combined Screens',
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold,textStyle: const TextStyle(color: Colors.white)),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white, // لون النص للتبويب النشط
          unselectedLabelColor: Colors.white70, // لون النص للتبويب غير النشط
          tabs: [
            Tab(icon: Icon(Icons.admin_panel_settings,color: Colors.white,), text: 'Admin'),
            Tab(icon: Icon(Icons.file_copy,color: Colors.white,), text: 'Files'),
          ],
        ),

      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AdminScreen(),
          FileListScreen(),
        ],
      ),
    );
  }
}