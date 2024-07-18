import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Home/Components/items.dart';
import 'package:hakikat_app_new/ProductDetails/productdetails.dart';
import 'package:hakikat_app_new/Utils/appimg.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

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

  int _currentPage = 1;
  int _itemsPerPage = 10;
  bool _isLoading = false;
  bool _hasMoreItems = true;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
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

    await Future.delayed(Duration(seconds: 2)); // Simulating network delay

    int startIndex = _currentPage * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;
    if (endIndex > filteredProducts.length) {
      endIndex = filteredProducts.length;
    }

    List<Map<String, dynamic>> newItems =
        filteredProducts.sublist(startIndex, endIndex);

    setState(() {
      products.addAll(newItems);
      _currentPage++;
      _isLoading = false;
      if (endIndex >= filteredProducts.length) {
        _hasMoreItems = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryname ?? 'All Products'),
      ),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: width * 0.879,
              height: height * 0.057,
              decoration: ShapeDecoration(
                color: Color(0xFFF1F2F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Center(
                child: TextFormField(
                  textAlign: TextAlign.justify,
                  controller: searchController,
                  cursorColor: Color(0xFF4C4E4D),
                  decoration: InputDecoration(
                    icon: Padding(
                      padding: EdgeInsets.only(left: width * 0.03),
                      child: Icon(Icons.search),
                    ),
                    hintText: 'Search Store',
                    iconColor: Color(0xFF4C4E4D),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    filterProducts(value);
                  },
                ),
              ),
            ),
          ]),
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.all(width * 0.06),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.75,
                crossAxisSpacing: width * 0.03,
                mainAxisSpacing: height * 0.01,
                crossAxisCount: 2,
              ),
              itemCount: products.length + (_hasMoreItems ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < products.length) {
                  Map<String, dynamic> product = products[index];
                  return Items(
                    ontap: () => navigateToProductDetails(context, product),
                    onadd: () => navigateToProductDetails(context, product),
                    img: (product['Product Img'] != null &&
                            product['Product Img'].isNotEmpty)
                        ? product['Product Img'][0]
                        : AppImage.defaultimgurl,
                    price: product['Product Price'],
                    title: product['Product Title'] ?? '',
                    subtitle: product['Product Subtitle'] ?? '',
                  );
                } else if (_hasMoreItems) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void navigateToProductDetails(
      BuildContext context, Map<String, dynamic> product) {
    nextScreen(
      context,
      ProductDetails(
        discription: product['Product Discription'] ?? '',
        imageUrls: List<String>.from(
            product['Product Img'] ?? [AppImage.defaultimgurl]),
        orderid: product['id'],
        img: (product['Product Img'] != null &&
                product['Product Img'].isNotEmpty)
            ? product['Product Img'][0]
            : AppImage.defaultimgurl,
        maxquantity: product['Product Stock'] != null
            ? int.tryParse(product['Product Stock'].toString()) ?? 0
            : 0,
        price: product['Product Price'],
        title: product['Product Title'] ?? '',
        subtitle: product['Product Subtitle'] ?? '',
      ),
    );
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) => (product['Product Title'] ?? '')
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      _currentPage = 1;
      _hasMoreItems = true;
      products = filteredProducts.take(_itemsPerPage).toList();
    });
  }

  void fetchProducts() {
    databaseRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        List<Map<String, dynamic>> allProducts = [];

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
              allProducts.add(product);
            }
          }
        });

        if (mounted) {
          setState(() {
            filteredProducts = allProducts;
            products = filteredProducts.take(_itemsPerPage).toList();
            _currentPage = 1;
            _hasMoreItems = filteredProducts.length > _itemsPerPage;
          });
        }
      }
    });
  }
}
