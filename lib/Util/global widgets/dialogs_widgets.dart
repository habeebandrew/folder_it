import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../BusinessLogic/Groups Bloc/groups_bloc.dart';
import '../../BusinessLogic/user_bloc/user_bloc.dart';
import '../constants.dart';
import 'custom_text_field.dart';
import 'elevated_button_widget.dart';

class DialogsWidgets {
  static void showScaffoldSnackBar(
      {required String title,
      double horizontalPadding = 20,
      required BuildContext context,
      Color color = Colors.red,
      bool popAfter = false}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          // dismissDirection: DismissDirection.none,
          content: Container(
            child: Column(
              mainAxisSize: kIsWeb && mobileMaxWidth < getWidth(context)
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      height: 1.2, fontFamily: kNormalFont, fontSize: 13),
                ),
              ],
            ),
          ),
          margin: kIsWeb && mobileMaxWidth < getWidth(context)
              ? EdgeInsets.fromLTRB(
                  getWidth(context) - 480, 0, 40, getHeight(context) - 140)
              : EdgeInsets.fromLTRB(
                  horizontalPadding, 0, horizontalPadding, 40),

          backgroundColor: color,
          duration: const Duration(milliseconds: 1800),
        ))
        .closed
        .then((SnackBarClosedReason reason) {
      if (popAfter) {
        Navigator.of(context).pop();
      }
    });
  }

  static void showLogoutDeleteAccountDialog(
      {required BuildContext context, required bool isDeleteAccount}) {
    double getWidth = MediaQuery.of(context).size.width;
    double getHeight = MediaQuery.of(context).size.height;
    var alertDialog = Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
            vertical:
                kIsWeb && mobileMaxWidth < getWidth ? getHeight * .25 : 15,
            horizontal:
                kIsWeb && mobileMaxWidth < getWidth ? getWidth * .35 : 15),
        child: BlocProvider(
          create: (context) => UserBloc(),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: getHeight * 0.01,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.white),
                  padding: EdgeInsets.fromLTRB(getWidth * 0.038,
                      getWidth * 0.04, getWidth * 0.038, getWidth * 0.04),
                  child: Wrap(
                    spacing: 10,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           Center(
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: kPrimaryBlueColor.withOpacity(.2),
                              child:const Icon(Icons.logout,size: 50,color: kPrimaryBlueColor,)
                            ),
                          ),
                          SizedBox(
                            height: getHeight * .03,
                          ),
                          Text(
                              isDeleteAccount
                                  ? 'Do you want to delete your account?'
                                  : 'Do you want to log out?',
                              style: const TextStyle(
                                  fontFamily: kNormalFont,
                                  fontSize: 15,
                                  color: Colors.black,
                                  height: 1.2),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      SizedBox(height: getHeight * .02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButtonWidget(
                                color: state is! UserLoadingState
                                    ? Colors.red
                                    : Colors.red.withOpacity(.3),
                                title: state is UserLoadingState
                                    ? "...."
                                    : isDeleteAccount
                                        ? "yes"
                                        : "Logout",
                                fontFamily: kNormalFont,
                                onPressed: state is UserLoadingState
                                    ? () {}
                                    : () {
                                        context.read<UserBloc>().add(
                                            LogOutEvent(
                                                deleteAccount:
                                                    isDeleteAccount));
                                      }),
                          ),
                          SizedBox(
                            width: kIsWeb && mobileMaxWidth < getWidth
                                ? getWidth * .02
                                : getWidth * 0.038,
                          ),
                          Expanded(
                            child: ElevatedButtonWidget(
                              title: "cancel",
                              color: kGreyColor,
                              isSelected: false,
                              border: false,
                              // fontFamily: kNormalFont,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  static void showInviteDialogWithBloc({
    required String title,
    required String noTitle,
    required String yesTitle,
    required int groupId,
    String? svg,
    Widget? textWidget,
    required GroupsBloc bloc,
    required Function() onNoTap,
    required BuildContext context,
    Color color = Colors.grey,
  }) {
    double getWidth = MediaQuery.of(context).size.width;
    double getHeight = MediaQuery.of(context).size.height;
    final GlobalKey<FormState> _key = GlobalKey<FormState>();

    TextEditingController textEditingController = TextEditingController();
    List<TextEditingController> textControllers = [textEditingController];
    var alertDialog = Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: kIsWeb && mobileMaxWidth < getWidth ? getWidth * .3 : 20,
        ),
        child: Wrap(
          children: [
            StatefulBuilder(
              builder: (context, setState) => Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white),
                child: BlocProvider(
                  create: (context) => GroupsBloc(),
                  child: Form(
                    key: _key,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: getHeight * 0.01,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Colors.white),
                        padding: EdgeInsets.fromLTRB(getWidth * 0.038,
                            getWidth * 0.02, getWidth * 0.038, getWidth * 0.02),
                        child: Wrap(
                          spacing: 10,
                          children: [
                            Center(
                              child: Builder(builder: (context) {
                                if (textWidget != null) {
                                  return textWidget;
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (svg != null)
                                      CircleAvatar(
                                          radius: 45,
                                          backgroundColor:
                                              kPrimaryBlueColor.withOpacity(.2),
                                          // child: SvgPicture.asset(
                                          //   svg,
                                          // ),
                                          child: const Icon(
                                            Icons.group_add_sharp,
                                            size: 50,
                                            color: kPrimaryBlueColor,
                                          )),
                                    SizedBox(
                                      height: getHeight * .03,
                                    ),
                                    Text(title,
                                        style: const TextStyle(
                                            fontFamily: kNormalFont,
                                            fontSize: 15,
                                            color: Colors.black,
                                            height: 1.2),
                                        textAlign: TextAlign.center),
                                    SizedBox(
                                      height: getHeight * .03,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: textControllers.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: CustomTextField(
                                            suffixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getWidth * .01),
                                                child: const Icon(
                                                    Icons.email_outlined,
                                                    color: kGreyColor)),
                                            validator: (val) {
                                              if (val == null || val == "") {
                                                return 'invalid input';
                                              }
                                              return null;
                                            },
                                            maxLines: 1,
                                            controller2: textControllers[index],
                                            passwordBool: false,
                                            hintText: 'Enter an Email',
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }),
                            ),
                            SizedBox(height: getHeight * .007),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (textControllers.length < 5)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Add More Members",
                                        style: TextStyle(
                                            color: kPrimaryBlueColor,
                                            fontFamily: kNormalFont,
                                            fontSize: 11),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 40,
                                        height: 30,
                                        child: MaterialButton(
                                          onPressed: () {
                                            TextEditingController
                                                newTextController =
                                                TextEditingController();
                                            setState(() {
                                              textControllers
                                                  .add(newTextController);
                                            });
                                          },
                                          color: kBackgroundColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Icon(
                                            Icons.add,
                                            color: kPrimaryBlueColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (textControllers.length > 1)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Remove Field",
                                        style: TextStyle(
                                            color: kPrimaryBlueColor,
                                            fontFamily: kNormalFont,
                                            fontSize: 11),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 40,
                                        height: 30,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              textControllers.removeLast();
                                            });
                                          },
                                          color: kBackgroundColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                            SizedBox(height: getHeight * .04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                BlocListener<GroupsBloc, GroupsState>(
                                  listener: (context, state) {
                                    if (state is GroupsPostedState) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: BlocBuilder<GroupsBloc, GroupsState>(
                                    builder: (context, state) {
                                      return Expanded(
                                        child: ElevatedButtonWidget(
                                            color: state is GroupsLoadingState
                                                ? kPrimaryBlueColor
                                                    .withOpacity(.5)
                                                : kPrimaryBlueColor,
                                            title: state is GroupsLoadingState
                                                ? "Loading .."
                                                : yesTitle,
                                            fontFamily: kNormalFont,
                                            onPressed: state
                                                    is GroupsLoadingState
                                                ? () {}
                                                : () {
                                                    if (_key.currentState!
                                                        .validate()) {
                                                      List<String> emails = [];
                                                      textControllers
                                                          .forEach((element) {
                                                        emails
                                                            .add(element.text);
                                                      });
                                                      context
                                                          .read<GroupsBloc>()
                                                          .add(
                                                              InviteMemberToGroupsEvent(
                                                                  groupId:
                                                                      groupId,
                                                                  emails:
                                                                      emails));
                                                    }
                                                  }),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: getWidth * 0.038,
                                ),
                                Expanded(
                                  child: ElevatedButtonWidget(
                                    title: noTitle,
                                    color: Colors.grey,
                                    isSelected: false,
                                    border: false,
                                    fontFamily: kNormalFont,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  static void showCreateGroupDialogWithBloc({
    required String title,
    required String noTitle,
    required String yesTitle,
    Widget? textWidget,
    required GroupsBloc bloc,
    required Function() onNoTap,
    required BuildContext context,
    Color color = Colors.grey,
  }) {
    double getWidth = MediaQuery.of(context).size.width;
    double getHeight = MediaQuery.of(context).size.height;
    final GlobalKey<FormState> _key = GlobalKey<FormState>();

    TextEditingController textEditingController = TextEditingController();
    var alertDialog = Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: kIsWeb && mobileMaxWidth < getWidth ? getWidth * .3 : 20,
        ),
        child: Wrap(
          children: [
            SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) => Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white),
                  child: BlocProvider(
                    create: (context) => GroupsBloc(),
                    child: Form(
                      key: _key,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: getHeight * 0.01,
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Colors.white),
                          padding: EdgeInsets.fromLTRB(
                              getWidth * 0.038,
                              getWidth * 0.04,
                              getWidth * 0.038,
                              getWidth * 0.04),
                          child: Wrap(
                            spacing: 10,
                            children: [
                              Center(
                                child: Builder(builder: (context) {
                                  if (textWidget != null) {
                                    return textWidget;
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                          radius: 45,
                                          backgroundColor:
                                              kPrimaryBlueColor.withOpacity(.2),
                                          child: const Icon(
                                            Icons.group_add_outlined,
                                            size: 50,
                                            color: kPrimaryBlueColor,
                                          )),
                                      SizedBox(
                                        height: getHeight * .03,
                                      ),
                                      Text(title,
                                          style: const TextStyle(
                                              fontFamily: kNormalFont,
                                              fontSize: 15,
                                              color: Colors.black,
                                              height: 1.2),
                                          textAlign: TextAlign.center),
                                      SizedBox(
                                        height: getHeight * .03,
                                      ),
                                      CustomTextField(
                                        suffixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getWidth * .01),
                                            child: const Icon(
                                                Icons.text_format_rounded,
                                                color: kGreyColor)),
                                        validator: (val) {
                                          if (val == null || val == "") {
                                            return 'this field is required';
                                          }
                                          return null;
                                        },
                                        maxLines: 1,
                                        controller2: textEditingController,
                                        passwordBool: false,
                                        hintText: 'Enter group name',
                                      )
                                    ],
                                  );
                                }),
                              ),
                              SizedBox(height: getHeight * .05),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  BlocListener<GroupsBloc, GroupsState>(
                                    listener: (context, state) {
                                      if (state is GroupsPostedState) {
                                        Navigator.pop(context);
                                        bloc.add(GetGroupsEvent());
                                      }
                                    },
                                    child: BlocBuilder<GroupsBloc, GroupsState>(
                                      builder: (context, state) {
                                        return Expanded(
                                          child: ElevatedButtonWidget(
                                              color: state is GroupsLoadingState
                                                  ? kPrimaryBlueColor
                                                      .withOpacity(.5)
                                                  : kPrimaryBlueColor,
                                              title: state is GroupsLoadingState
                                                  ? "Loading .."
                                                  : yesTitle,
                                              fontFamily: kNormalFont,
                                              onPressed: state
                                                      is GroupsLoadingState
                                                  ? () {}
                                                  : () {
                                                      if (_key.currentState!
                                                          .validate()) {
                                                        context
                                                            .read<GroupsBloc>()
                                                            .add(CreateGroupsEvent(
                                                                groupName:
                                                                    textEditingController
                                                                        .text));
                                                      }
                                                    }),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: getWidth * 0.038,
                                  ),
                                  Expanded(
                                    child: ElevatedButtonWidget(
                                      title: noTitle,
                                      color: Colors.grey,
                                      isSelected: false,
                                      border: false,
                                      fontFamily: kNormalFont,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  static void uploadFileToGroupDialog({
    required String title,
    required String noTitle,
    required String yesTitle,
    Widget? textWidget,
    required int groupId,
    int? fileId,
    required GroupsBloc bloc,
    required Function() onNoTap,
    required BuildContext context,
    Color color = Colors.grey,
  }) {

    final GlobalKey<FormState> _key = GlobalKey<FormState>();
    Uint8List? webFile;
    TextEditingController textEditingController = TextEditingController();
    var alertDialog = Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: kIsWeb && tabMaxWidth < getWidth(context) ? getWidth (context) * .3 :
          mobileMaxWidth < getWidth(context)  ?100:20
          ,
        ),
        child: Wrap(
          children: [
            StatefulBuilder(
              builder: (context, setState) => Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white),
                child: BlocProvider(
                  create: (context) => GroupsBloc(),
                  child: Form(
                    key: _key,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: getHeight(context)  * 0.01,
                      ),
                      child: Container(
                        // width: double.infinity,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Colors.white),
                        padding: EdgeInsets.fromLTRB(getWidth (context) * 0.038,
                            getWidth(context)  * 0.04, getWidth(context)  * 0.038, getWidth(context)  * 0.04),
                        child: Wrap(
                          spacing: 10,
                          children: [
                            Center(
                              child: Builder(builder: (context) {
                                if (textWidget != null) {
                                  return textWidget;
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                        radius: 45,
                                        backgroundColor:
                                            kPrimaryBlueColor.withOpacity(.2),
                                        child: const Icon(
                                          Icons.cloud_upload_outlined,
                                          color: kPrimaryBlueColor,
                                          size: 50,
                                        )),
                                    SizedBox(
                                      height: getHeight (context) * .03,
                                    ),
                                    Text(title,
                                        style: const TextStyle(
                                            fontFamily: kNormalFont,
                                            fontSize: 15,
                                            color: Colors.black,
                                            height: 1.2),
                                        textAlign: TextAlign.center),
                                    SizedBox(
                                      height: getHeight (context) * .03,
                                    ),
                                    if (fileId == null)
                                      CustomTextField(
                                        suffixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getWidth(context)  * .01),
                                            child: const Icon(
                                                Icons.file_copy_outlined,
                                                color: kGreyColor)),
                                        validator: (val) {
                                          if (val == null || val == "") {
                                            return 'this field is required';
                                          }
                                          return null;
                                        },
                                        maxLines: 1,
                                        controller2: textEditingController,
                                        passwordBool: false,
                                        hintText: 'File Name',
                                      ),
                                    if (fileId == null)
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 0,
                                        minimumSize: Size(
                                            double.infinity, getHeight (context) * 0.12),
                                        maximumSize: Size(
                                            double.infinity, getHeight(context)  * 0.12),
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.grey,
                                        surfaceTintColor: Colors.white,
                                      ),
                                      onPressed: () async {
                                        try {
                                          XFile? file = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          if (file != null) {
                                            var f = await file.readAsBytes();
                                            setState(() {
                                              webFile = f;
                                            });
                                          }
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: getWidth (context) * .07),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Icon(
                                              Icons.image,
                                              size: 50,
                                              color: kGreyColor,
                                            ),
                                            SizedBox(
                                              width: getWidth(context)  * .04,
                                            ),
                                            Text(
                                              webFile != null
                                                  ? 'you picked a file'
                                                  : 'Upload File',
                                              style: TextStyle(
                                                  color: webFile != null
                                                      ? Colors.green
                                                      : kDarkBlueColor,
                                                  fontFamily: kBoldFont,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Spacer(),
                                            const CircleAvatar(
                                              radius: 12,
                                              backgroundColor: kDarkBlueColor,
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                            SizedBox(height: getHeight(context)  * .04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                BlocListener<GroupsBloc, GroupsState>(
                                  listener: (context, state) {
                                    if (state is GroupsPostedState) {
                                      Navigator.pop(context);
                                      bloc.add(GetGroupsEvent());
                                    }
                                  },
                                  child: BlocBuilder<GroupsBloc, GroupsState>(
                                    builder: (context, state) {
                                      return Expanded(
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          width: state is GroupsLoadingState
                                              ? 50
                                              : null,
                                          child: ElevatedButtonWidget(
                                              color: state is GroupsLoadingState
                                                  ? kPrimaryBlueColor
                                                      .withOpacity(.5)
                                                  : kPrimaryBlueColor,
                                              title: state is GroupsLoadingState
                                                  ? "Loading .."
                                                  : yesTitle,
                                              fontFamily: kNormalFont,
                                              onPressed: state
                                                      is GroupsLoadingState
                                                  ? () {}
                                                  : () {
                                                      if (_key.currentState!
                                                          .validate()) {
                                                        if (fileId == null) {
                                                          context
                                                              .read<
                                                                  GroupsBloc>()
                                                              .add(UploadFileToGroupsEvent(
                                                                  webFile:
                                                                      webFile!,
                                                                  fileName:
                                                                      textEditingController
                                                                          .text,
                                                                  groupId:
                                                                      groupId));
                                                        } else {
                                                          context
                                                              .read<
                                                                  GroupsBloc>()
                                                              .add(UpdateFileInGroupsEvent(
                                                                  webFile:
                                                                      webFile!,
                                                                 fileId: fileId,
                                                                  groupId:
                                                                      groupId));
                                                        }
                                                      }
                                                    }),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: getWidth (context) * 0.038,
                                ),
                                Expanded(
                                  child: ElevatedButtonWidget(
                                    title: noTitle,
                                    color: Colors.grey,
                                    isSelected: false,
                                    border: false,
                                    fontFamily: kNormalFont,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          print(getWidth(context) );
          return alertDialog;
        });
  }

  static void showSuccessStateDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext dialogcontext) {
          return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Wrap(children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: getHeight(context) * 0.01,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white),
                    padding: EdgeInsets.fromLTRB(
                        getWidth(context) * 0.038,
                        getWidth(context) * 0.1,
                        getWidth(context) * 0.038,
                        getWidth(context) * 0.038),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox(
                        //     height: getHeight(context) * .1,
                        //     child: Lottie.asset(
                        //         'assets/icons/Done Animation.json')),
                        SizedBox(
                          height: getHeight(context) * .04,
                        ),
                        const Text("Your message has been sent. ",
                            style: TextStyle(
                                fontFamily: kNormalFont,
                                fontSize: 20,
                                color: Colors.black,
                                height: 1.2),
                            textAlign: TextAlign.center),
                        SizedBox(height: getWidth(context) * 0.05),
                      ],
                    ),
                  ),
                ),
              ]));
        });
  }

  static void showYesNoDialog({
    required String title,
    required String noTitle,
    required String yesTitle,
    String svg = "assets/icons/deleteDialog.svg",
    Widget? textWidget,
    required Function()? onYesTap,
    required Function() onNoTap,
    required BuildContext context,
    Color color = kRedColor,
  }) {
    double getWidth = MediaQuery.of(context).size.width;
    double getHeight = MediaQuery.of(context).size.height;
    var alertDialog = Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
            horizontal: kIsWeb ? getWidth * .3 : 20,
            vertical: kIsWeb ? getHeight * .2 : 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: getHeight * 0.02,
          ),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.white),
            padding:
                // kIsWeb && mobileMaxWidth < getWidth?
                //     EdgeInsets.symmetric(vertical: getHeight*.003,horizontal: getWidth*.3)
                //   :
                EdgeInsets.fromLTRB(getWidth * 0.038, getWidth * 0.04,
                    getWidth * 0.038, getWidth * 0.04),
            child: Wrap(
              children: [
                Center(
                  child: Builder(builder: (context) {
                    if (textWidget != null) {
                      return textWidget;
                    }
                    return Column(
                      children: [
                        SvgPicture.asset(
                          svg,
                        ),
                        SizedBox(
                          height: getHeight * .03,
                        ),
                        Text(title,
                            style: const TextStyle(
                                fontFamily: kNormalFont,
                                fontSize: 15,
                                color: Colors.black,
                                height: 1.2),
                            textAlign: TextAlign.center),
                      ],
                    );
                  }),
                ),
                SizedBox(height: getHeight * .01),
                // Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                      top: kIsWeb && mobileMaxWidth < getWidth ? 20 : 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButtonWidget(
                            color: color,
                            title: yesTitle,
                            fontFamily: kNormalFont,
                            onPressed: onYesTap),
                      ),
                      SizedBox(
                        width: getWidth * 0.038,
                      ),
                      Expanded(
                        child: ElevatedButtonWidget(
                          title: noTitle,
                          color: Colors.grey,
                          isSelected: false,
                          border: false,
                          // fontFamily: kNormalFont,
                          onPressed: onNoTap,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
