import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hakikat_app_new/AdminSide/editcategory.dart';
import 'package:hakikat_app_new/AdminSide/editproduct.dart';
import 'package:hakikat_app_new/Explore/components/categorycard.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/ItemsShowing/CategoryProducts.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/defaultimage.dart';
import 'package:hakikat_app_new/Utils/widget.dart';
import 'package:shimmer/shimmer.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final databaseRef = FirebaseDatabase.instance.ref();
  final CollectionReference _categoriesCollection =
      FirebaseFirestore.instance.collection('Categories');
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  final searchController = TextEditingController();
  bool _isLoading = true;
  bool _hasSearched = false;

  // Responsive breakpoints
  static const double webBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  bool get isWeb => MediaQuery.of(context).size.width > webBreakpoint;
  bool get isTablet => MediaQuery.of(context).size.width > tabletBreakpoint;

  @override
  void initState() {
    super.initState();
    fetchProducts();
    // Add a small delay for loading state
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchSection(),
          Expanded(
            child: _isLoading ? _buildShimmerContent() : _buildMainContent(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      title: Text(
        'Find Products',
        style: TextStyle(
          color: const Color(0xFF181725),
          fontSize: isWeb ? 24 : 20,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        if (_hasSearched)
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.greenthemecolor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${filteredProducts.length} found',
              style: TextStyle(
                color: AppColors.greenthemecolor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          Container(
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
              controller: searchController,
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
                suffixIcon: _hasSearched && searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            _hasSearched = false;
                            filteredProducts = [];
                          });
                        },
                        icon: Icon(
                          Icons.clear_rounded,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                      )
                    : null,
                hintText: 'Search for products or categories...',
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
              onChanged: (value) {
                filterProducts(value);
                setState(() {
                  _hasSearched = value.isNotEmpty;
                });
              },
            ),
          ),
          if (_hasSearched && searchController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.search,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Searching for "${searchController.text}"',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_hasSearched) {
      return _buildProductSearchResults();
    } else {
      return _buildCategoriesGrid();
    }
  }

  Widget _buildCategoriesGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: _categoriesCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState('Error loading categories');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerGrid(isCategory: true);
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState('No categories available', Icons.category);
        }

        return RefreshIndicator(
          color: AppColors.greenthemecolor,
          onRefresh: _refreshData,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                crossAxisCount: _getCrossAxisCount(),
                childAspectRatio: _getCategoryAspectRatio(),
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return CategoryCard(
                  ontap: () => _navigateToCategoryEdit(data),
                  color: const Color(0x19F8A44C),
                  img: data['Category Img'] ?? AppImage.defaultimgurl,
                  title: data['Category Name'] ?? '',
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductSearchResults() {
    if (filteredProducts.isEmpty) {
      return _buildEmptyState(
        'No products found',
        Icons.search_off,
        subtitle: 'Try searching with different keywords',
        showClearButton: true,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: _getProductAspectRatio(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          crossAxisCount: _getProductCrossAxisCount(),
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> product = filteredProducts[index];
          return Items(
            ontap: () => _navigateToProductDetails(product),
            onadd: () => _navigateToEditProduct(product),
            img: _getProductImage(product),
            price: product['Product Price']?.toString() ?? '0',
            title: product['Product Title'] ?? '',
            subtitle: product['Product Subtitle'] ?? '',
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(
    String message,
    IconData icon, {
    String? subtitle,
    bool showClearButton = false,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: isWeb ? 20 : 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (showClearButton) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                searchController.clear();
                setState(() {
                  _hasSearched = false;
                  filteredProducts = [];
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenthemecolor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Clear Search'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContent() {
    return _buildShimmerGrid(isCategory: !_hasSearched);
  }

  Widget _buildShimmerGrid({required bool isCategory}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount:
                isCategory ? _getCrossAxisCount() : _getProductCrossAxisCount(),
            childAspectRatio: isCategory
                ? _getCategoryAspectRatio()
                : _getProductAspectRatio(),
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Container(
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

  // Responsive grid configurations
  int _getCrossAxisCount() {
    if (isTablet) return 3;
    if (isWeb) return 3;
    return 2;
  }

  int _getProductCrossAxisCount() {
    if (isTablet) return 4;
    if (isWeb) return 3;
    return 2;
  }

  double _getCategoryAspectRatio() {
    if (isWeb) return 1.2;
    return 1.0;
  }

  double _getProductAspectRatio() {
    if (isWeb) return 0.8;
    return 0.75;
  }

  String _getProductImage(Map<String, dynamic> product) {
    if (product['Product Img'] != null && product['Product Img'].isNotEmpty) {
      return product['Product Img'][0];
    }
    return AppImage.defaultimgurl;
  }

  void _navigateToCategoryEdit(Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCategoryScreen(
          categoryId: data['Category Name'],
          initialCategoryName: data['Category Name'],
          initialCategoryImageUrl: data['Category Img'],
        ),
      ),
    );
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
      ),
    );
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

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isLoading = false;
    });
  }

  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = [];
      } else {
        filteredProducts = products
            .where((product) => (product['Product Title'] ?? '')
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void fetchProducts() {
    databaseRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        products.clear();

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
            if (mounted) {
              setState(() {
                products.add(product);
              });
            }
          }
        });

        // Apply current search filter if there's text in search field
        if (mounted && searchController.text.isNotEmpty) {
          filterProducts(searchController.text);
        }
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
