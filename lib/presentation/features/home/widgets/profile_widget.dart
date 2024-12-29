import 'package:flutter/material.dart';
import 'package:typing_talk/core/theme/app_colors.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '레벨',
                style: AppTypography.b3_4,
              ),
              Text(
                '경험치',
                style: AppTypography.b3_4,
              ),
            ],
          ),
          Container(
            height: 10,
            decoration: BoxDecoration(color: AppColors.gray600, borderRadius: BorderRadius.circular(10)),
          )
        ],
      ),
    );
  }
}
