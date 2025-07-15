import 'package:chat/core/constants/colors.dart';
import 'package:chat/core/constants/string.dart';
import 'package:chat/core/constants/style.dart';
import 'package:chat/core/enums/enums.dart';
import 'package:chat/core/extension/extension_widgets.dart';
import 'package:chat/core/services/auth_services.dart';
import 'package:chat/core/services/database_services.dart';
import 'package:chat/core/services/storage_service.dart';
import 'package:chat/ui/screens/auth/signup/signup_viewModel.dart';
import 'package:chat/ui/widgets/button_widgets.dart';
import 'package:chat/ui/widgets/textFieldWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignupViewmodel>(
      create: (context) => SignupViewmodel(AuthServices(), DatabaseServices(),StorageService()),
      child: Consumer<SignupViewmodel>(
        builder: (context, model, _) {
          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 1.sw * 0.05,
                vertical: 10.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  50.verticalSpace,
                  Text("Create Your Account", style: h),
                  Text(
                    "Please Provide the details",
                    style: body.copyWith(color: grey),
                  ),
                  30.verticalSpace,
                    InkWell(onTap: () {
                       model.pickimage();
                    },
                      child:model.image==null? CircleAvatar(
                        child: Icon(Icons.camera_alt),radius: 50.r,
                      ) : CircleAvatar(
                        backgroundImage: FileImage(model.image!),
                      ),
                    ),
                    20.verticalSpace,
                  customeTextField(
                    onChanged: model.setName,
                    hintText: "Username",
                  ),
                  20.verticalSpace,

                  customeTextField(
                    onChanged: model.setEmail,
                    hintText: "Email",
                  ),
                  20.verticalSpace,

                  customeTextField(
                    onChanged: model.setPassword,
                    hintText: "Password",
                    isPassword: true,
                  ),
                  20.verticalSpace,
                  customeTextField(
                    onChanged: model.setConfirmPassword,
                    hintText: "Confirm Password",
                    isPassword: true,
                  ),
                  30.verticalSpace,

                  customButton(
                    loading: model.state == ViewState.loading,
                    onPressed:
                        model.state == ViewState.loading
                            ? null
                            : () async {
                              try {
                                await model.signup();
                                context.showSnackbar(
                                  "User signed up successfully!",
                                );
                                Navigator.pop(context);
                              } on FirebaseAuthException catch (e) {
                                context.showSnackbar(e.toString());
                              } catch (e) {
                                context.showSnackbar(e.toString());
                              }
                            },
                    text: "SignUp",
                  ),
                  20.verticalSpace,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: body.copyWith(color: grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, login);
                        },

                        child: Text(
                          "Login",
                          style: body.copyWith(fontWeight: FontWeight.w700),
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
    );
  }
}
