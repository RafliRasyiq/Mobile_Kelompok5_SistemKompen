import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sistem_kompen/screens/profile_screen/widgets/profile_container.dart';
import 'package:sistem_kompen/screens/profile_screen/widgets/profile_container_with_icon.dart';
import 'package:sistem_kompen/utils/colors_helper.dart';
import 'package:sistem_kompen/utils/images.dart';
import 'package:sistem_kompen/widgets/custom_text.dart';
import 'package:sistem_kompen/screens/KelolaKompen.dart'; // Import the KelolaKompen screen


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsHelper.darkGrey(),
        title: CustomText(
          text: "Profil Mahasiswa",
          color: ColorsHelper.white(),
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: ColorsHelper.white(),
          ),
          onPressed: () {
            // Action for back button
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => KelolaKompen(),
               ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: ScreenUtil().setHeight(124),
                decoration: BoxDecoration(color: ColorsHelper.darkGrey()),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    CustomText(
                      text: "Komen Mahasiswa > Profil Mahasiswa",
                      color: ColorsHelper.white(),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(34)),
                    const Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(Images.avatar),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40)),
                    Container(
                      decoration: BoxDecoration(
                          color: ColorsHelper.lightGrey(),
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setSp(14))),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(14),
                        vertical: ScreenUtil().setHeight(16),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "Kompen Saat Ini",
                                    color: ColorsHelper.black(),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    softWrap: true,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                  CustomText(
                                    text: "10",
                                    color: ColorsHelper.black(),
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              color: ColorsHelper.black(),
                              thickness: 1,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "Kompen Selesai",
                                    color: ColorsHelper.black(),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    softWrap: true,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                  CustomText(
                                    text: "14",
                                    color: ColorsHelper.black(),
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              color: ColorsHelper.black(),
                              thickness: 1,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: "Total",
                                    color: ColorsHelper.black(),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    softWrap: true,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                  CustomText(
                                    text: "24",
                                    color: ColorsHelper.black(),
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(27)),
                    profileContainer(
                      title: "Nama Lengkap",
                      value: "Bagus Tejo Waluyo",
                      paddingBottom: 20,
                    ),
                    profileContainer(
                      title: "NIM",
                      value: "2141762076",
                      paddingBottom: 20,
                    ),
                    profileContainer(
                      title: "Jurusan",
                      value: "Teknologi Informasi",
                      paddingBottom: 20,
                    ),
                    profileContainer(
                      title: "Program Studi",
                      value: "D-IV Sistem Informasi Bisnis",
                      paddingBottom: 20,
                    ),
                    profileContainer(
                      title: "Kelas",
                      value: "3 - B",
                      paddingBottom: 20,
                    ),
                    profileContainerWithIcon(
                      title: "No. Telephone",
                      value: "089506151300",
                      paddingBottom: 20,
                      icon: Images.whatsapp,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(100)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
