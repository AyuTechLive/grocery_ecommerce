import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hakikat_app_new/Account/addressscreen.dart';
import 'package:hakikat_app_new/AdminSide/editproduct.dart';
import 'package:hakikat_app_new/Auth/login.dart';
import 'package:hakikat_app_new/Explore/explore.dart';
import 'package:hakikat_app_new/Home/Components/homecategroyitem.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/Home/Components/sectionheader.dart';
import 'package:hakikat_app_new/Home/mainpage.dart';
import 'package:hakikat_app_new/ItemsShowing/CategoryProducts.dart';
import 'package:hakikat_app_new/ItemsShowing/Exclusiveitemshowing.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/defaultimage.dart';
import 'package:hakikat_app_new/Utils/widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  final searchController = TextEditingController();
  final searchcontroller = TextEditingController();
  final fireStore2 =
      FirebaseFirestore.instance.collection('Banners').snapshots();
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('Categories');
  String? _selectedAddress;
  bool _isLoading = true;

  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  // Responsive breakpoints
  static const double webBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  bool get isWeb => MediaQuery.of(context).size.width > webBreakpoint;
  bool get isTablet => MediaQuery.of(context).size.width > tabletBreakpoint;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> _navigateToAddressScreen(BuildContext context) async {
    final selectedAddress = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressScreen(
          onAddressSelected: (address) {
            setState(() {
              _selectedAddress = address;
            });
          },
        ),
      ),
    );

    if (selectedAddress != null) {
      setState(() {
        _selectedAddress = selectedAddress;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _isLoading
          ? _buildShimmerEffect()
          : RefreshIndicator(
              onRefresh: _refreshData,
              color: AppColors.greenthemecolor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (kIsWeb) _buildWebHeader(),
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    _buildBannerSection(),
                    const SizedBox(height: 24),
                    if (filteredProducts.isNotEmpty) _buildExclusiveSection(),
                    _buildCategoriesSection(),
                    const SizedBox(height: 24),
                    if (_getBestSellingProducts().isNotEmpty)
                      _buildBestSellingSection(),
                    if (products.isNotEmpty) _buildAllProductsSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (kIsWeb) return null;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      title: _buildAppBarContent(),
    );
  }

  Widget _buildAppBarContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_pin, color: Colors.grey[600], size: 20),
        const SizedBox(width: 4),
        Expanded(
          child: TextButton(
            onPressed: () => _navigateToAddressScreen(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Text(
              _selectedAddress ?? 'Select Address',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF4C4E4D),
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.greenthemecolor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => _launchDialer('9672261265'),
            icon: Icon(
              Icons.call_outlined,
              color: AppColors.greenthemecolor,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'profile') {
              // Navigate to profile
            } else if (value == 'settings') {
              // Navigate to settings
            } else if (value == 'logout') {
              _showLogoutDialog();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Profile'),
                dense: true,
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text('Settings'),
                dense: true,
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Sign Out', style: TextStyle(color: Colors.red)),
                dense: true,
              ),
            ),
          ],
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: null,
              icon: Icon(
                Icons.account_circle_outlined,
                color: Colors.grey[700],
                size: 20,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildWebHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.location_pin, color: Colors.grey[600]),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => _navigateToAddressScreen(context),
            child: Text(
              _selectedAddress ?? 'Select Address',
              style: const TextStyle(
                color: Color(0xFF4C4E4D),
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: AppColors.greenthemecolor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => _launchDialer('9672261265'),
              icon: Icon(
                Icons.call_outlined,
                color: AppColors.greenthemecolor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                // Navigate to profile
              } else if (value == 'settings') {
                // Navigate to settings
              } else if (value == 'logout') {
                _showLogoutDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text('Profile'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('Settings'),
                  dense: true,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Sign Out', style: TextStyle(color: Colors.red)),
                  dense: true,
                ),
              ),
            ],
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.grey[700],
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: searchcontroller,
        cursorColor: const Color(0xFF4C4E4D),
        decoration: InputDecoration(
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.search_rounded,
              color: Colors.grey[500],
              size: 22,
            ),
          ),
          hintText: 'Search for products, categories...',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: isWeb ? 16 : 14,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onTap: () => nextScreen(context, Explore()),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildBannerSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore2,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildBannerShimmer();
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            _buildBannerCarousel(snapshot.data!.docs),
            const SizedBox(height: 16),
            _buildBannerIndicators(snapshot.data!.docs.length),
          ],
        );
      },
    );
  }

  Widget _buildBannerCarousel(List<QueryDocumentSnapshot> banners) {
    return CarouselSlider(
      carouselController: _controller,
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        enlargeCenterPage: false,
        viewportFraction: 1.0,
        height: isWeb ? 350 : 200,
        enableInfiniteScroll: true,
        onPageChanged: (index, reason) {
          setState(() => _currentIndex = index);
        },
      ),
      items: banners.map((document) {
        String imageUrl = document['Banner Image Link'] ?? '';
        return _buildBannerItem(imageUrl);
      }).toList(),
    );
  }

  Widget _buildBannerItem(String imageUrl) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) => Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey[400],
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'Image not available',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.greenthemecolor),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBannerIndicators(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentIndex == index
                ? AppColors.greenthemecolor
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Sectionheader(
          title: 'Categories',
          ontap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return MainPage(index: 1);
              },
            ));
          },
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: _categoriesCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _buildErrorMessage('Error loading categories');
            }
            if (!snapshot.hasData) {
              return _buildCategoryShimmer();
            }

            final documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return _buildEmptyState('No categories available');
            }

            return SizedBox(
              height: isWeb ? 120 : 100,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemCount: documents.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    _buildCategoryItem(documents[index]),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryItem(QueryDocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>?;
    if (data == null) return const SizedBox.shrink();

    return HomeCategoryItems(
      img: data['Category Img'] ?? '',
      title: data['Category Name'] ?? '',
      ontap: () {
        nextScreen(
          context,
          CategoryProduct(
            categoryname: data['Category Name'] ?? '',
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getBestSellingProducts() {
    return products.where((product) => product['BestSelling'] == true).toList();
  }

  Widget _buildExclusiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Sectionheader(
          title: 'Exclusive Offers',
          ontap: () {
            nextScreen(context, ExclusiveItems(categoryname: 'Exclusive'));
          },
        ),
        const SizedBox(height: 12),
        _buildProductList(filteredProducts, 5),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBestSellingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Sectionheader(
          title: 'Best Selling',
          ontap: () {
            nextScreen(context, ExclusiveItems(categoryname: 'BestSelling'));
          },
        ),
        const SizedBox(height: 12),
        _buildProductList(_getBestSellingProducts(), 5),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAllProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Sectionheader(
          title: 'All Products',
          ontap: () {
            nextScreen(
                context,
                CategoryProduct(
                  categoryname: 'All Products',
                ));
          },
        ),
        const SizedBox(height: 12),
        _buildProductList(products, 5),
      ],
    );
  }

  Widget _buildProductList(
      List<Map<String, dynamic>> productList, int maxItems) {
    if (productList.isEmpty) {
      return _buildEmptyState('No products available');
    }

    return SizedBox(
      height: isWeb ? 300 : 260,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemCount:
            productList.length > maxItems ? maxItems : productList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => _buildProductItem(productList[index]),
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return SizedBox(
      width: isWeb ? 200 : 160,
      child: Items(
        ontap: () => _navigateToProductDetails(product),
        onadd: () => _navigateToEditProduct(product),
        img: _getProductImage(product),
        price: product['Product Price']?.toString() ?? '0',
        title: product['Product Title'] ?? '',
        subtitle: product['Product Subtitle'] ?? '',
      ),
    );
  }

  String _getProductImage(Map<String, dynamic> product) {
    if (product['Product Img'] != null && product['Product Img'].isNotEmpty) {
      return product['Product Img'][0];
    }
    return AppImage.defaultimgurl;
  }

  void _navigateToProductDetails(Map<String, dynamic> product) {
    nextScreen(
        context,
        ProductDetails(
          discription: product['Product Discription'] ?? '',
          imageUrls: List<String>.from(
              product['Product Img'] ?? [AppImage.defaultimgurl]),
          orderid: product['id'],
          img: _getProductImage(product),
          maxquantity: product['Product Stock'] != null
              ? int.tryParse(product['Product Stock'].toString()) ?? 0
              : 0,
          price: product['Product Price'],
          title: product['Product Title'] ?? '',
          subtitle: product['Product Subtitle'] ?? '',
        ));
  }

  void _navigateToEditProduct(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(
          imageUrls: List<String>.from(
            (product['Product Img'] ?? []).where(
              (url) => url != AppImage.defaultimgurl,
            ),
          ),
          productId: product['id'],
          initialProductData: product,
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[600]),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.red[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      height: 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              color: Colors.grey[400],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: isWeb ? 350 : 180,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildCategoryShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              width: isWeb ? 200 : 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar shimmer
            Container(
              height: 56,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            // Banner shimmer
            Container(
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 24),
            // Categories shimmer
            _buildCategoryShimmer(),
            const SizedBox(height: 24),
            // Product sections shimmer
            for (int i = 0; i < 3; i++) ...[
              Container(
                height: 24,
                width: 150,
                color: Colors.white,
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              SizedBox(
                height: 240,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 160,
                      margin:
                          EdgeInsets.only(left: 16, right: index == 4 ? 16 : 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      await launchUrl(launchUri);
    } catch (e) {
      debugPrint('Could not launch $launchUri: $e');
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first

                try {
                  // Show loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.greenthemecolor,
                        ),
                      ),
                    ),
                  );

                  // Sign out from Firebase
                  await FirebaseAuth.instance.signOut();

                  // Close loading dialog
                  if (mounted) Navigator.of(context).pop();

                  // Navigate to login screen or show success message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Successfully signed out'),
                        backgroundColor: AppColors.greenthemecolor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );

                    // Navigate to login screen - adjust the route name as needed
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  // Close loading dialog if still open
                  if (mounted) Navigator.of(context).pop();

                  // Show error message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error signing out: ${e.toString()}'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) => (product['Product Title'] ?? '')
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void fetchProducts() {
    databaseRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        products.clear();
        filteredProducts.clear();

        data.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> product = {
              'id': value['id'],
              'Product Stock': value['Product Stock'],
              'Product Price': value['Product Price'],
              'Product Title': value['Product Title'],
              'Product Subtitle': value['Product Subtitle'],
              'Product Discription': value['Product Discription'],
              'Product Img': value['Product Img'],
              'Exclusive':
                  value.containsKey('Exclusive') && value['Exclusive'] == true,
              'BestSelling': value.containsKey('BestSelling') &&
                  value['BestSelling'] == true,
            };
            if (mounted) {
              setState(() {
                products.add(product);
                if (product['Exclusive'] == true) {
                  filteredProducts.add(product);
                }
              });
            }
          }
        });
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchcontroller.dispose();
    super.dispose();
  }
}
