import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:folder_it/features/Groups/presentation/cubit/group_cubit.dart';
import 'package:folder_it/features/User/presentation/widgets/custom_form_field.dart';
import '../../../../localization/localization.dart';

class InviteMemberPage extends StatelessWidget {
  final int groupId;
  const InviteMemberPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state is GroupFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        if (state is GroupSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalization.of(context)?.translate('member_invited') ?? 'Member invited'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = GroupCubit.get(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: SvgPicture.asset(
                    'assets/icons/invite.svg',
                    height: 60.0,
                    width: 70.0,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  AppLocalization.of(context)?.translate('invite_new_member') ?? 'Invite New Member to Group',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                customFormFiled(
                  controller: cubit.userNameController,
                  label: AppLocalization.of(context)?.translate('name') ?? 'Name',
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: state is GroupLoadingState
                          ? null
                          : () {
                        cubit.inviteMember(
                          userName: cubit.userNameController.text,
                          groupId: groupId,
                          context: context,
                        );
                      },
                      child: state is GroupLoadingState
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      )
                          : Text(
                        AppLocalization.of(context)?.translate('invite') ?? 'Invite',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                      ),
                      onPressed: () {
                        cubit.userNameController.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppLocalization.of(context)?.translate('cancel') ?? 'Cancel',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
