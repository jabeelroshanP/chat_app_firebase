import 'dart:developer';

import 'package:chat/core/constants/colors.dart';
import 'package:chat/core/constants/string.dart';
import 'package:chat/core/constants/style.dart';
import 'package:chat/core/enums/enums.dart';
import 'package:chat/core/extension/extension_widgets.dart';
import 'package:chat/core/services/auth_services.dart';
import 'package:chat/ui/screens/auth/login/loginScreen_viewModel.dart';
import 'package:chat/ui/widgets/button_widgets.dart';
import 'package:chat/ui/widgets/textFieldWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginscreenViewmodel(AuthServices()),
      child: Consumer<LoginscreenViewmodel>(
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
                  Text("Login", style: h),
                  Text(
                    "Please Login to Your Account",
                    style: body.copyWith(color: grey),
                  ),
                  30.verticalSpace,

                  customeTextField(
                    onChanged: model.setEmail,
                    hintText: "Email",
                  ),
                  20.verticalSpace,

                  customeTextField(onChanged: model.setPassword, hintText: "Password"),
                  20.verticalSpace,

                  customButton( 
                    loading: model.state == ViewState.loading,
                    onPressed:model.state == ViewState.loading ? null:  ()async {
                  try {
                     await model.login();
                     context.showSnackbar("User logged in successfully!");
                     
                  }on FirebaseAuthException catch(e){
                     context.showSnackbar(e.toString());
                  } 
                  
                  catch (e) {
                    context.showSnackbar(e.toString());
                  }
                    log("Pressed");
                  },text: "Login",),
                  20.verticalSpace,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: body.copyWith(color: grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, signup);
                        },

                        child: Text(
                          "SignUp",
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
