
import 'package:chat/core/constants/colors.dart';
import 'package:chat/core/constants/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class customButton extends StatelessWidget {
  const customButton({
    super.key,this.onPressed,required this.text,this.loading=false
  });

  final void Function()? onPressed;
  final String text;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: primary),
        onPressed: onPressed,
        child:loading?Center(child: CircularProgressIndicator()): Text(text, style: body.copyWith(color: whiteClr)),
      ),
    );
  }
}
