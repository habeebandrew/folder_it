import 'package:flutter/material.dart';
import 'package:folder_it/core/databases/cache/cache_helper.dart';
import 'package:folder_it/features/Groups/presentation/cubit/group_cubit.dart';

Widget customInviteCard(
        { 
          required BuildContext context,
          required int index,
          required int groupId,
        required String groupName,
        required int inviteId}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        child: ListTile(
          title: Text(' invitaion no. ${index + 1}'),
          subtitle:  Text('invitaion to $groupName'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  
                  GroupCubit.get(context).acceptOrRejectInvite(
                    
                    inviteId: inviteId, groupId: groupId, 
                    inviteStatus: 3, context: context
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  GroupCubit.get(context).acceptOrRejectInvite(
                  
                    inviteId: inviteId, groupId: groupId, 
                    inviteStatus: 2, context: context
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
