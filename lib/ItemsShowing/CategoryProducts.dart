import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hakikat_app_new/AdminSide/editproduct.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/defaultimage.dart';
import 'package:hakikat_app_new/Utils/widget.dart';
import 'package:shimmer/shimmer.dart';

class CategoryProduct extends StatefulWidget {
  final String? categoryname;
  const CategoryProduct({super.key, this.categoryname});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  final databaseRef = FirebaseDatabase.instance.ref();
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
            child: _isLoading ? _buildShimmerGrid() : _buildProductGrid(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey[700],
            size: 18,
          ),
        ),
      ),
      title: Text(
        widget.categoryname ?? 'All Products',
        style: TextStyle(
          color: const Color(0xFF181725),
          fontSize: isWeb ? 20 : 18,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        if (!_isLoading)
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.greenthemecolor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${filteredProducts.length} items',
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
                          filterProducts('');
                          setState(() {
                            _hasSearched = false;
                          });
                        },
                        icon: Icon(
                          Icons.clear_rounded,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                      )
                    : null,
                hintText: 'Search products...',
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

  Widget _buildProductGrid() {
    if (filteredProducts.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: AppColors.greenthemecolor,
      onRefresh: _refreshData,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: _getChildAspectRatio(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount: _getCrossAxisCount(),
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> product = filteredProducts[index];
            return _buildProductItem(product);
          },
        ),
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return Items(
      ontap: () => _navigateToProductDetails(product),
      onadd: () => _navigateToEditProduct(product),
      img: _getProductImage(product),
      price: product['Product Price']?.toString() ?? '0',
      title: product['Product Title'] ?? '',
      subtitle: product['Product Subtitle'] ?? '',
    );
  }

  Widget _buildEmptyState() {
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
              _hasSearched ? Icons.search_off : Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _hasSearched ? 'No products found' : 'No products available',
            style: TextStyle(
              fontSize: isWeb ? 20 : 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _hasSearched
                ? 'Try searching with different keywords'
                : 'Products will appear here when available',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (_hasSearched) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                searchController.clear();
                filterProducts('');
                setState(() {
                  _hasSearched = false;
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

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: _getChildAspectRatio(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            crossAxisCount: _getCrossAxisCount(),
          ),
          itemCount: 8, // Show 8 shimmer items
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

  int _getCrossAxisCount() {
    if (isTablet) return 4;
    if (isWeb) return 3;
    return 2;
  }

  double _getChildAspectRatio() {
    if (isWeb) return 0.8;
    if (isTablet) return 0.75;
    return 0.75;
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
    // The fetchProducts listener will automatically update the data
  }

  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(products);
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
        filteredProducts.clear();

        data.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> product = {
              'Product Stock': value['Product Stock'],
              'Product Title': value['Product Title'],
              'Product Subtitle': value['Product Subtitle'],
              'Product Img': value['Product Img'],
              'Product Price': value['Product Price'],
              'id': value['id'],
              'Product Discription': value['Product Discription'],
              'Exclusive':
                  value.containsKey('Exclusive') && value['Exclusive'] == true,
              'BestSelling': value.containsKey('BestSelling') &&
                  value['BestSelling'] == true,
            };

            if (widget.categoryname == 'All Products' ||
                (value.containsKey('Category') &&
                    value['Category'] == widget.categoryname)) {
              if (mounted) {
                setState(() {
                  products.add(product);
                  if (searchController.text.isEmpty) {
                    filteredProducts.add(product);
                  }
                });
              }
            }
          }
        });

        // Apply current search filter if there's text in search field
        if (mounted && searchController.text.isNotEmpty) {
          filterProducts(searchController.text);
        }
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
    super.dispose();
  }
}
