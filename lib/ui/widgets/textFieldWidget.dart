
import 'package:chat/core/constants/colors.dart';
import 'package:chat/core/constants/string.dart';
import 'package:chat/core/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class customeTextField extends StatelessWidget {
  customeTextField({
    super.key,
    this.hintText,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.onTap,
    this.isPassword = false,
    this.isSearch = false,
    this.isChatText = false,
  });

  final void Function(String)? onChanged;
  final String? hintText;
  final FocusNode? focusNode;
  final bool isSearch;
  final bool isChatText;
  final TextEditingController? controller;
  final void Function()? onTap;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      focusNode: focusNode,
      obscureText: isPassword,
      textCapitalization: isChatText ? TextCapitalization.sentences : TextCapitalization.none,
      keyboardType: isChatText ? TextInputType.multiline : TextInputType.text,
      textInputAction: isChatText ? TextInputAction.newline : TextInputAction.done,
      maxLines: isChatText ? 3 : 1, // Allow multiple lines for chat
      minLines: 1,
      decoration: InputDecoration(
        contentPadding: 
            isChatText ? EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h) : null,
        hintText: hintText,
        hintStyle: body.copyWith(color: grey),
        suffixIcon: isSearch
            ? Container(
                height: 20,
                width: 10,
                child: Image.asset(searchIcon, height: 10),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isChatText ? 20.r : 5.r),
          borderSide: BorderSide(
            color: grey.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isChatText ? 20.r : 5.r),
          borderSide: BorderSide(
            color: grey.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isChatText ? 20.r : 5.r),
          borderSide: BorderSide(
            color: primary.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        fillColor: isChatText ? whiteClr : grey.withOpacity(0.02),
        filled: true,
      ),
    );
  }
}
