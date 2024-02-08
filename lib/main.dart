import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:get/get.dart';
import 'package:messaging_core/app/theme/theme_service.dart';
import 'package:messaging_core/app/widgets/scroll_behavior.dart';
import 'package:messaging_core/core/env/environment.dart';
import 'package:messaging_core/features/chat/presentation/pages/chat_list_page.dart';
import 'package:messaging_core/l10n/l10n.dart';
import 'package:messaging_core/locator.dart';
import 'package:responsive_framework/responsive_framework.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  await Environment.initEnvironment();
  injectDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final botToastBuilder = BotToastInit();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(360, 640),
      builder: (context, child) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          theme: Themes.light,
          darkTheme: Themes.dark,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          scrollBehavior: CustomScrollBehavior(),
          supportedLocales: L10n.all,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: ResponsiveBreakpoints.builder(
              child: Builder(builder: (context) {
                return ResponsiveScaledBox(
                  width: ResponsiveValue<double>(
                    context,
                    conditionalValues: [
                      Condition.equals(name: MOBILE, value: 360)
                    ],
                  ).value,
                  child: botToastBuilder(context, child),
                );
              }),
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
            ),
          ),
          home: const ChatListPage(),
        );
      },
    );
  }
}
