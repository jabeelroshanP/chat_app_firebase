
import 'package:chat/core/constants/string.dart';
import 'package:chat/ui/screens/bottom_navigation/bottom_nav_viewmodel.dart';
import 'package:chat/ui/screens/bottom_navigation/chats_list/chats_listScreen.dart';
import 'package:chat/ui/screens/bottom_navigation/profile/Profile_screen.dart';
import 'package:chat/ui/screens/other/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  static final List<Widget> _screens = [
    const Center(child: Text("Home")),
    const ChatsListscreen(), // 
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser=Provider.of<UserProvider>(context).user;
    return ChangeNotifierProvider(
      create: (context) => BottomNavigationViewmodel(),
      child: Consumer<BottomNavigationViewmodel>(
        builder: (context, model, _) {
          return currentUser == null
        ? Center(child: CircularProgressIndicator())
        :  Scaffold(
            body: _screens[model.currentIndex],
            bottomNavigationBar: CustomBottomNavBar(),
          );
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BottomNavigationViewmodel>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1, 
          child: BottomNavigationBar(
            currentIndex: viewModel.currentIndex,
            onTap: (index) {
              viewModel.setIndex(index);
            },
            showSelectedLabels: false, 
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                label: "Calls", // For accessibility
                icon: Image.asset(callIcon, height: 35),
              ),
              BottomNavigationBarItem(
                label: "Chats",
                icon: Image.asset(chatsIcon, height: 35),
              ),
              BottomNavigationBarItem(
                label: "Profile",
                icon: Image.asset(profileIcon, height: 35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}