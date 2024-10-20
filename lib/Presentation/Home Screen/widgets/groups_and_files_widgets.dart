import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_applications/Util/api_&_endpoints.dart';
import 'package:intl/intl.dart';
import '../../../BusinessLogic/Groups Bloc/groups_bloc.dart';
import '../../../Util/constants.dart';
import '../../../Util/global widgets/dialogs_widgets.dart';
import '../../../Util/global widgets/somthing_wrong.dart';
import 'package:universal_html/html.dart' as html;

Container groupWidget(BuildContext context, GroupsBloc groupsBloc,
    GroupsLoadedState groupsState, int index) {
  bool reserveFiles = false;

  return Container(
    padding:
        EdgeInsets.symmetric(horizontal: getWidth(context) * .02, vertical: 10),
    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20)),
    child: StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          SizedBox(
            width: getWidth(context),
            child: ListTile(
              title: Text(
                groupsState.groups[index].name,
                style: const TextStyle(
                    color: kDarkBlueColor,
                    fontFamily: kSemiBoldFont,
                    fontSize: 10),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocProvider(
                    create: (context) => GroupsBloc(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          onPressed: () {
                            DialogsWidgets.showInviteDialogWithBloc(
                                svg: "assets/icons/invite.svg",
                                color: kPrimaryBlueColor,
                                title: 'Invite member to group',
                                noTitle: 'cancel',
                                yesTitle: 'Add',
                                onNoTap: () {
                                  Navigator.pop(context);
                                },
                                context: context,
                                bloc: context.read<GroupsBloc>(),
                                groupId: groupsState.groups[index].id);
                          },
                          child: const Text(
                            "Invite",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: kNormalFont,
                                fontSize: 8),
                          )),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => GroupsBloc(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          onPressed: () {
                            DialogsWidgets.uploadFileToGroupDialog(
                                title:
                                    "upload file to ${groupsState.groups[index].name}",
                                noTitle: "Cancel",
                                yesTitle: "Upload",
                                bloc: context.read<GroupsBloc>(),
                                onNoTap: () {
                                  Navigator.pop(context);
                                },
                                context: context,
                                groupId: groupsState.groups[index].id);
                          },
                          child: const Text(
                            "Upload",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: kNormalFont,
                                fontSize: 8),
                          )),
                    ),
                  ),
                  if (groupsState.groups[index].files!.isNotEmpty)
                    BlocProvider(
                      create: (context) => GroupsBloc(),
                      child: BlocBuilder<GroupsBloc, GroupsState>(
                        builder: (context, state) {
                          return BlocListener<GroupsBloc, GroupsState>(
                            listener: (context, state) {
                              if (state is GroupsPostedState) {
                                setState(() {
                                  groupsBloc.add(GetGroupsEvent());
                                  reserveFiles = false;
                                });
                              }
                              if (state is GroupsErrorState) {
                                DialogsWidgets.showScaffoldSnackBar(
                                    title: state.error, context: context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                  color: !reserveFiles
                                      ? Colors.orange
                                      : Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  onPressed: () {
                                    /// add request here
                                    if (reserveFiles) {
                                      List<int> reserve = [];
                                      List<int> unReserve = [];
                                      groupsState.groups[index].files!
                                          .forEach((element) {
                                        element.status == 1
                                            ? reserve.add(element.id)
                                            : unReserve.add(element.id);

                                      });

                                      context
                                          .read<GroupsBloc>()
                                          .add(ReserveFilesInGroupsEvent(
                                        reserve: reserve,
                                        unreserve: unReserve,
                                      ));

                                    } else {
                                      setState(() {
                                        reserveFiles = true;
                                      });
                                    }
                                  },
                                  child: Text(
                                    reserveFiles ? "Done" : "Reserve",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: kNormalFont,
                                        fontSize: 8),
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Divider(height: 10, thickness: 1),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getWidth(context) * .03, vertical: 10),
            child: Builder(builder: (context) {
              if (groupsState.groups[index].files!.isNotEmpty) {
                return Wrap(
                  spacing: 20,
                  direction: Axis.horizontal,
                  children: List.generate(
                    groupsState.groups[index].files!.length,
                    (filesIndex) => SizedBox(
                      height: 230,
                      width: 220,
                      child: fileWidget(context, groupsState, index, filesIndex,
                          reserveFiles),
                    ),
                  ),
                );
              }
              return SomethingWentWrongWidget(
                text: "No Files Yet !",
                svg: "assets/icons/groups.svg",
              );
            }),
          ),
        ],
      ),
    ),
  );
}

void downloadFile(String fileUrl, String fileName) {
  html.AnchorElement anchorElement = html.AnchorElement(href: fileUrl);
  anchorElement.download = fileName;
  anchorElement.click();
}

Padding fileWidget(BuildContext context, GroupsLoadedState state, int index,
    int filesIndex, bool reserveFiles) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: !reserveFiles &&
                        state.groups[index].files![filesIndex].status == 1
                    ? kPrimaryBlueColor
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            color: kBackgroundColor,
            boxShadow: [
              BoxShadow(
                  color: kGreyColor.withOpacity(.5),
                  offset: const Offset(0, 10),
                  blurRadius: 10)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (reserveFiles)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StatefulBuilder(
                    builder: (context, setState) => Checkbox(
                        fillColor: MaterialStateProperty.all(kPrimaryBlueColor),
                        checkColor: Colors.white,
                        splashRadius: 1,
                        value:
                            state.groups[index].files![filesIndex].status == 1,
                        onChanged: (value) {
                          setState(() {
                            state.groups[index].files![filesIndex].status =
                                state.groups[index].files![filesIndex].status ==
                                        0
                                    ? 1
                                    : 0;
                          });
                        }),
                  )
                ],
              ),
            SizedBox(
              height: !reserveFiles ? 40 : 10,
            ),
            const Icon(
              Icons.file_copy_rounded,
              size: 70,
              color: kGreyColor,
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  state.groups[index].files![filesIndex].title,
                  style: const TextStyle(
                      fontFamily: kSemiBoldFont,
                      fontSize: 8,
                      color: kDarkBlueColor),
                ),
                Text(
                    DateFormat("MMM d,yyyy").format(
                        state.groups[index].files![filesIndex].createdAt!),
                    style: const TextStyle(
                        fontFamily: kSemiBoldFont,
                        fontSize: 8,
                        color: kDarkBlueColor)),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            if (!reserveFiles &&
                state.groups[index].files![filesIndex].status == 1)
              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        onPressed: () {
                          DialogsWidgets.uploadFileToGroupDialog(
                              fileId: state.groups[index].files![filesIndex].id,
                              title:
                                  "Update ${state.groups[index].files![filesIndex].title} file",
                              noTitle: "Cancel",
                              yesTitle: "Update",
                              bloc: context.read<GroupsBloc>(),
                              onNoTap: () {
                                Navigator.pop(context);
                              },
                              context: context,
                              groupId: state.groups[index].id);
                        },
                        child: const Text(
                          "Update",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: kNormalFont,
                              fontSize: 8),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        onPressed: () {
                          String url =
                              state.groups[index].files![filesIndex].url
                              // .replaceAll("files", "app/public/files")
                              ;
                          log(EndPoints.kHost + url);
                          if (kIsWeb) {
                            downloadFile(EndPoints.kHost + url,
                                state.groups[index].files![filesIndex].title);
                          }
                        },
                        child: const Text(
                          "Download",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: kNormalFont,
                              fontSize: 8),
                        )),
                  ],
                ),
              ),
          ],
        ),
      ));
}
