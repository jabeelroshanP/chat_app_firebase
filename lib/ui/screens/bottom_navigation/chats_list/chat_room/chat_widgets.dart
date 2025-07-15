import 'package:chat/core/constants/colors.dart';
import 'package:chat/core/constants/style.dart';
import 'package:chat/core/models/message_model.dart';
import 'package:chat/ui/widgets/textFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';



class BottomField extends StatelessWidget {
  const BottomField({
    super.key, 
    this.onTap, 
    this.onChanged, 
    this.controller
  });

  final void Function()? onTap;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: grey.withOpacity(0.2),
      padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.03, vertical: 20.h),
      child: Row(
        children: [
          InkWell(
            onTap: null, // Future functionality
            child: CircleAvatar(
              child: Icon(Icons.add, size: 35),
              backgroundColor: whiteClr,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: customeTextField(
              controller: controller,
              isChatText: true,
              hintText: "Type a message",
              onChanged: onChanged,
            ),
          ),
          5.horizontalSpace,
          InkWell(
            onTap: () {
              if (controller != null && 
                  controller!.text.trim().isNotEmpty && 
                  onTap != null) {
                onTap!();
              }
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: primary,
              child: Icon(Icons.send_rounded, color: whiteClr),
            ),
          ),
        ],
      ),
    );
  }
}




// 1. Fix for ChatBubble layout constraints issue
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    this.isCurrentUser = true,
    required this.message,
  });

  final bool isCurrentUser;
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final borderRadius = isCurrentUser
        ? BorderRadius.only(
            topLeft: Radius.circular(15.r),
            topRight: Radius.circular(15.r),
            bottomLeft: Radius.circular(15.r),
          )
        : BorderRadius.only(
            bottomRight: Radius.circular(15.r),
            topRight: Radius.circular(15.r),
            bottomLeft: Radius.circular(15.r),
          );

    final alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: alignment,
      child: Container(
        // Fixed constraints - using maxWidth correctly and removing fixed width
        constraints: BoxConstraints(maxWidth: 0.75 * MediaQuery.of(context).size.width),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentUser ? primary : grey,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content ?? "",
              style: body.copyWith(color: isCurrentUser ? whiteClr : null),
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                formatMessageTime(message.timeStamp!),
                style: small.copyWith(color: isCurrentUser ? whiteClr : null),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Improved time formatting
  String formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inDays > 0) {
      return DateFormat('MMM d, h:mm a').format(time);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
