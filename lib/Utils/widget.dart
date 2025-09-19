import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Updated navigation functions for GoRouter compatibility
void nextScreen(BuildContext context, Widget page) {
  // For web compatibility, we'll try to use named routes when possible
  // This is a fallback for when we need to navigate with a widget
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(BuildContext context, Widget page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

// New GoRouter navigation functions
void goToRoute(BuildContext context, String route, {Object? extra}) {
  if (extra != null) {
    context.go(route, extra: extra);
  } else {
    context.go(route);
  }
}

void pushRoute(BuildContext context, String route, {Object? extra}) {
  if (extra != null) {
    context.push(route, extra: extra);
  } else {
    context.push(route);
  }
}

void replaceRoute(BuildContext context, String route, {Object? extra}) {
  if (extra != null) {
    context.pushReplacement(route, extra: extra);
  } else {
    context.pushReplacement(route);
  }
}

// Navigation helpers for specific routes
class AppRoutes {
  static void goToProductDetails(
    BuildContext context,
    String productId,
    Map<String, dynamic> productData,
  ) {
    context.push('/product/$productId', extra: productData);
  }

  static void goToCheckout(
    BuildContext context,
    List<Map<String, dynamic>> cartItems,
    double grandTotal,
    String walletBalance,
  ) {
    context.push('/checkout', extra: {
      'cartItems': cartItems,
      'grandTotal': grandTotal,
      'walletbalance': walletBalance,
    });
  }

  static void goToOrderDetails(
      BuildContext context, String orderId, dynamic orderData) {
    context.push('/order-details/$orderId', extra: orderData);
  }

  static void goToOrderTrack(
    BuildContext context,
    String orderId,
    String status,
    String date,
    String estimated,
  ) {
    context.push('/order-track/$orderId', extra: {
      'status': status,
      'orderid': orderId,
      'date': date,
      'estimated': estimated,
    });
  }

  static void goToEditAddress(
    BuildContext context,
    String addressId,
    Map<String, dynamic> addressData,
  ) {
    context.push('/edit-address/$addressId', extra: addressData);
  }

  static void goToPdfViewer(
    BuildContext context,
    String pdfId,
    String pdfUrl,
    String title,
    String switches,
  ) {
    context.push('/pdf-viewer/$pdfId', extra: {
      'pdfUrl': pdfUrl,
      'title': title,
      'switches': switches,
    });
  }

  static void goToCategory(BuildContext context, String categoryName) {
    context.push('/category/$categoryName');
  }

  static void goToExclusive(BuildContext context, String categoryName) {
    context.push('/exclusive/$categoryName');
  }
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}
