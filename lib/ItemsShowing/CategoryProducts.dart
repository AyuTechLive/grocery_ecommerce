import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/appimg.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/widget.dart';
import 'package:shimmer/shimmer.dart';

class CategoryProduct extends StatefulWidget {
  final String? categoryname;
  const CategoryProduct({super.key, this.categoryname});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct>
    with TickerProviderStateMixin {
  final databaseRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> displayedProducts = [];
  final searchController = TextEditingController();

  int _currentPage = 1;
  int _itemsPerPage = 12;
  bool _isLoading = false;
  bool _hasMoreItems = true;
  bool _isInitialLoading = true;
  bool _showSearch = false;

  ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Sort options
  String _currentSortBy = 'default';
  List<String> _sortOptions = [
    'default',
    'price_low_high',
    'price_high_low',
    'name_a_z',
    'name_z_a',
  ];

  Map<String, String> _sortLabels = {
    'default': 'Default',
    'price_low_high': 'Price: Low to High',
    'price_high_low': 'Price: High to Low',
    'name_a_z': 'Name: A to Z',
    'name_z_a': 'Name: Z to A',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    fetchProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMoreItems) {
        _loadMoreItems();
      }
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    int startIndex = displayedProducts.length;
    int endIndex = startIndex + _itemsPerPage;
    if (endIndex > filteredProducts.length) {
      endIndex = filteredProducts.length;
    }

    List<Map<String, dynamic>> newItems =
        filteredProducts.sublist(startIndex, endIndex);

    setState(() {
      displayedProducts.addAll(newItems);
      _currentPage++;
      _isLoading = false;
      _hasMoreItems = endIndex < filteredProducts.length;
    });
  }

