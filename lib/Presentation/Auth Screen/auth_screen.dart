import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../BusinessLogic/user_bloc/user_bloc.dart';
import '../../Util/constants.dart';
import '../../Util/global widgets/custom_text_field.dart';
import '../../Util/global widgets/dialogs_widgets.dart';
import '../../Util/global widgets/elevated_button_widget.dart';
import '../../Util/global widgets/select_from_row.dart';
import '../../Util/requests_params.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isArabic = false;
  bool isPasswordVisible = false;
  final PageController _loginRegisterPageController = PageController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController reTypePasswordTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  static final GlobalKey<FormState> _key = GlobalKey<FormState>();
  RequestParams requestParams = RequestParams();

  @override
  void dispose() {
    super.dispose();
    emailTextController.dispose();
    nameTextController.dispose();
    _loginRegisterPageController.dispose();
    passwordTextController.dispose();
    reTypePasswordTextController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double loginContainerOffset = getHeight(context) * .07;
    double registerContainerOffset = getHeight(context) * .23;
    scrollController =
        ScrollController(initialScrollOffset: getHeight(context) * .22);
    return kIsWeb && mobileMaxWidth < getWidth(context)
        ? Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      width: getWidth(context),
                      color: Colors.white,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('Internet Application',
                              style: TextStyle(
                                  color: kDarkBlueColor,
                                  fontSize: 10,
                                  fontFamily: kBoldFont)),
                          Image.asset(
                            "assets/images/Cloudy logo.png",
                            height: 70,
                          )
                        ],
                      )),
                  Expanded(
                    child: Container(
                      width: getWidth(context),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: Image.asset(
                                    "assets/images/web_login_background.png")
                                .image,
                            fit: BoxFit.fill),
                      ),
                      child: Center(
                        child: Container(
                            width: getWidth(context) * .4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: getWidth(context) * .04,
                              vertical: getHeight(context) * .04,
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical: getWidth(context) * .008,
                              horizontal: getWidth(context) * .06,
                            ),
                            child: BlocConsumer<UserBloc, UserState>(
                                listener: (context, state) {
                              if (state is UserSuccessState) {
                                Navigator.pushReplacementNamed(
                                    context, '/bottom_nav');
                              }
                              if (state is UserErrorState) {
                                DialogsWidgets.showScaffoldSnackBar(
                                    title: state.error, context: context);
                              }
                            }, builder: (context, state) {
                              return BlocBuilder<UserBloc, UserState>(
                                  builder: (context, state) {
                                return Form(
                                  key: _key,
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/images/web_login_svg.svg"),
                                      SizedBox(
                                        width: getWidth(context) * .4,
                                        child: SelectItemFromRowWidget(
                                          pageController:
                                              _loginRegisterPageController,
                                          valueName1: "Create Account",
                                          valueName2: "Login",
                                        ),
                                      ),
                                      SizedBox(
                                        height: getHeight(context) * .02,
                                      ),
                                      Expanded(
                                        child: PageView(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            pageSnapping: true,
                                            padEnds: false,
                                            onPageChanged: (index) {
                                              if (index == 1) {
                                                scrollController.animateTo(
                                                    loginContainerOffset,
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    curve: Curves.ease);
                                              }
                                              if (index == 0) {
                                                scrollController.animateTo(
                                                    registerContainerOffset,
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    curve: Curves.ease);
                                              }
                                            },
                                            controller:
                                                _loginRegisterPageController,
                                            children: [
                                              ///Register Web
                                              SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    CustomTextField(
                                                      fontSize: 10,
                                                      validator: (val) {
                                                        if (val == null ||
                                                            val.isEmpty) {
                                                          return 'this field is required';
                                                        }
                                                        return null;
                                                      },
                                                      controller2:
                                                          nameTextController,
                                                      maxLines: 1,
                                                      hintText: "Name",
                                                      passwordBool: false,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          getHeight(context) *
                                                              .02,
                                                    ),
                                                    CustomTextField(
                                                      fontSize: 10,
                                                      validator: (val) {
                                                        if (val == null ||
                                                            val.isEmpty) {
                                                          return 'this field is required';
                                                        }
                                                        return null;
                                                      },
                                                      controller2:
                                                          emailTextController,
                                                      maxLines: 1,
                                                      hintText:
                                                          "Enter Your Email",
                                                      passwordBool: false,
                                                      suffixIcon: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    getWidth(
                                                                            context) *
                                                                        .01),
                                                        child: const Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .email_outlined,
                                                              color: kGreyColor,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          getHeight(context) *
                                                              .02,
                                                    ),
                                                    CustomTextField(
                                                      fontSize: 10,

                                                      suffixIcon: IconButton(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    getWidth(
                                                                            context) *
                                                                        .01),
                                                        splashColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        icon: Icon(
                                                            isPasswordVisible
                                                                ? Icons
                                                                    .visibility_off_sharp
                                                                : Icons
                                                                    .visibility_outlined,
                                                            color: kGreyColor),
                                                        onPressed: () {
                                                          setState(() {
                                                            isPasswordVisible =
                                                                !isPasswordVisible;
                                                          });
                                                        },
                                                      ),
                                                      validator: (val) {
                                                        if (val == null ||
                                                            val.isEmpty) {
                                                          return 'this field is required';
                                                        }
                                                        return null;
                                                      },
                                                      controller2:
                                                          passwordTextController,
                                                      // textAlign: TextAlign.center,
                                                      maxLines: 1,
                                                      hintText:
                                                          "Enter password",
                                                      passwordBool:
                                                          isPasswordVisible,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          getHeight(context) *
                                                              .02,
                                                    ),
                                                    CustomTextField(
                                                      fontSize: 10,

                                                      suffixIcon: IconButton(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    getWidth(
                                                                            context) *
                                                                        .01),
                                                        splashColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        icon: Icon(
                                                            isPasswordVisible
                                                                ? Icons
                                                                    .visibility_off_sharp
                                                                : Icons
                                                                    .visibility_outlined,
                                                            color: kGreyColor),
                                                        onPressed: () {
                                                          setState(() {
                                                            isPasswordVisible =
                                                                !isPasswordVisible;
                                                          });
                                                        },
                                                      ),
                                                      validator: (val) {
                                                        if (val == null ||
                                                            val.isEmpty) {
                                                          return 'this field is required';
                                                        }
                                                        if (val !=
                                                            passwordTextController
                                                                .text) {
                                                          return 'There is no match in the password';
                                                        }
                                                        return null;
                                                      },
                                                      controller2:
                                                          reTypePasswordTextController,
                                                      // textAlign: TextAlign.center,
                                                      maxLines: 1,
                                                      hintText:
                                                          "Enter password again",
                                                      passwordBool:
                                                          isPasswordVisible,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          getHeight(context) *
                                                              .02,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: getWidth(
                                                                      context) *
                                                                  .1),
                                                      child: BlocBuilder<
                                                          UserBloc, UserState>(
                                                        builder:
                                                            (context, state) {
                                                          return AnimatedContainer(
                                                              width: state
                                                                      is UserLoadingState
                                                                  ? 100
                                                                  : getWidth(
                                                                          context) *
                                                                      .1,
                                                              decoration: BoxDecoration(
                                                                  shape: state
                                                                          is UserLoadingState
                                                                      ? BoxShape
                                                                          .circle
                                                                      : BoxShape
                                                                          .rectangle),
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          800),
                                                              child:
                                                                  ElevatedButtonWidget(
                                                                fontSize: state
                                                                        is UserLoadingState
                                                                    ? 6
                                                                    : 10,
                                                                title: state
                                                                        is UserLoadingState
                                                                    ? "...Loading"
                                                                    : "Login",
                                                                color: state
                                                                        is UserLoadingState
                                                                    ? kPrimaryBlueColor
                                                                        .withOpacity(
                                                                            .5)
                                                                    : kDarkBlueColor,
                                                                onPressed: state
                                                                        is UserLoadingState
                                                                    ? () {}
                                                                    : () {
                                                                        if (_key
                                                                            .currentState!
                                                                            .validate()) {
                                                                          context
                                                                              .read<UserBloc>()
                                                                              .add(RegisterEvent(
                                                                                email: emailTextController.text,
                                                                                password: passwordTextController.text,
                                                                                name: nameTextController.text,
                                                                              ));
                                                                        }
                                                                      },
                                                              ));
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              ///Login Web
                                              Column(
                                                children: [
                                                  // SizedBox(height: getHeight(context)*.05,)
                                                  CustomTextField(
                                                    fontSize: 10,
                                                    suffixIcon: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: getWidth(
                                                                      context) *
                                                                  .01),
                                                      child: const Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .email_outlined,
                                                              color: kGreyColor)
                                                        ],
                                                      ),
                                                    ),
                                                    validator: (val) {
                                                      if (val == null ||
                                                          val.isEmpty) {
                                                        return 'this field is required';
                                                      }
                                                      return null;
                                                    },
                                                    controller2:
                                                        emailTextController,
                                                    maxLines: 1,
                                                    hintText:
                                                        "Enter Your Email",
                                                    passwordBool: false,
                                                  ),
                                                  SizedBox(
                                                    height: getHeight(context) *
                                                        .02,
                                                  ),
                                                  CustomTextField(
                                                    fontSize: 10,
                                                    suffixIcon: IconButton(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: getWidth(
                                                                      context) *
                                                                  .01),
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      icon: Icon(
                                                        isPasswordVisible
                                                            ? Icons
                                                                .visibility_off_sharp
                                                            : Icons
                                                                .visibility_outlined,
                                                        color: kGreyColor,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          isPasswordVisible =
                                                              !isPasswordVisible;
                                                        });
                                                      },
                                                    ),
                                                    validator: (val) {
                                                      if (val == null ||
                                                          val.isEmpty) {
                                                        return 'this field is required';
                                                      }
                                                      return null;
                                                    },
                                                    controller2:
                                                        passwordTextController,
                                                    maxLines: 1,
                                                    minLines: 1,
                                                    hintText:
                                                        "Enter the password",
                                                    passwordBool:
                                                        isPasswordVisible,
                                                  ),
                                                  SizedBox(
                                                    height: getHeight(context) *
                                                        .03,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: getWidth(
                                                                    context) *
                                                                .1),
                                                    child: BlocBuilder<UserBloc,
                                                        UserState>(
                                                      builder:
                                                          (context, state) {
                                                        return AnimatedContainer(
                                                          width: state
                                                                  is UserLoadingState
                                                              ? 100
                                                              : getWidth(
                                                                      context) *
                                                                  .1,
                                                          decoration: BoxDecoration(
                                                              shape: state
                                                                      is UserLoadingState
                                                                  ? BoxShape
                                                                      .circle
                                                                  : BoxShape
                                                                      .rectangle),
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      800),
                                                          child:
                                                              ElevatedButtonWidget(
                                                            fontSize: state
                                                                    is UserLoadingState
                                                                ? 6
                                                                : 10,
                                                            title: state
                                                                    is UserLoadingState
                                                                ? "...Loading"
                                                                : "Login",
                                                            color: state
                                                                    is UserLoadingState
                                                                ? kPrimaryBlueColor
                                                                    .withOpacity(
                                                                        .5)
                                                                : kDarkBlueColor,
                                                            onPressed: state
                                                                    is UserLoadingState
                                                                ? () {}
                                                                : () {
                                                                    if (_key
                                                                        .currentState!
                                                                        .validate()) {
                                                                      context.read<UserBloc>().add(LoginEvent(
                                                                          email: emailTextController
                                                                              .text,
                                                                          password:
                                                                              passwordTextController.text));
                                                                    }
                                                                  },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: getHeight(context) *
                                                        .01,
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            })),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image:
                      Image.asset("assets/images/login_background.png").image,
                  fit: BoxFit.fill),
            ),
            child: Scaffold(
              // resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: SizedBox(
                  height: getHeight(context),
                  child: CustomScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: scrollController,
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        snap: false,
                        backgroundColor: Colors.transparent,
                        floating: false,
                        pinned: false,
                        expandedHeight: getHeight(context) * 0.5,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(
                            children: [
                              SizedBox(
                                height: getHeight(context) * .058,
                              ),
                              Image.asset('assets/images/Cloudy logo.png'),
                              // const Spacer(),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            BlocConsumer<UserBloc, UserState>(
                              listener: (context, state) {
                                if (state is UserSuccessState) {
                                  Navigator.pushReplacementNamed(
                                      context, '/bottom_nav');
                                }
                                if (state is UserErrorState) {
                                  DialogsWidgets.showScaffoldSnackBar(
                                      title: state.error, context: context);
                                }
                              },
                              builder: (context, state) {
                                return BlocBuilder<UserBloc, UserState>(
                                  builder: (context, state) {
                                    return Form(
                                      key: _key,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  getHeight(context) * .022,
                                              horizontal:
                                                  getWidth(context) * .1),
                                          height: getHeight(context) * .7,
                                          width: getWidth(context),
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(50),
                                                  topRight:
                                                      Radius.circular(50))),
                                          child: Column(
                                            children: [
                                              SelectItemFromRowWidget(
                                                pageController:
                                                    _loginRegisterPageController,
                                                valueName1: "Create an account",
                                                valueName2: "Login",
                                              ),
                                              SizedBox(
                                                height:
                                                    getHeight(context) * .03,
                                              ),
                                              Expanded(
                                                child: PageView(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    pageSnapping: true,
                                                    padEnds: false,
                                                    onPageChanged: (index) {
                                                      if (index == 1) {
                                                        scrollController.animateTo(
                                                            loginContainerOffset,
                                                            duration:
                                                                const Duration(
                                                                    seconds: 1),
                                                            curve: Curves.ease);
                                                      }
                                                      if (index == 0) {
                                                        scrollController.animateTo(
                                                            registerContainerOffset,
                                                            duration:
                                                                const Duration(
                                                                    seconds: 1),
                                                            curve: Curves.ease);
                                                      }
                                                    },
                                                    controller:
                                                        _loginRegisterPageController,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          CustomTextField(
                                                            validator: (val) {
                                                              if (val == null ||
                                                                  val.isEmpty) {
                                                                return 'this field is required';
                                                              }
                                                              return null;
                                                            },
                                                            controller2:
                                                                nameTextController,
                                                            maxLines: 1,
                                                            hintText: "Name",
                                                            passwordBool: false,
                                                          ),
                                                          SizedBox(
                                                            height: getHeight(
                                                                    context) *
                                                                .015,
                                                          ),
                                                          SizedBox(
                                                            height: getHeight(
                                                                    context) *
                                                                .07,
                                                            child:
                                                                CustomTextField(
                                                              validator: (val) {
                                                                if (val ==
                                                                        null ||
                                                                    val.isEmpty) {
                                                                  return 'this field is required';
                                                                }
                                                                return null;
                                                              },
                                                              controller2:
                                                                  emailTextController,
                                                              maxLines: 1,
                                                              hintText:
                                                                  "Enter Your Email",
                                                              passwordBool:
                                                                  false,
                                                              suffixIcon:
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            15.0),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal: getWidth(context) *
                                                                                .05),
                                                                        child: const Icon(
                                                                            Icons
                                                                                .email_outlined,
                                                                            color:
                                                                                kGreyColor)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: getHeight(
                                                                    context) *
                                                                .02,
                                                          ),
                                                          SizedBox(
                                                            height: getHeight(
                                                                    context) *
                                                                .07,
                                                            child:
                                                                CustomTextField(
                                                              suffixIcon:
                                                                  IconButton(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        getWidth(context) *
                                                                            .06),
                                                                splashColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                icon: Icon(
                                                                    isPasswordVisible
                                                                        ? Icons
                                                                            .visibility_off_sharp
                                                                        : Icons
                                                                            .visibility_outlined,
                                                                    color:
                                                                        kGreyColor),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    isPasswordVisible =
                                                                        !isPasswordVisible;
                                                                  });
                                                                },
                                                              ),
                                                              validator: (val) {
                                                                if (val ==
                                                                        null ||
                                                                    val.isEmpty) {
                                                                  return 'this field is required';
                                                                }
                                                                return null;
                                                              },
                                                              controller2:
                                                                  passwordTextController,
                                                              // textAlign: TextAlign.center,
                                                              maxLines: 1,
                                                              hintText:
                                                                  "Enter password",
                                                              passwordBool:
                                                                  isPasswordVisible,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: getHeight(
                                                                    context) *
                                                                .02,
                                                          ),
                                                          SizedBox(
                                                            height: getHeight(
                                                                    context) *
                                                                .07,
                                                            child:
                                                                CustomTextField(
                                                              suffixIcon:
                                                                  IconButton(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        getWidth(context) *
                                                                            .06),
                                                                splashColor: Colors
                                                                    .transparent,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                icon: Icon(
                                                                    isPasswordVisible
                                                                        ? Icons
                                                                            .visibility_off_sharp
                                                                        : Icons
                                                                            .visibility_outlined,
                                                                    color:
                                                                        kGreyColor),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    isPasswordVisible =
                                                                        !isPasswordVisible;
                                                                  });
                                                                },
                                                              ),
                                                              validator: (val) {
                                                                if (val ==
                                                                        null ||
                                                                    val.isEmpty) {
                                                                  return 'this field is required';
                                                                }
                                                                if (val !=
                                                                    passwordTextController
                                                                        .text) {
                                                                  return 'There is no match in the password';
                                                                }
                                                                return null;
                                                              },
                                                              controller2:
                                                                  reTypePasswordTextController,
                                                              // textAlign: TextAlign.center,
                                                              maxLines: 1,
                                                              hintText:
                                                                  "Enter password again",
                                                              passwordBool:
                                                                  isPasswordVisible,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: getHeight(
                                                                    context) *
                                                                .02,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        getWidth(context) *
                                                                            .1),
                                                            child: BlocBuilder<
                                                                UserBloc,
                                                                UserState>(
                                                              builder: (context,
                                                                  state) {
                                                                if (state
                                                                    is UserLoadingState) {
                                                                  return const SizedBox(
                                                                    height: 30,
                                                                    width: 30,
                                                                    child: Center(
                                                                        child: CircularProgressIndicator(
                                                                      color:
                                                                          kPrimaryBlueColor,
                                                                    )),
                                                                  );
                                                                }
                                                                return ElevatedButtonWidget(
                                                                  title:
                                                                      "create",
                                                                  color:
                                                                      kDarkBlueColor,
                                                                  onPressed:
                                                                      () {
                                                                    if (_key
                                                                        .currentState!
                                                                        .validate()) {
                                                                      if (passwordTextController
                                                                              .text !=
                                                                          reTypePasswordTextController
                                                                              .text) {
                                                                        return;
                                                                      }
                                                                      context
                                                                          .read<
                                                                              UserBloc>()
                                                                          .add(
                                                                              RegisterEvent(
                                                                            email:
                                                                                emailTextController.text,
                                                                            password:
                                                                                passwordTextController.text,
                                                                            name:
                                                                                nameTextController.text,
                                                                          ));
                                                                    }
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          CustomTextField(
                                                            suffixIcon:
                                                                const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          15.0),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              20.0),
                                                                      child: Icon(
                                                                          Icons
                                                                              .email_outlined,
                                                                          color:
                                                                              kGreyColor)),
                                                                ],
                                                              ),
                                                            ),
                                                            validator: (val) {
                                                              if (val == null ||
                                                                  val.isEmpty) {
                                                                return 'this field is required';
                                                              }
                                                              return null;
                                                            },
                                                            controller2:
                                                                emailTextController,
                                                            maxLines: 1,
                                                            hintText:
                                                                "Enter Your Email",
                                                            passwordBool: false,
                                                          ),
                                                          SizedBox(
                                                            height: getHeight(
                                                                    context) *
                                                                .015,
                                                          ),
                                                          CustomTextField(
                                                            suffixIcon:
                                                                IconButton(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          getWidth(context) *
                                                                              .06),
                                                              splashColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              icon: Icon(
                                                                isPasswordVisible
                                                                    ? Icons
                                                                        .visibility_off_sharp
                                                                    : Icons
                                                                        .visibility_outlined,
                                                                color:
                                                                    kGreyColor,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  isPasswordVisible =
                                                                      !isPasswordVisible;
                                                                });
                                                              },
                                                            ),
                                                            validator: (val) {
                                                              if (val == null ||
                                                                  val.isEmpty) {
                                                                return 'this field is required';
                                                              }
                                                              return null;
                                                            },
                                                            controller2:
                                                                passwordTextController,
                                                            maxLines: 1,
                                                            minLines: 1,
                                                            hintText:
                                                                "Enter the password",
                                                            passwordBool:
                                                                isPasswordVisible,
                                                          ),
                                                          SizedBox(
                                                            height: getHeight(
                                                                    context) *
                                                                .02,
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        getWidth(context) *
                                                                            .1),
                                                            child: BlocBuilder<
                                                                UserBloc,
                                                                UserState>(
                                                              builder: (context,
                                                                  state) {
                                                                if (state
                                                                    is UserLoadingState) {
                                                                  return const Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                    color:
                                                                        kPrimaryBlueColor,
                                                                  ));
                                                                }
                                                                return ElevatedButtonWidget(
                                                                  title:
                                                                      "Login",
                                                                  color:
                                                                      kDarkBlueColor,
                                                                  onPressed:
                                                                      () {
                                                                    if (_key
                                                                        .currentState!
                                                                        .validate()) {
                                                                      // Navigator.pushReplacementNamed(
                                                                      //     context,
                                                                      //     '/bottom_nav');
                                                                      context.read<UserBloc>().add(LoginEvent(
                                                                          email: emailTextController
                                                                              .text,
                                                                          password:
                                                                              passwordTextController.text));
                                                                    }
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          TextButton(
                                                            style: TextButton.styleFrom(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                minimumSize:
                                                                    const Size(
                                                                        30, 20),
                                                                tapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                                alignment: Alignment
                                                                    .centerLeft),
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      UserBloc>()
                                                                  .add(
                                                                      ContinueAsGuest());
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  '/bottom_nav');
                                                            },
                                                            child: Text(
                                                                "continue as guest",
                                                                style: TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                    decorationColor:
                                                                        kGreyColor.withOpacity(
                                                                            .8),
                                                                    fontFamily:
                                                                        kMediumFont,
                                                                    color:
                                                                        kGreyColor)),
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                              ),
                                            ],
                                          )),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
