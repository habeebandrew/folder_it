import 'package:flutter/material.dart';
import 'package:folder_it/features/Groups/presentation/cubit/group_cubit.dart';

Widget customInviteCard(
        {required BuildContext context,
        required int index,
        required int groupId,
        required String groupName,
        required int inviteId}) {
          final  screenWidth =MediaQuery.sizeOf(context).width*0.03;
    double _screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: 
      _screenWidth>=600.0?
      Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        child: ListTile(
          title: Text(
            ' invitaion no.${index + 1}',
            style: TextStyle(fontSize: screenWidth),
          ),
          subtitle: Text('invitaion to $groupName',            style: TextStyle(fontSize: screenWidth),
),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  GroupCubit.get(context).acceptOrRejectInvite(
                      inviteId: inviteId,
                      groupId: groupId,
                      inviteStatus: 3,
                      context: context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  GroupCubit.get(context).acceptOrRejectInvite(
                      inviteId: inviteId,
                      groupId: groupId,
                      inviteStatus: 2,
                      context: context);
                },
              ),
            ],
          ),
        ),
      )
      :Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        child: ListTile(
          title: Text(
            ' invitaion no.${index + 1}',
            style: TextStyle(fontSize: screenWidth),
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('invitaion to $groupName',            style: TextStyle(fontSize: screenWidth),
              ),
               Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  GroupCubit.get(context).acceptOrRejectInvite(
                      inviteId: inviteId,
                      groupId: groupId,
                      inviteStatus: 3,
                      context: context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  GroupCubit.get(context).acceptOrRejectInvite(
                      inviteId: inviteId,
                      groupId: groupId,
                      inviteStatus: 2,
                      context: context);
                },
              ),
            ],
          ),
            ],
          ),
          
        ),
      )
    );
}