import 'package:flutter/material.dart';
import 'package:typing_talk/core/constants/app_constant.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/presentation/common/widgets/icon_widget.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstant.appBarHeight,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(AppConstant.appName, style: AppTypography.appTitle),
        IconWidget(assetName: 'setting', size: 24, onTap: () => print("아이콘 입력"))
      ]),
    );
  }
}
