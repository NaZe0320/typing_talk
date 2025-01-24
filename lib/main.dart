import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:typing_talk/core/routes/app_router.dart';
import 'package:typing_talk/core/utils/storage_manager.dart';
import 'package:typing_talk/data/models/text_collection_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // StorageManager 초기화
  await StorageManager.init();

  Hive.registerAdapter(TextCollectionModelAdapter());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      return () {
        StorageManager.dispose();
      };
    }, const []); // 빈 배열은 한 번만 실행됨을 의미

    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Typing Talk',
      theme: ThemeData(
        canvasColor: Colors.white,
        useMaterial3: true,
      ),
      routerConfig: router,
      themeMode: ThemeMode.light,
    );
  }
}
