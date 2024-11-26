import 'package:flutter/material.dart';
import 'package:folder_it/features/User/presentation/widgets/custom_form_field.dart';

class InviteMemberPage extends StatelessWidget {
  const InviteMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title:  Text('Invite new member',style: TextStyle(fontSize: Theme.of(context).textTheme.bodySmall!.fontSize),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customFormFiled(
            controller: TextEditingController(),
            label: 'UserName',
            prefixIcon: Icons.person
          ),
          const SizedBox(height: 15.0,),
          Center(
                      child:
                           ElevatedButton(
                              style: Theme.of(context).elevatedButtonTheme.style,
                              onPressed: () async {
                                
                              },
                              child:  Text(
                                'invite',
                                style:Theme.of(context).textTheme.bodyMedium!.apply(color:Colors.white)
                                )
                              ),
                            ),

        ],
      ),
    );
  }
}