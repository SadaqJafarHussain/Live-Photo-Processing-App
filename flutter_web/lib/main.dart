import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:nust_students/views/capture_page.dart';
import 'package:nust_students/views/login.dart';
import 'package:nust_students/views/sccess_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'controller/my_provider.dart';
import 'controller/referesh_notifier.dart';

void main() {
  WebViewPlatform.instance = WebWebViewPlatform();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyProvider()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MyApp();
        },
      ),
    ),
  );
}
// Define the GoRouter
final GoRouter _router = GoRouter(
  refreshListenable: refreshNotifier,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginView(),
    ),
    GoRoute(
      path: '/capture',
      builder: (context, state) => ImageScreen(),
    ),
    GoRoute(
      path: '/success',
      builder: (context, state) => SuccessPage(),
    ),
  ],
);
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}