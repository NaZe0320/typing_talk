import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:typing_talk/core/constants/app_constant.dart';
import 'package:typing_talk/core/theme/app_fonts.dart';
import 'package:typing_talk/presentation/common/widgets/icon_widget.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar(this.title, {super.key, this.onTap});

  final String title;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstant.appBarHeight,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          spacing: 8,
          children: [
            IconWidget(assetName: 'arrow_left', size: 24, onTap: () => onTap ?? context.go('/')),
            Text(title, style: AppTypography.h3_6),
          ],
        ),
        //IconWidget(assetName: 'setting', size: 24, onTap: () => print("아이콘 입력"))
      ]),
    );
  }
}
