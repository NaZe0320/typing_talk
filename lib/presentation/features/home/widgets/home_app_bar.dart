import 'package:flutter/material.dart';
import 'package:typing_talk/core/constants/app_constant.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: AppColors.primaryBlue,

      child:
      Row(
        children: [
          Text(AppConstant.appName, style: AppTypography.h2_7),
        ],
      ),
    );
  }
}
