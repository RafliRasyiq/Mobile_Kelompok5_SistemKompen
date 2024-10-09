import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;

  const CustomText({
    super.key,
    required this.text,
    required this.color,
    required this.fontSize,
    required this.fontWeight,
    this.textAlign,
    this.softWrap,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Inter",
        color: color,
        fontSize: ScreenUtil().setSp(fontSize),
        fontWeight: fontWeight,
      ),
      textAlign: textAlign ?? TextAlign.left,
      softWrap: softWrap ?? false,
      maxLines: maxLines,
    );
  }
}