  bool get isWeb => MediaQuery.of(context).size.width > 600;
  int get crossAxisCount => isWeb ? 4 : 2;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchAndFilterSection(),
          _buildResultsHeader(),
          Expanded(
            child:
                _isInitialLoading ? _buildShimmerGrid() : _buildProductGrid(),
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
        icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4C4E4D)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.categoryname ?? 'All Products',
        style: const TextStyle(
          color: Color(0xFF4C4E4D),
          fontSize: 20,
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            _showSearch ? Icons.close : Icons.search,
            color: const Color(0xFF4C4E4D),
          ),
          onPressed: () {
            setState(() {
              _showSearch = !_showSearch;
              if (!_showSearch) {
                searchController.clear();
                _resetProducts();
              }
            });
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchAndFilterSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showSearch ? 120 : 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          // Filter and Sort Row
          Row(
            children: [
              Expanded(
                child: _buildSortDropdown(),
              ),
              const SizedBox(width: 12),
              _buildViewToggle(),
            ],
          ),

          // Search Bar (when expanded)
          if (_showSearch) ...[
            const SizedBox(height: 12),
            _buildSearchBar(),
          ],
        ],
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: _currentSortBy,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        icon: Icon(Icons.sort, color: Colors.grey[600]),
        items: _sortOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              _sortLabels[value]!,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _currentSortBy = newValue;
            });
            _applySortAndRefreshDisplay();
          }
        },
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildViewButton(Icons.grid_view, true),
          _buildViewButton(Icons.view_list, false),
        ],
      ),
    );
  }

  Widget _buildViewButton(IconData icon, bool isGrid) {
    bool isActive = isGrid; // For now, only grid view is active
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.greenthemecolor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 20,
        color: isActive ? Colors.white : Colors.grey[600],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextFormField(
        controller: searchController,
        cursorColor: const Color(0xFF4C4E4D),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey[500],
            size: 20,
          ),
          hintText: 'Search products...',
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          _debounceSearch(value);
        },
      ),
    );
  }

  Widget _buildResultsHeader() {
    if (_isInitialLoading) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${filteredProducts.length} Products Found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (searchController.text.isNotEmpty)
            TextButton(
              onPressed: () {
                searchController.clear();
                _resetProducts();
              },
              child: Text(
                'Clear',
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

  Widget _buildProductGrid() {
    if (displayedProducts.isEmpty && !_isLoading) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: AppColors.greenthemecolor,
      onRefresh: () async {
        await _refreshProducts();
      },
      child: GridView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(isWeb ? 24 : 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: isWeb ? 0.8 : 0.75,
          crossAxisSpacing: isWeb ? 20 : 12,
          mainAxisSpacing: isWeb ? 24 : 16,
        ),
        itemCount: displayedProducts.length +
            (_hasMoreItems && !_isLoading ? 0 : 0) +
            (_isLoading ? 2 : 0),
        itemBuilder: (context, index) {
          if (index < displayedProducts.length) {
            return _buildProductItem(displayedProducts[index], index);
          } else {
            return _buildLoadingItem();
          }
        },
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product, int index) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Items(
        ontap: () => navigateToProductDetails(context, product),
        onadd: () => navigateToProductDetails(context, product),
        img: _getProductImage(product),
        price: product['Product Price']?.toString() ?? '0',
        title: product['Product Title'] ?? '',
        subtitle: product['Product Subtitle'] ?? '',
      ),
    );
  }

  Widget _buildLoadingItem() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenthemecolor),
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            searchController.text.isNotEmpty
                ? 'No products found for "${searchController.text}"'
                : 'No products available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            searchController.text.isNotEmpty
                ? 'Try searching with different keywords'
                : 'Check back later for new products',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          if (searchController.text.isNotEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                searchController.clear();
                _resetProducts();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenthemecolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Clear Search',
                style: TextStyle(color: Colors.white),
              ),
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
      child: GridView.builder(
        padding: EdgeInsets.all(isWeb ? 24 : 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: isWeb ? 0.8 : 0.75,
          crossAxisSpacing: isWeb ? 20 : 12,
          mainAxisSpacing: isWeb ? 24 : 16,
        ),
        itemCount: _itemsPerPage,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }

  String _getProductImage(Map<String, dynamic> product) {
    if (product['Product Img'] != null && product['Product Img'].isNotEmpty) {
      return product['Product Img'][0];
    }
    return AppImage.defaultimgurl;
  }

  void navigateToProductDetails(
      BuildContext context, Map<String, dynamic> product) {
    HapticFeedback.lightImpact();
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

  Timer? _debounceTimer;
  void _debounceSearch(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _filterProducts(query);
    });
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(allProducts);
      } else {
        filteredProducts = allProducts
            .where((product) =>
                (product['Product Title'] ?? '')
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (product['Product Subtitle'] ?? '')
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
      _sortProducts();
      displayedProducts = filteredProducts.take(_itemsPerPage).toList();
      _currentPage = 1;
      _hasMoreItems = filteredProducts.length > _itemsPerPage;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _resetProducts() {
    setState(() {
      filteredProducts = List.from(allProducts);
      _sortProducts();
      displayedProducts = filteredProducts.take(_itemsPerPage).toList();
      _currentPage = 1;
      _hasMoreItems = filteredProducts.length > _itemsPerPage;
    });
  }

  void _applySortAndRefreshDisplay() {
    setState(() {
      _sortProducts();
      // Reset pagination and update displayed products
      displayedProducts = filteredProducts.take(_itemsPerPage).toList();
      _currentPage = 1;
      _hasMoreItems = filteredProducts.length > _itemsPerPage;
    });
    // Restart animation
    _animationController.reset();
    _animationController.forward();
  }

  void _sortProducts() {
    switch (_currentSortBy) {
      case 'price_low_high':
        filteredProducts.sort((a, b) =>
            (double.tryParse(a['Product Price']?.toString() ?? '0') ?? 0)
                .compareTo(
                    double.tryParse(b['Product Price']?.toString() ?? '0') ??
                        0));
        break;
      case 'price_high_low':
        filteredProducts.sort((a, b) =>
            (double.tryParse(b['Product Price']?.toString() ?? '0') ?? 0)
                .compareTo(
                    double.tryParse(a['Product Price']?.toString() ?? '0') ??
                        0));
        break;
      case 'name_a_z':
        filteredProducts.sort((a, b) => (a['Product Title'] ?? '')
            .toLowerCase()
            .compareTo((b['Product Title'] ?? '').toLowerCase()));
        break;
      case 'name_z_a':
        filteredProducts.sort((a, b) => (b['Product Title'] ?? '')
            .toLowerCase()
            .compareTo((a['Product Title'] ?? '').toLowerCase()));
        break;
      default:
        // Keep original order
        break;
    }
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _isInitialLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    fetchProducts();
  }

  void fetchProducts() {
    databaseRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> products = [];

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
            };

            if (widget.categoryname == 'All Products' ||
                (value.containsKey('Category') &&
                    value['Category'] == widget.categoryname)) {
              products.add(product);
            }
          }
        });

        if (mounted) {
          setState(() {
            allProducts = products;
            filteredProducts = List.from(allProducts);
            _sortProducts();
            displayedProducts = filteredProducts.take(_itemsPerPage).toList();
            _currentPage = 1;
            _hasMoreItems = filteredProducts.length > _itemsPerPage;
            _isInitialLoading = false;
          });
          _animationController.forward();
        }
      }
    });
  }
}
