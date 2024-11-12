import 'package:flutter/material.dart';

Widget customInviteCard({required int index, required String groupName,required int inviteId}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        child: ListTile(
          title: Text('invite no.${index + 1}'),
          subtitle:
              Text('you have an invitation to $groupName'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () {
                  debugPrint('$inviteId');
                  //! handle accept invitation
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () {
                  debugPrint('$inviteId');
                  //! handle decline invitation
                },
              ),
            ],
          ),
        ),
      ),
    );
