import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:folder_it/features/Groups/presentation/cubit/group_cubit.dart';
import 'package:folder_it/features/Groups/presentation/widgets/custom_invite_card.dart';

class InvitesPage extends StatelessWidget {
  const InvitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: GroupCubit()..viewMyInvites(),
        child: BlocConsumer<GroupCubit, GroupState>(
          listener: (context, state) {},
          builder: (context, state) {
            return AlertDialog(
              title: const Text(
                'my invites ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: state is GroupGetInvitesSuccess
                    ? state.invites.isEmpty
                        ? const Center(child: Text('you have no invites'))
                        : ListView.builder(
                            itemCount: state.invites.length,
                            itemBuilder: (context, index) {
                              var invites = state.invites[index];

                              return customInviteCard(
                                  context: context,
                                  index: index,
                                  groupId: invites.group.groupId,
                                  groupName: invites.group.groupName,
                                  inviteId: invites.inviteId);
                            })
                    : state is GroupFailureState
                        ? Text(state.message)
                        : const Center(child: CircularProgressIndicator()),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('close',
                      style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            );
          },
        ));
  }
}
