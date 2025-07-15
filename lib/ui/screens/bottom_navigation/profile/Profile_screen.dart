
import 'package:chat/core/constants/colors.dart';
import 'package:chat/core/constants/style.dart';
import 'package:chat/core/services/auth_services.dart';
import 'package:chat/ui/screens/other/user_provider.dart';
import 'package:chat/ui/widgets/button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.05),
        child: user == null 
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  50.verticalSpace,
                  Text("Profile", style: h),
                  30.verticalSpace,
                  CircleAvatar(
                    radius: 50.r,
                    backgroundColor: grey.withOpacity(0.5),
                    child: user.imageUrl != null 
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50.r),
                            child: Image.network(
                              user.imageUrl!,
                              width: 100.r,
                              height: 100.r,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => 
                                  Text(user.name?[0] ?? "", style: h),
                            ),
                          )
                        : Text(user.name?[0] ?? "", style: h),
                  ),
                  20.verticalSpace,
                  ListTile(
                    title: Text("Name"),
                    subtitle: Text(user.name ?? ""),
                    leading: Icon(Icons.person),
                  ),
                  ListTile(
                    title: Text("Email"),
                    subtitle: Text(user.email ?? ""),
                    leading: Icon(Icons.email),
                  ),
                  30.verticalSpace,
                  customButton(
                    text: "LogOut",
                    onPressed: () {
                      AuthServices().logout();
                      Provider.of<UserProvider>(context, listen: false).clearUser();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}