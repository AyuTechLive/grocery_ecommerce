import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hakikat_app_new/Account/account.dart';
import 'package:hakikat_app_new/Account/addadress.dart';
import 'package:hakikat_app_new/Account/addressscreen.dart';
import 'package:hakikat_app_new/Account/editaddress.dart';
import 'package:hakikat_app_new/Account/helpscreen.dart';
import 'package:hakikat_app_new/Account/paymentqr.dart';
import 'package:hakikat_app_new/AdminSide/adminpanel.dart';
import 'package:hakikat_app_new/Auth/forgotpassword.dart';
import 'package:hakikat_app_new/Auth/login.dart';
import 'package:hakikat_app_new/Auth/loginwithphoneno.dart';
import 'package:hakikat_app_new/Auth/signup.dart';
import 'package:hakikat_app_new/Cart/democart.dart';
import 'package:hakikat_app_new/CheckoutPage/democheckout.dart';
import 'package:hakikat_app_new/Events/events_page.dart';
import 'package:hakikat_app_new/Explore/explore.dart';
import 'package:hakikat_app_new/Favorites/favorites.dart';
import 'package:hakikat_app_new/Home/homepage.dart';
import 'package:hakikat_app_new/Home/mainpage.dart';
import 'package:hakikat_app_new/ItemsShowing/CategoryProducts.dart';
import 'package:hakikat_app_new/ItemsShowing/Exclusiveitemshowing.dart';
import 'package:hakikat_app_new/OrderSucess/myorder.dart';
import 'package:hakikat_app_new/OrderSucess/orderdetailsscreen.dart';
import 'package:hakikat_app_new/OrderSucess/ordersucess.dart';
import 'package:hakikat_app_new/OrderSucess/ordertrack.dart';
import 'package:hakikat_app_new/Pdf/pdflist.dart';
import 'package:hakikat_app_new/Pdf/pdfopeningscreen.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Referalsystem/referearn.dart';
import 'package:hakikat_app_new/Splashscreen/splashscreen.dart';
import 'package:hakikat_app_new/Utils/web_navigation_wrapper.dart';
import 'package:hakikat_app_new/wallet/mywallet.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

class AppRouterConfig {
  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        final isLoggedIn = user != null;
        final isLoginRoute = state.uri.path == '/login' ||
            state.uri.path == '/signup' ||
            state.uri.path == '/forgot-password' ||
            state.uri.path == '/login-phone';

        // If not logged in and not on login routes, redirect to login
        if (!isLoggedIn && !isLoginRoute && state.uri.path != '/') {
          return '/login';
        }

        // If logged in and on login routes, redirect to home
        if (isLoggedIn && isLoginRoute) {
          return '/home';
        }

        // For splash screen redirect
        if (state.uri.path == '/') {
          return isLoggedIn ? '/home' : '/login';
        }

        return null;
      },
      routes: [
        // Splash Screen
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),

        // Auth Routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignUpNew(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPassword(),
        ),
        GoRoute(
          path: '/login-phone',
          builder: (context, state) => const LoginWithPhoneNo(),
        ),

        // Main Shell Route with Navigation
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return kIsWeb ? WebNavigationWrapper(child: child) : child;
          },
          routes: [
            // Main pages with bottom navigation
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/explore',
              builder: (context, state) => const Explore(),
            ),
            GoRoute(
              path: '/cart',
              builder: (context, state) => CartScreen(),
            ),
            GoRoute(
              path: '/favorites',
              builder: (context, state) => FavoritesScreen(),
            ),
            GoRoute(
              path: '/account',
              builder: (context, state) => const Account(),
            ),

            // Account related routes
            GoRoute(
              path: '/my-orders',
              builder: (context, state) => const MyOrdersScreen(),
            ),
            GoRoute(
              path: '/wallet',
              builder: (context, state) => const MyWallet(),
            ),
            GoRoute(
              path: '/help',
              builder: (context, state) => HelpScreen(),
            ),
            GoRoute(
              path: '/events',
              builder: (context, state) => const EventPage(),
            ),
            GoRoute(
              path: '/refer-earn',
              builder: (context, state) => const ReferEarn(),
            ),
            GoRoute(
              path: '/qr-payment',
              builder: (context, state) => const QrCode(),
            ),
            GoRoute(
              path: '/pdf-list',
              builder: (context, state) => PdfListScreen(),
            ),

            // Address routes
            GoRoute(
              path: '/addresses',
              builder: (context, state) => AddressScreen(
                onAddressSelected: (address) {},
              ),
            ),
            GoRoute(
              path: '/add-address',
              builder: (context, state) => const AddAddress(),
            ),

            // Product and category routes
            GoRoute(
              path: '/category/:categoryName',
              builder: (context, state) {
                final categoryName = state.pathParameters['categoryName'] ?? '';
                return CategoryProduct(categoryname: categoryName);
              },
            ),
            GoRoute(
              path: '/exclusive/:categoryName',
              builder: (context, state) {
                final categoryName = state.pathParameters['categoryName'] ?? '';
                return ExclusiveItems(categoryname: categoryName);
              },
            ),

            // Admin route
            GoRoute(
              path: '/admin',
              builder: (context, state) => const AdminPanel(),
            ),

            // Success pages
            GoRoute(
              path: '/order-success',
              builder: (context, state) => const OrderSucess(),
            ),
          ],
        ),

        // Routes that need specific parameters or are modal-like
        GoRoute(
          path: '/product/:productId',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null) {
              // Redirect to home if no product data
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/home');
              });
              return const SizedBox.shrink();
            }
            return ProductDetails(
              title: extra['title'] ?? '',
              subtitle: extra['subtitle'] ?? '',
              price: extra['price'] ?? '',
              img: extra['img'] ?? '',
              orderid: extra['orderid'] ?? '',
              maxquantity: extra['maxquantity'] ?? 0,
              discription: extra['discription'] ?? '',
              imageUrls: List<String>.from(extra['imageUrls'] ?? []),
            );
          },
        ),

        GoRoute(
          path: '/checkout',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/cart');
              });
              return const SizedBox.shrink();
            }
            return DemoCheckout(
              cartItems:
                  List<Map<String, dynamic>>.from(extra['cartItems'] ?? []),
              grandTotal: extra['grandTotal'] ?? 0.0,
              walletbalance: extra['walletbalance'] ?? '0',
            );
          },
        ),

        GoRoute(
          path: '/order-details/:orderId',
          builder: (context, state) {
            final extra = state.extra;
            if (extra == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/my-orders');
              });
              return const SizedBox.shrink();
            }
            return OrderDetailsScreen(orderData: extra as dynamic);
          },
        ),

        GoRoute(
          path: '/order-track/:orderId',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/my-orders');
              });
              return const SizedBox.shrink();
            }
            return OrderTrack(
              status: extra['status'] ?? '',
              orderid: extra['orderid'] ?? '',
              date: extra['date'] ?? '',
              estimated: extra['estimated'] ?? '',
            );
          },
        ),

        GoRoute(
          path: '/edit-address/:addressId',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/addresses');
              });
              return const SizedBox.shrink();
            }
            return EditAddressScreen(addressData: extra);
          },
        ),

        GoRoute(
          path: '/pdf-viewer/:pdfId',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/pdf-list');
              });
              return const SizedBox.shrink();
            }
            return PdfViwer(
              pdfUrl: extra['pdfUrl'] ?? '',
              title: extra['title'] ?? '',
              swtiches: extra['switches'] ?? '1',
            );
          },
        ),
      ],
    );
  }
}
