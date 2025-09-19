import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hakikat_app_new/Explore/components/categorycard.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/Utils/appimg.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/responsive_helper.dart';
import 'package:hakikat_app_new/Utils/widget.dart';
import 'package:shimmer/shimmer.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with TickerProviderStateMixin {
  final databaseRef = FirebaseDatabase.instance.ref();
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('Categories');
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  final searchController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isSearching = false;
  String _currentSearchQuery = '';
  Timer? _debounceTimer;

  late AnimationController _animationController;
  late AnimationController _searchAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  bool get isWeb => kIsWeb || MediaQuery.of(context).size.width > 600;
  bool get isTablet => MediaQuery.of(context).size.width > 900;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    fetchProducts();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    _animationController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  void fetchProducts() {
    databaseRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> newProducts = [];

        data.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> product = {
              'Product Title': value['Product Title'],
              'Product Subtitle': value['Product Subtitle'],
              'Product Img': value['Product Img'],
              'Product Price': value['Product Price'],
              'Product Stock': value['Product Stock'],
              'id': value['id'],
              'Product Discription': value['Product Discription'],
            };
            newProducts.add(product);
          }
        });

        if (mounted) {
          setState(() {
            products = newProducts;
            filteredProducts = products;
            _isLoading = false;
          });
          _animationController.forward();
        }
      }
    });
  }

  void _debounceSearch(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _filterProducts(query);
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _currentSearchQuery = query;
      if (query.isEmpty) {
        filteredProducts = products;
        _isSearching = false;
      } else {
        filteredProducts = products
            .where((product) =>
                (product['Product Title'] ?? '')
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (product['Product Subtitle'] ?? '')
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
        _isSearching = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.greenthemecolor,
        child: Column(
          children: [
            _buildSearchSection(),
            _buildContentHeader(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    if (isWeb) return null;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      automaticallyImplyLeading: false,
      title: const Text(
        'Explore',
        style: TextStyle(
          color: Color(0xFF181725),
          fontSize: 24,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            // Add filter functionality
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.tune,
              color: Color(0xFF4C4E4D),
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.all(isWeb ? 24 : 16),
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
      child: Column(
        children: [
          if (isWeb) ...[
            const Text(
              'Explore',
              style: TextStyle(
                color: Color(0xFF181725),
                fontSize: 28,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
          ],
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: ResponsiveHelper.getWidth(
        context,
        mobile: double.infinity,
        tablet: MediaQuery.of(context).size.width * 0.7,
        desktop: MediaQuery.of(context).size.width * 0.5,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isSearching ? AppColors.greenthemecolor : Colors.grey[200]!,
          width: _isSearching ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: searchController,
        cursorColor: AppColors.greenthemecolor,
        decoration: InputDecoration(
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.search_rounded,
              color:
                  _isSearching ? AppColors.greenthemecolor : Colors.grey[500],
              size: 22,
            ),
          ),
          suffixIcon: _currentSearchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    searchController.clear();
                    _filterProducts('');
                  },
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Colors.grey[500],
                    size: 20,
                  ),
                )
              : null,
          hintText: 'Search products and categories...',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: isWeb ? 16 : 14,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onChanged: (value) => _debounceSearch(value),
      ),
    );
  }

  Widget _buildContentHeader() {
    if (_isLoading) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 24 : 16,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _isSearching
                ? '${filteredProducts.length} Products Found'
                : 'Categories',
            style: TextStyle(
              color: const Color(0xFF181725),
              fontSize: isWeb ? 20 : 18,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          ),
          if (_isSearching && _currentSearchQuery.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                searchController.clear();
                _filterProducts('');
              },
              icon: Icon(
                Icons.clear_all,
                size: 18,
                color: AppColors.greenthemecolor,
              ),
              label: Text(
                'Clear Search',
                style: TextStyle(
                  color: AppColors.greenthemecolor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildShimmerGrid();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: _isSearching ? _buildProductGrid() : _buildCategoriesGrid(),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState('Error loading categories');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerGrid();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            'No categories available',
            'Categories will appear here once they are added.',
          );
        }

        return ResponsiveWidget(
          mobile: _buildCategoryGridView(snapshot.data!.docs, 2),
          tablet: _buildCategoryGridView(snapshot.data!.docs, 3),
          desktop: _buildCategoryGridView(snapshot.data!.docs, 4),
        );
      },
    );
  }

  Widget _buildCategoryGridView(
      List<QueryDocumentSnapshot> docs, int crossAxisCount) {
    return GridView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(isWeb ? 24 : 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isWeb ? 20 : 12,
        mainAxisSpacing: isWeb ? 20 : 16,
        childAspectRatio: 1.0,
      ),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;
        return _buildCategoryItem(data, index);
      },
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> data, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 200 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: CategoryCard(
            ontap: () {
              HapticFeedback.lightImpact();
              AppRoutes.goToCategory(
                context,
                data['Category Name'],
              );
            },
            color: const Color(0x19F8A44C),
            img: data['Category Img'] ?? '',
            title: data['Category Name'] ?? '',
          ),
        );
      },
    );
  }

  Widget _buildProductGrid() {
    if (filteredProducts.isEmpty) {
      return _buildEmptyState(
        'No products found',
        'Try searching with different keywords or browse categories.',
      );
    }

    return ResponsiveWidget(
      mobile: _buildProductGridView(2),
      tablet: _buildProductGridView(3),
      desktop: _buildProductGridView(4),
    );
  }

  Widget _buildProductGridView(int crossAxisCount) {
    return GridView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(isWeb ? 24 : 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: isWeb ? 20 : 12,
        mainAxisSpacing: isWeb ? 24 : 16,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _buildProductItem(product, index);
      },
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 200 + (index * 30)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Items(
            ontap: () => _navigateToProductDetails(context, product),
            onadd: () => _navigateToProductDetails(context, product),
            img: _getProductImage(product),
            price: product['Product Price']?.toString() ?? '',
            title: product['Product Title'] ?? '',
            subtitle: product['Product Subtitle'] ?? '',
          ),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ResponsiveWidget(
        mobile: _buildShimmerGridView(2),
        tablet: _buildShimmerGridView(3),
        desktop: _buildShimmerGridView(4),
      ),
    );
  }

  Widget _buildShimmerGridView(int crossAxisCount) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(isWeb ? 24 : 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isWeb ? 20 : 12,
        mainAxisSpacing: isWeb ? 20 : 16,
        childAspectRatio: _isSearching ? 0.75 : 1.0,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isSearching ? Icons.search_off_rounded : Icons.category_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            if (_isSearching) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  searchController.clear();
                  _filterProducts('');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.greenthemecolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Browse Categories',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[300],
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _refreshData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenthemecolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getProductImage(Map<String, dynamic> product) {
    if (product['Product Img'] != null && product['Product Img'].isNotEmpty) {
      return product['Product Img'][0];
    }
    return AppImage.defaultimgurl;
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    fetchProducts();
  }

  void _navigateToProductDetails(
      BuildContext context, Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
    AppRoutes.goToProductDetails(
      context,
      product['id'],
      {
        'discription': product['Product Discription'] ?? '',
        'imageUrls': List<String>.from(
            product['Product Img'] ?? [AppImage.defaultimgurl]),
        'orderid': product['id'],
        'img': _getProductImage(product),
        'maxquantity': product['Product Stock'] != null
            ? int.tryParse(product['Product Stock'].toString()) ?? 0
            : 0,
        'price': product['Product Price'],
        'title': product['Product Title'] ?? '',
        'subtitle': product['Product Subtitle'] ?? '',
      },
    );
  }
}
