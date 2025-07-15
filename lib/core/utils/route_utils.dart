import 'package:chat/core/constants/string.dart';
import 'package:chat/core/models/user_model.dart';
import 'package:chat/ui/screens/auth/login/login_screen.dart';
import 'package:chat/ui/screens/auth/signup/signup_screen.dart';
import 'package:chat/ui/screens/bottom_navigation/chats_list/chat_room/chat_screen.dart';
import 'package:chat/ui/screens/splashScreen/splash_screen.dart';
import 'package:chat/ui/screens/wrapper/wrapper.dart';
import 'package:flutter/material.dart';

class RouteUtils {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());

      //auth

      case signup:
        return MaterialPageRoute(builder: (context) => SignupScreen());
      case login:
        return MaterialPageRoute(builder: (context) => LoginScreen());

      //home

     

      case wrapper:
        return MaterialPageRoute(builder: (context) => Wrapper());

        
      case chatRoom:
        return MaterialPageRoute(builder: (context) => ChatScreen(receiver: args as UserModel,));

      default:
        return MaterialPageRoute(
          builder:
              (context) =>
                  Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }
}
