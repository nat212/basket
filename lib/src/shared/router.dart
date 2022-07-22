import 'package:basket/src/features/pantry/pantry.dart';
import 'package:basket/src/features/shopping_lists/shopping_lists.dart';
import 'package:basket/src/shared/views/root_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home.dart';
import '../features/settings/settings.dart';

const _pageKey = ValueKey('_pageKey');
const _scaffoldKey = ValueKey('_scaffoldKey');

class NavigationDestination {
  const NavigationDestination({
    required this.route,
    required this.label,
    required this.icon,
    this.child,
  });

  final String route;
  final String label;
  final Icon icon;
  final Widget? child;
}

const List<NavigationDestination> destinations = [
  NavigationDestination(
    label: 'My List',
    icon: Icon(Icons.shopping_basket),
    route: '/',
  ),
  NavigationDestination(
    label: 'My Pantry',
    icon: Icon(Icons.fastfood),
    route: '/pantry',
  ),
  NavigationDestination(
    label: 'Settings',
    icon: Icon(Icons.settings),
    route: '/settings',
  ),
];

final appRouter = GoRouter(
  restorationScopeId: 'app',
  urlPathStrategy: UrlPathStrategy.path,
  navigatorBuilder: (context, state, child) => child,
  routes: [
    GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage<void>(
              key: _pageKey,
              child: RootLayout(
                key: _scaffoldKey,
                currentIndex: 0,
                child: HomeScreen(),
              ),
            ),
        routes: [
          GoRoute(
            path: 'lists/add',
            pageBuilder: (context, state) => MaterialPage<void>(
              key: state.pageKey,
              child: const RootLayout(
                key: _scaffoldKey,
                currentIndex: 0,
                child: AddListScreen(),
              ),
            ),
          ),
          GoRoute(
            path: 'lists/:listId',
            pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: RootLayout(
                    key: _scaffoldKey,
                    currentIndex: 0,
                    child: ShoppingListDetailScreen(
                      shoppingList: ShoppingListProvider.instance
                          .get(int.parse(state.params['listId']!))!,
                    ))),
            routes: [
              GoRoute(
                path: 'items/add',
                pageBuilder: (context, state) => MaterialPage<void>(
                  key: state.pageKey,
                  child: RootLayout(
                    key: _scaffoldKey,
                    currentIndex: 0,
                    child: AddItemScreen(
                      list: ShoppingListProvider.instance
                          .get(int.parse(state.params['listId']!))!,
                    ),
                  ),
                ),
              ),
              GoRoute(
                path: 'items/:itemId',
                pageBuilder: (context, state) => MaterialPage<void>(
                  key: state.pageKey,
                  child: RootLayout(
                    key: _scaffoldKey,
                    currentIndex: 0,
                    child: AddItemScreen(
                      list: ShoppingListProvider.instance
                          .get(int.parse(state.params['listId']!))!,
                      initialItem: ShoppingListProvider.instance
                          .getItem(int.parse(state.params['itemId']!))!,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
    GoRoute(
      path: '/pantry',
      pageBuilder: (context, state) => const MaterialPage(
        key: _pageKey,
        child: RootLayout(
          key: _scaffoldKey,
          currentIndex: 1,
          child: PantryScreen(),
        ),
      ),
    ),
    GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => const MaterialPage<void>(
              key: _pageKey,
              child: RootLayout(
                key: _scaffoldKey,
                currentIndex: 2,
                child: SettingsScreen(),
              ),
            )),
  ],
);
