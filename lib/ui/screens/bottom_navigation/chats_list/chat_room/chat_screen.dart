import 'package:chat/core/constants/style.dart';
import 'package:chat/core/extension/extension_widgets.dart';
import 'package:chat/core/models/user_model.dart';
import 'package:chat/core/services/chat_services.dart';
import 'package:chat/ui/screens/bottom_navigation/chats_list/chat_room/chat_viewModel.dart';
import 'package:chat/ui/screens/bottom_navigation/chats_list/chat_room/chat_widgets.dart';
import 'package:chat/ui/screens/other/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.receiver});
  final UserModel receiver;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    return ChangeNotifierProvider(
      create:
          (context) => ChatViewmodel(ChatServices(), currentUser!, receiver),
      child: Consumer<ChatViewmodel>(
        builder: (context, model, _) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 1.sw * 0.05,
                      vertical: 10.h,
                    ),
                    child: Column(
                      children: [
                        17.verticalSpace,
                        _buildHeader(context, name: receiver.name!),
                        15.verticalSpace,
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(0),
                            itemBuilder: (context, index) {
                              final message = model.messages[index];
                              return ChatBubble(
                                isCurrentUser:
                                    message.senderId == currentUser!.uid,
                                message: message,
                              );
                            },
                            separatorBuilder:
                                (context, index) => 10.verticalSpace,
                            itemCount: model.messages.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 105,
                  child: BottomField(
                    controller: model.controller,
                    onTap: () async{
                      try {
                         await model.saveMessage();
                      } catch (e) {
                        context.showSnackbar(e.toString());
                        
                      }
                    
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

  Row _buildHeader(BuildContext context, {String name = ""}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 0, bottom: 6),
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
          ),
        ),
        15.horizontalSpace,
        Text(name, style: h.copyWith(fontSize: 23.sp)),
        Spacer(),

        Icon(Icons.more_vert),
      ],
    );
  }
}

