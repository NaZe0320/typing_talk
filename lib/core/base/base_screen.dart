import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

/// BaseScreen은 앱의 기본 화면 구조를 정의하는 추상 클래스입니다.
///
/// 주요 기능:
/// - SafeArea 내부에 화면 구성
/// - 헤더와 콘텐츠 영역 분리
/// - 배경색 커스터마이징
///
/// 사용 예시:
/// ```dart
/// class HomeScreen extends BaseScreen {
///   @override
///   Widget buildContent(BuildContext context, WidgetRef ref) {
///     return Container();
///   }
/// }
/// ```
abstract class BaseScreen extends HookConsumerWidget {
  const BaseScreen({super.key});

  /// 화면의 주요 콘텐츠를 구현합니다.
  /// [context]와 [ref]를 통해 필요한 데이터에 접근할 수 있습니다.
  /// 스크롤이 필요한 경우 SingleChildScrollView 등을 사용하세요.
  Widget buildContent(BuildContext context, WidgetRef ref);

  /// 화면 상단의 헤더를 구현합니다.
  /// null을 반환하면 빈 공간으로 처리됩니다.
  /// 앱바나 상단 메뉴가 필요한 경우 오버라이드하세요.
  Widget? buildHeader(BuildContext context, WidgetRef ref) => null;

  /// 화면의 배경색을 지정합니다.
  /// 기본값은 흰색입니다.
  Color backgroundColor() => Colors.white;

  /// 뒤로가기 버튼 동작을 허용할지 결정합니다.
  /// 기본값은 true입니다.
  bool get enableWillPop => true;

  /// 뒤로가기 동작을 정의합니다.
  /// (bool, dynamic) 튜플을 반환합니다:
  /// - bool: true면 화면이 종료되고, false면 화면이 유지됩니다.
  /// - dynamic: 화면 종료 시 전달할 결과값 (선택사항)
  ///
  /// 기본 구현은 (true, null)을 반환하여 결과값 없이 즉시 화면을 종료합니다.

  Future<(bool, dynamic)> onWillPop(BuildContext context, WidgetRef ref) async => (true, null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: backgroundColor(),
        body: SafeArea(
          child: Column(
            children: [
              buildHeader(context, ref) ?? const SizedBox.shrink(),
              Expanded(child: buildContent(context, ref)),
            ],
          ),
        ),
      ),
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          final (shouldPop, popResult) = await onWillPop(context, ref);
          if (shouldPop && context.mounted) {
            context.pop(popResult);
          }
        }
      },
    );
  }
}
