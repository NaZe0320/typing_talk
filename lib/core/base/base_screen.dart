import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱의 기본 화면 구조를 정의하는 추상 클래스입니다.
/// 모든 화면은 이 클래스를 상속받아 구현합니다.
abstract class BaseScreen extends ConsumerWidget {
  const BaseScreen({super.key});

  /// 화면의 주요 콘텐츠를 구현합니다.
  /// 스크롤이 필요한 경우 SingleChildScrollView 등을 사용하세요.
  Widget buildContent(BuildContext context, WidgetRef ref);

  /// 화면 상단의 헤더를 구현합니다.
  /// 앱바나 상단 메뉴가 필요한 경우 오버라이드하세요.
  /// 기본값은 null이며, 이 경우 빈 공간으로 처리됩니다.
  Widget? buildHeader(BuildContext context, WidgetRef ref) => null;

  /// 화면의 배경색을 지정합니다.
  /// 기본값은 흰색입니다.
  Color backgroundColor() => Colors.white;

  /// BaseScreen의 기본 레이아웃을 구성합니다.
  /// SafeArea 내부에 헤더와 콘텐츠를 배치합니다.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(context, ref) ?? const SizedBox.shrink(),
            Expanded(child: buildContent(context, ref)),
          ],
        ),
      ),
    );
  }
}
