import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/cart/cart_screen.dart';
import '../features/catalog/categories_screen.dart';
import '../features/catalog/category_products_screen.dart';
import '../features/catalog/collection_screen.dart';
import '../features/checkout/checkout_screen.dart';
import '../features/checkout/order_success_screen.dart';
import '../features/home/home_screen.dart';
import '../features/orders/order_detail_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/product/product_detail_screen.dart';
import '../features/profile/about_screen.dart';
import '../features/profile/addresses_screen.dart';
import '../features/profile/edit_profile_screen.dart';
import '../features/profile/help_screen.dart';
import '../features/profile/notifications_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/settings_screen.dart';
import '../features/search/search_screen.dart';
import '../features/wishlist/wishlist_screen.dart';
import 'app_routes.dart';
import 'main_shell.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (c, s) => const NoTransitionPage(child: HomeScreen()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.categories,
              pageBuilder: (c, s) => const NoTransitionPage(child: CategoriesScreen()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.cart,
              pageBuilder: (c, s) => const NoTransitionPage(child: CartScreen()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.orders,
              pageBuilder: (c, s) => const NoTransitionPage(child: OrdersScreen()),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.profile,
              pageBuilder: (c, s) => const NoTransitionPage(child: ProfileScreen()),
            ),
          ]),
        ],
      ),
      // ---- Shell tashqarisidagi (to'liq ekran) sahifalar ----
      GoRoute(
        path: AppRoutes.search,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _fade(SearchScreen(initialQuery: s.uri.queryParameters['q'])),
      ),
      GoRoute(
        path: AppRoutes.product,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _slide(ProductDetailScreen(productId: s.pathParameters['id']!)),
      ),
      GoRoute(
        path: AppRoutes.category,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _slide(CategoryProductsScreen(
          categoryId: s.pathParameters['id']!,
          subcategory: s.uri.queryParameters['sub'],
        )),
      ),
      GoRoute(
        path: AppRoutes.collection,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _slide(CollectionScreen(tag: s.pathParameters['tag']!)),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _slide(const CheckoutScreen()),
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _fade(OrderSuccessScreen(orderId: s.pathParameters['id']!)),
      ),
      GoRoute(
        path: AppRoutes.orderDetail,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _slide(OrderDetailScreen(orderId: s.pathParameters['id']!)),
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _slide(const WishlistScreen()),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _slide(const AddressesScreen()),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _slide(const EditProfileScreen()),
      ),
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _slide(const SettingsScreen()),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _slide(const NotificationsScreen()),
      ),
      GoRoute(
        path: AppRoutes.help,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _slide(const HelpScreen()),
      ),
      GoRoute(
        path: AppRoutes.about,
        parentNavigatorKey: _rootKey,
        pageBuilder: (c, s) => _slide(const AboutScreen()),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Xatolik')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 56),
              const SizedBox(height: 12),
              Text('Sahifa topilmadi: ${state.uri}', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Bosh sahifaga'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
});

CustomTransitionPage<void> _slide(Widget child) => CustomTransitionPage<void>(
      child: child,
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondary, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(begin: const Offset(0.06, 0), end: Offset.zero).animate(curved),
            child: child,
          ),
        );
      },
    );

CustomTransitionPage<void> _fade(Widget child) => CustomTransitionPage<void>(
      child: child,
      transitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondary, child) =>
          FadeTransition(opacity: animation, child: child),
    );
