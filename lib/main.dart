import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:messaging_core/app/component/base_appBar.dart';
import 'package:messaging_core/app/theme/theme_service.dart';
import 'package:messaging_core/app/widgets/scroll_behavior.dart';
import 'package:messaging_core/core/app_states/app_global_data.dart';
import 'package:messaging_core/core/env/environment.dart';
import 'package:messaging_core/core/services/navigation/navigation_controller.dart';
import 'package:messaging_core/features/chat/presentation/pages/chat_call_page.dart';
import 'package:messaging_core/features/chat/presentation/pages/chat_list_page.dart';
import 'package:messaging_core/l10n/app_localizations.dart';
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
          home: ApplicationHomePage(),
        );
      },
    );
  }
}

class ApplicationHomePage extends StatefulWidget {
  const ApplicationHomePage(
      {super.key,
      this.categoryId,
      this.userName,
      this.token,
      this.userId,
      this.onCloseChat});

  final int? categoryId;
  final int? userId;
  final String? userName;
  final String? token;
  final Function(String?)? onCloseChat;

  @override
  State<ApplicationHomePage> createState() => _ApplicationHomePageState();
}

class _ApplicationHomePageState extends State<ApplicationHomePage> {
  @override
  void initState() {
    if (widget.categoryId != null) {
      final Navigation navigation = locator<Navigation>();

      navigation.closeApp.addListener(() {
        invokeCloseChat();
      });
      AppGlobalData.categoryId = widget.categoryId!;
      AppGlobalData.userId = widget.userId!;
      AppGlobalData.userName = widget.userName!;

      navigation.setToken(widget.token!);

      navigation.pages = [const ChatCallPage()];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getx.GetBuilder<Navigation>(builder: (navigation) {
      return WillPopScope(
        onWillPop: navigation.pop,
        child: Scaffold(
          body: navigation.pages.last,
        ),
      );
    });
  }

  invokeCloseChat() {
    widget.onCloseChat!.call(null);
  }
}

class ChooseUserPage extends StatefulWidget {
  const ChooseUserPage({super.key});

  @override
  State<ChooseUserPage> createState() => _ChooseUserPageState();
}

class _ChooseUserPageState extends State<ChooseUserPage> {
  final List<ChooseUserModel> users = [
    ChooseUserModel(name: "Siamak", id: 391),
    ChooseUserModel(name: "admin_sir", id: 1),
    ChooseUserModel(name: "Esther", id: 177),
    ChooseUserModel(name: "Farhad", id: 194),
    ChooseUserModel(name: "shahry", id: 178),
    ChooseUserModel(name: "Amir", id: 424),
  ];

  ChooseUserModel? selectedUser;

  final Navigation navigation = locator<Navigation>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Choose User",
        haveShadow: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: selectedUser == users[index] ? 10 : 1,
                  color: selectedUser == users[index] ? Colors.red[200] : null,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(users[index].name),
                    subtitle: Text("ID: ${users[index].id}"),
                    onTap: () {
                      selectedUser = users[index];
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: selectedUser != null
                ? () {
                    AppGlobalData.userId = selectedUser!.id;
                    AppGlobalData.userName = selectedUser!.name;

                    navigation.pushReplacement(const ChatCallPage());
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedUser != null ? null : Colors.grey,
            ),
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}

class ChooseUserModel {
  String name;
  int id;

  ChooseUserModel({required this.name, required this.id});
}
