import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sistem_kompen/utils/colors_helper.dart';
import 'package:sistem_kompen/widgets/custom_text.dart';

Widget profileContainer({
  required String title,
  required String value,
  required double paddingBottom,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: paddingBottom),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          color: ColorsHelper.darkGrey(),
          fontSize: 16.0,
          fontWeight: FontWeight.w300,
        ),
        SizedBox(height: ScreenUtil().setHeight(4)),
        CustomText(
          text: value,
          color: ColorsHelper.black(),
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        Divider(
          color: ColorsHelper.darkGrey(),
          thickness: 1,
        ),
      ],
    ),
  );
}
