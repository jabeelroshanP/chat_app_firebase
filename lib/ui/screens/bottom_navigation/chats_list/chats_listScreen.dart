import 'package:chat/core/constants/colors.dart';
import 'package:chat/core/constants/string.dart';
import 'package:chat/core/constants/style.dart';
import 'package:chat/core/enums/enums.dart';
import 'package:chat/core/models/user_model.dart';
import 'package:chat/core/services/database_services.dart';
import 'package:chat/ui/screens/bottom_navigation/chats_list/chat_list_viewmodel.dart';
import 'package:chat/ui/screens/other/user_provider.dart';
import 'package:chat/ui/widgets/textFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatsListscreen extends StatelessWidget {
  const ChatsListscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    return ChangeNotifierProvider(
      create: (context) => ChatListViewmodel(DatabaseServices(), currentUser!),
      child: Consumer<ChatListViewmodel>(
        builder: (context, model, _) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 1.sw * 0.05,
              vertical: 10.h,
            ),
            child: Column(
              children: [
                20.verticalSpace,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Chats", style: h),
                ),
                20.verticalSpace,
                customeTextField(
                  isSearch: true,
                  hintText: "Search",
                  onChanged: model.search,
                ),
                10.verticalSpace,
                model.state == ViewState.loading
                    ? Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                    : model.users.isEmpty
                    ? Expanded(child: Center(child: Text("No Users found")))
                    : model.filteredUsers.isEmpty
                    ? Expanded(child: Center(child: Text("No results found")))
                    : Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 0,
                        ),
                        itemCount: model.filteredUsers.length,
                        separatorBuilder: (context, index) => 5.verticalSpace,
                        itemBuilder: (context, index) {
                          final user = model.filteredUsers[index];
                          return ChatTile(
                            user: user,
                            onTap:
                                () => Navigator.pushNamed(
                                  context,
                                  chatRoom,
                                  arguments: user,
                                ),
                          );
                        },
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}




class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key, 
    this.onTap, 
    required this.user
  });

  final UserModel user;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final hasUnread = user.unreadCounter != null && user.unreadCounter! > 0;
    
    return ListTile(
      onTap: onTap,
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            user.lastMessage == null ? "" : getTimeString(),
            style: TextStyle(color: const Color.fromARGB(255, 96, 97, 103)),
          ),
          10.verticalSpace,
          if (hasUnread)
            CircleAvatar(
              radius: 10.r,
              child: Text(
                "${user.unreadCounter}", 
                style: small.copyWith(color: whiteClr),
              ),
              backgroundColor: primary,
            ),
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      tileColor: grey.withOpacity(0.12),
      title: Text(user.name ?? ""),
      subtitle: Text(
        user.lastMessage != null ? user.lastMessage!['content'] ?? "" : "",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        backgroundColor: grey.withOpacity(0.5),
        radius: 30,
        child: Text(user.name != null && user.name!.isNotEmpty ? user.name![0] : "", style: h),
      ),
    );
  }

  String getTimeString() {
    if (user.lastMessage == null) return "";
    
    final timestamp = user.lastMessage!["timeStamp"] as int;
    final messageTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(messageTime);
    
    if (difference.inDays > 6) {
      return DateFormat('MMM d').format(messageTime);
    } else if (difference.inDays > 0) {
      return DateFormat('E').format(messageTime); // Day name
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
