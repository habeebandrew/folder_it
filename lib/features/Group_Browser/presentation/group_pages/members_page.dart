import 'package:flutter/material.dart';
import 'package:folder_it/features/Groups/presentation/pages/invite_member_page.dart';

class MembersPage extends StatelessWidget {
  const MembersPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      actions: [
        Tooltip(
          message: 'invite new memeber',
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context){
                        return const InviteMemberPage();
                      }
                    );

                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text('Invite memeber',
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
    //! habeeb List of memebers
   );
  }
}
