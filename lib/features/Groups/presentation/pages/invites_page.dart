import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/features/Groups/presentation/cubit/group_cubit.dart';
import 'package:folder_it/features/Groups/presentation/widgets/custom_invite_card.dart';

class InvitesPage extends StatelessWidget {
  const InvitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {},
      builder: (context, state) {
        return AlertDialog(
          title: const Text(
            'my invites ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: 
            state is GroupGetInvitesSuccess
            ?ListView.builder(
                itemCount: state.invites.length,
                itemBuilder: (context, index) {
                  var invites = state.invites[index];
                  if(state.invites.isEmpty){
                    return const Center(
                      child: Text(
                        'you have no invites'
                      )
                    ) ;
                  }else{
                  return customInviteCard(
                    index: index, 
                    groupName: invites.group.groupName, 
                    inviteId: invites.inviteId
                  );
                }
              }
            )
            : state is GroupFailureState
            ? Text(state.message)
            : const Center(child: CircularProgressIndicator()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('close'),
            ),
          ],
        );
      },
    );
  }
}
