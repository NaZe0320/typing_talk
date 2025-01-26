import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:typing_talk/core/lifecycle/lifecycle_provider.dart';

void useAppLifecycle(WidgetRef ref, void Function(AppLifecycleState) onStateChanged) {
  final previousState = useRef<AppLifecycleState?>(null);
  final lifecycleState = ref.watch(appLifecycleProvider);

  useEffect(() {
    if (previousState.value != lifecycleState) {
      onStateChanged(lifecycleState);
      previousState.value = lifecycleState;
    }
    return null;
  }, [lifecycleState]);
}
