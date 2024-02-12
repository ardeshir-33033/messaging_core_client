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

// void main() {
//   runApp(const MyApp2());
// }

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showOverlay = false;
  Offset? targetPos;
  Widget? target;

  _showOverlay(Offset position, Widget? target) {
    setState(() {
      targetPos = position;
      this.target = target;
      showOverlay = true;
    });
  }

  _hideOverlay() {
    setState(() {
      showOverlay = false;
      targetPos = null;
      target = null;
    });
  }

  final double padding = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Message(
                        onTap: _showOverlay,
                        padding: padding,
                      );
                    }),
              ),


            ],
          ),
          ///Mimics the overlay
          if (showOverlay)
            GestureDetector(
              onTap: _hideOverlay,
              child: Container(
                color: Colors.black54,
              ),
            ),
          if (showOverlay)
            Positioned(
                top: (targetPos?.dy)! - 70,
                left: targetPos?.dx,
                child: Container(
                  //Your Reaction widget
                  height: 60,
                  width: 120,
                  color: Colors.blue,
                )),
          if (showOverlay)
            Positioned(
                top: (targetPos?.dy)! - padding,
                left: (targetPos?.dx)! - padding,
                child: target ?? const SizedBox()),
          if (showOverlay)
            Positioned(
                top: (targetPos?.dy)! + 50,
                left: targetPos?.dx,
                child: Container(
                  //Your action widget
                  height: 60,
                  width: 120,
                  color: Colors.red,
                ))
        ],
      ),
    );
  }
}

class Message extends StatefulWidget {
  final double padding;
  final Function(Offset globalPosition, Widget? target) onTap;

  const Message({super.key, required this.onTap, required this.padding});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  Offset? position;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
      position = box.localToGlobal(Offset.zero);
      setState(() {});
    });
    super.initState();
  }

  final GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        key: key,
        onTap: position != null
            ? () {
                widget.onTap(position!, widget);
              }
            : null,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: const Text("Hello"),
        ),
      ),
    );
  }
}

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
