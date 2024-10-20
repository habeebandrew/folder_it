import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_applications/Presentaion/Home%20Screen/widgets/groups_and_files_widgets.dart';
import 'package:internet_applications/Util/constants.dart';
import '../../BusinessLogic/Groups Bloc/groups_bloc.dart';
import '../../Util/global widgets/dialogs_widgets.dart';
import '../../Util/global widgets/somthing_wrong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Uint8List? webFile;

  Future<void> takeImage(ImageSource source) async {
    try {
      XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) {
        var f = await file.readAsBytes();
        setState(() {
          webFile = f;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        body: BlocProvider(
          create: (context) => GroupsBloc()
            ..add(GetGroupsEvent())
          ,
          child: BlocListener<GroupsBloc, GroupsState>(
            listener: (context, state) {
              if (state is GroupsErrorState) {
                DialogsWidgets.showScaffoldSnackBar(
                    title: state.error, context: context);
              }
            },
            child: Column(
              children: [
                Container(
                  width: getWidth(context),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(
                      horizontal: getWidth(context) * .02, vertical: 10),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Groups",
                        style: TextStyle(
                            color: kDarkBlueColor,
                            fontFamily: kNormalFont,
                            fontSize: 10),
                      ),
                      BlocBuilder<GroupsBloc, GroupsState>(
                        builder: (context, state) {
                          return TextButton(
                              onPressed: () {
                                DialogsWidgets.showCreateGroupDialogWithBloc(
                                    title: "Create a group to share files",
                                    noTitle: "Cancel",
                                    yesTitle: "Create",
                                    bloc: context.read<GroupsBloc>(),
                                    onNoTap: () {
                                      Navigator.pop(context);
                                    },
                                    context: context);
                              },
                              child: const Text("Create Group",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: kDarkBlueColor,
                                      fontFamily: kNormalFont,
                                      fontSize: 10)));
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<GroupsBloc, GroupsState>(
                    builder: (context, state) {
                      if (state is GroupsLoadedState && state.groups.isNotEmpty) {
                        return ListView.builder(
                          itemBuilder: (context, index) => groupWidget(
                              context, context.read<GroupsBloc>(), state, index),
                          itemCount: state.groups.length,
                        );
                      }
                      if (state is GroupsLoadedState) {
                        return SomethingWentWrongWidget(
                          text: "No Groups Found !",
                          svg: "assets/icons/groups.svg",
                        );
                      }
                      if (state is GroupsErrorState) {
                        return SomethingWentWrongWidget(
                          text: state.error,
                          svg: "assets/icons/groups.svg",
                        );
                      }
                      if (state is GroupsLoadingState ||
                          state is GroupsInitialState) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: kDarkBlueColor,
                        ));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
