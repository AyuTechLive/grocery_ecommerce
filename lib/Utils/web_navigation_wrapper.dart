import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class WebNavigationWrapper extends StatefulWidget {
  final Widget child;

  const WebNavigationWrapper({
    super.key,
    required this.child,
  });

  @override
  State<WebNavigationWrapper> createState() => _WebNavigationWrapperState();
}

class _WebNavigationWrapperState extends State<WebNavigationWrapper> {
  String _currentPath = '/home';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = GoRouterState.of(context);
    _currentPath = route.uri.path;
  }

  void _navigateTo(String path) {
    context.go(path);
    setState(() {
      _currentPath = path;
    });
    // Close drawer on mobile after navigation
    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768 && screenWidth <= 1024;

    if (kIsWeb && isDesktop) {
      return _buildDesktopLayout();
    } else if (kIsWeb && isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Logo
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.greenthemecolor,
              child: Image.asset(
                'assets/hakikat.png',
                width: 30,
                height: 30,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.store,
                    color: Colors.white,
                    size: 24,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Hakeeqat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 40),
            // Navigation Items
            _buildTopNavItem('Home', '/home'),
            _buildTopNavItem('Explore', '/explore'),
            _buildTopNavItem('Cart', '/cart'),
            _buildTopNavItem('Favorites', '/favorites'),
            _buildTopNavItem('My Orders', '/my-orders'),
            _buildTopNavItem('Wallet', '/wallet'),
            _buildTopNavItem('Events', '/events'),
          ],
        ),
        actions: [
          // User Menu
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              } else {
                _navigateTo(value);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: '/account',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Account'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: '/addresses',
                child: ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Addresses'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: '/refer-earn',
                child: ListTile(
                  leading: Icon(Icons.card_giftcard),
                  title: Text('Refer & Earn'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: '/pdf-list',
                child: ListTile(
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text('Store Items'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: '/help',
                child: ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Help'),
                  dense: true,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Logout', style: TextStyle(color: Colors.red)),
                  dense: true,
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_circle,
                      size: 32, color: AppColors.greenthemecolor),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: widget.child,
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/hakikat.png',
              width: 32,
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.store,
                  color: AppColors.greenthemecolor,
                  size: 32,
                );
              },
            ),
            const SizedBox(width: 12),
            const Text(
              'Hakeekat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _navigateTo('/cart'),
            icon: const Icon(Icons.shopping_cart),
            color: _currentPath == '/cart' ? AppColors.greenthemecolor : null,
          ),
          IconButton(
            onPressed: () => _navigateTo('/favorites'),
            icon: const Icon(Icons.favorite),
            color:
                _currentPath == '/favorites' ? AppColors.greenthemecolor : null,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              } else {
                _navigateTo(value);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: '/my-orders',
                child: ListTile(
                  leading: Icon(Icons.receipt_long),
                  title: Text('My Orders'),
                ),
              ),
              const PopupMenuItem(
                value: '/wallet',
                child: ListTile(
                  leading: Icon(Icons.account_balance_wallet),
                  title: Text('Wallet'),
                ),
              ),
              const PopupMenuItem(
                value: '/account',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Account'),
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
            child: const Icon(Icons.account_circle),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.greenthemecolor,
        unselectedItemColor: Colors.grey,
        currentIndex: _getBottomNavIndex(),
        onTap: (index) {
          switch (index) {
            case 0:
              _navigateTo('/home');
              break;
            case 1:
              _navigateTo('/explore');
              break;
            case 2:
              _navigateTo('/cart');
              break;
            case 3:
              _navigateTo('/favorites');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            // Header
            Container(
              height: 200,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.greenthemecolor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/hakikat.png',
                      width: 60,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.store,
                          color: Colors.green,
                          size: 40,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hakeekat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerNavItem(
                    icon: Icons.home,
                    title: 'Home',
                    path: '/home',
                    isSelected: _currentPath == '/home',
                  ),
                  _buildDrawerNavItem(
                    icon: Icons.explore,
                    title: 'Explore',
                    path: '/explore',
                    isSelected: _currentPath == '/explore',
                  ),
                  _buildDrawerNavItem(
                    icon: Icons.shopping_cart,
                    title: 'Cart',
                    path: '/cart',
                    isSelected: _currentPath == '/cart',
                  ),
                  _buildDrawerNavItem(
                    icon: Icons.favorite,
                    title: 'Favorites',
                    path: '/favorites',
                    isSelected: _currentPath == '/favorites',
                  ),
                  const Divider(),
                  _buildDrawerNavItem(
                    icon: Icons.receipt_long,
                    title: 'My Orders',
                    path: '/my-orders',
                    isSelected: _currentPath == '/my-orders',
                  ),
                  _buildDrawerNavItem(
                    icon: Icons.account_balance_wallet,
                    title: 'Wallet',
                    path: '/wallet',
                    isSelected: _currentPath == '/wallet',
                  ),
                  _buildDrawerNavItem(
                    icon: Icons.location_on,
                    title: 'Addresses',
                    path: '/addresses',
                    isSelected: _currentPath == '/addresses',
                  ),
                  _buildDrawerNavItem(
                    icon: Icons.event,
                    title: 'Events',
                    path: '/events',
                    isSelected: _currentPath == '/events',
                  ),
                  _buildDrawerNavItem(
                    icon: Icons.card_giftcard,
                    title: 'Refer & Earn',
                    path: '/refer-earn',
                    isSelected: _currentPath == '/refer-earn',
                  ),
                  _buildDrawerNavItem(
                    icon: Icons.picture_as_pdf,
                    title: 'Store Items',
                    path: '/pdf-list',
                    isSelected: _currentPath == '/pdf-list',
                  ),
                  _buildDrawerNavItem(
                    icon: Icons.help,
                    title: 'Help',
                    path: '/help',
                    isSelected: _currentPath == '/help',
                  ),
                  const Divider(),
                  _buildDrawerNavItem(
                    icon: Icons.person,
                    title: 'Account',
                    path: '/account',
                    isSelected: _currentPath == '/account',
                  ),
                ],
              ),
            ),
            // Logout Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 18),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.greenthemecolor,
        unselectedItemColor: Colors.grey,
        currentIndex: _getBottomNavIndex(),
        onTap: (index) {
          switch (index) {
            case 0:
              _navigateTo('/home');
              break;
            case 1:
              _navigateTo('/explore');
              break;
            case 2:
              _navigateTo('/cart');
              break;
            case 3:
              _navigateTo('/favorites');
              break;
            case 4:
              _navigateTo('/account');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavItem(String title, String path) {
    final isSelected = _currentPath == path;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () => _navigateTo(path),
        style: TextButton.styleFrom(
          foregroundColor:
              isSelected ? AppColors.greenthemecolor : Colors.grey[700],
          backgroundColor: isSelected
              ? AppColors.greenthemecolor.withOpacity(0.1)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerNavItem({
    required IconData icon,
    required String title,
    required String path,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppColors.greenthemecolor : Colors.grey[600],
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.greenthemecolor : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        selected: isSelected,
        selectedTileColor: AppColors.greenthemecolor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: () => _navigateTo(path),
      ),
    );
  }

  int _getBottomNavIndex() {
    switch (_currentPath) {
      case '/home':
        return 0;
      case '/explore':
        return 1;
      case '/cart':
        return 2;
      case '/favorites':
        return 3;
      case '/account':
        return 4;
      default:
        return 0;
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((_) {
                  Navigator.of(context).pop();
                  context.go('/login');
                });
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}
