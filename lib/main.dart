import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'models/jewellery_item.dart';
import 'models/zakat_run.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Hive
  await Hive.initFlutter();
  Hive.registerAdapter(JewelleryItemAdapter());
  Hive.registerAdapter(ZakatRunAdapter());
  await Hive.openBox<ZakatRun>('zakat_runs');

  runApp(
    const ProviderScope(
      child: ZakatiApp(),
    ),
  );
}

class ZakatiApp extends StatelessWidget {
  const ZakatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Zakati',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: appRouter,
    );
  }
}
