import 'package:chatp/view/book_list.dart';
import 'package:chatp/view/book_search.dart';
import 'package:chatp/view/note.dart';
import 'package:chatp/view/reg.dart';
import 'package:chatp/view/test_tab.dart';
import 'package:chatp/widget/auth_state.dart';
import 'package:chatp/view/setting.dart';
import 'package:chatp/widget/tab.dart';
import 'package:chatp/widget/tab_bottom.dart';
import 'package:chatp/widget/login_info.dart';
import 'package:chatp/widget/three_column.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chatp/plink/client.dart';
import 'package:chatp/view/chat2.dart';
import 'package:chatp/view/login.dart';
import 'package:chatp/view/home.dart';
import 'package:provider/provider.dart';

import 'view/test.dart';

GoRouter addAll(TcpClient client, LoginInfo loginInfo2) {
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return TabBarExample(
            tcpClient: client,
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'login',
            builder: (BuildContext context, GoRouterState state) {
              return LoginScreen(client);
            },
            routes: [
              //RegScreen
              GoRoute(
                path: 'setting',
                builder: (BuildContext context, GoRouterState state) {
                  return SettingScreen(client);
                },
              ),
              GoRoute(
                path: 'reg',
                builder: (BuildContext context, GoRouterState state) {
                  return RegScreen(client);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'chat',
            builder: (BuildContext context, GoRouterState state) {
              return ChatScreen(client);
            },
          ), //
          GoRoute(
            path: 'book',
            builder: (BuildContext context, GoRouterState state) {
              return BookListScreen();
            },
            routes: [
              GoRoute(
                path: 'search',
                builder: (BuildContext context, GoRouterState state) {
                  return BookSearchScreen();
                },
              ),
            ],
          ),
          GoRoute(
            path: 'note',
            builder: (BuildContext context, GoRouterState state) {
              return NotebookScreen();
            },
          ),
          GoRoute(
            path: 'test',
            builder: (BuildContext context, GoRouterState state) {
              return TwoColumnLayout();
            },
          ),
        ],
      ),
    ],
    // redirect: (BuildContext context, GoRouterState state) {
    //   // if the user is not logged in, they need to login
    //   LoginInfo loginInfo = context.read<LoginInfo>();
    //   final bool loggedIn = loginInfo.loggedIn;
    //   final bool loggingIn = state.matchedLocation == '/login';

    //   if (loginInfo.toSetting) {
    //     return '/login/setting';
    //   } else if (loginInfo.toReg) {
    //     return '/login/reg';
    //   }

    //   if (!loggedIn) {
    //     return '/login';
    //   }

    //   // if the user is logged in but still on the login page, send them to
    //   // the home page
    //   if (loggedIn) {
    //     return '/';
    //   }

    //   // no need to redirect at all
    //   return null;
    // },
    // changes on the listenable will cause the router to refresh it's route
    refreshListenable: loginInfo2,
  );
}
