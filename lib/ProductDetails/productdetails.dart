import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hakikat_app_new/Utils/checkuserauthentication.dart';
import 'package:hakikat_app_new/Utils/colors.dart';
import 'package:hakikat_app_new/Utils/responsive_helper.dart';
import 'package:hakikat_app_new/Utils/utils.dart';

class ProductDetails extends StatefulWidget {
  final String title;
  final String subtitle;
  final String price;
  final String img;
  final String orderid;
  final int maxquantity;
  final String discription;
  final List<String> imageUrls;

  const ProductDetails({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.maxquantity,
    required this.img,
    required this.orderid,
    required this.imageUrls,
    required this.discription,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with TickerProviderStateMixin {
  int quantity = 1;
  int totalprice = 0;
  bool isInFavorites = false;
  bool isLoading = false;
  bool isInCart = false;
  int _currentIndex = 0;
  bool _isExpanded = true;

  late AnimationController _animationController;
  late AnimationController _buttonAnimationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    checkIfInFavorites();
    totalprice = int.parse(widget.price);
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
          parent: _buttonAnimationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  bool get isWeb => kIsWeb || MediaQuery.of(context).size.width > 600;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: ResponsiveWidget(
        mobile: _buildMobileLayout(screenSize.height, screenSize.width),
        tablet: _buildTabletLayout(screenSize.height, screenSize.width),
        desktop: _buildDesktopLayout(screenSize.height, screenSize.width),
      ),
      bottomNavigationBar: isWeb ? null : _buildBottomBar(),
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
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF4C4E4D),
            size: 18,
          ),
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          if (isWeb) {
            context.pop();
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            // Add share functionality
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share_outlined,
              color: Color(0xFF4C4E4D),
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildMobileLayout(double height, double width) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildImageCarousel(height, width),
          _buildProductInfoCard(height, width),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(double height, double width) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildImageCarousel(height, width),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 1,
                  child: _buildProductInfoCard(height, width, isTablet: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(double height, double width) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildImageCarousel(height, width),
              ),
              const SizedBox(width: 48),
              Expanded(
                flex: 2,
                child: _buildProductInfoCard(height, width, isDesktop: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel(double height, double width) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(_slideAnimation),
      child: Container(
        width: width,
        height: isWeb ? 500 : height * 0.45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              CarouselSlider(
                items: widget.imageUrls.map((imageUrl) {
                  return Container(
                    width: width,
                    margin: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.greenthemecolor,
                              ),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Image not available',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: isWeb ? 450 : height * 0.35,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  autoPlay: widget.imageUrls.length > 1,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.easeInOutCubic,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
              if (widget.imageUrls.length > 1) _buildImageIndicators(),
              _buildStockBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageIndicators() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.imageUrls.asMap().entries.map((entry) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _currentIndex == entry.key ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: _currentIndex == entry.key
                  ? AppColors.greenthemecolor
                  : Colors.white.withOpacity(0.5),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStockBadge() {
    return Positioned(
      top: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: widget.maxquantity > 0
              ? AppColors.greenthemecolor.withOpacity(0.9)
              : Colors.red.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          widget.maxquantity > 0 ? 'In Stock' : 'Out of Stock',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfoCard(double height, double width,
      {bool isTablet = false, bool isDesktop = false}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isWeb ? 0 : 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductHeader(),
            const SizedBox(height: 20),
            _buildPriceSection(),
            const SizedBox(height: 24),
            _buildQuantitySelector(height, width),
            const SizedBox(height: 24),
            _buildProductDetails(),
            if (isTablet || isDesktop) ...[
              const SizedBox(height: 32),
              _buildAddToCartButton(height, width),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: const Color(0xFF181725),
                  fontSize: isWeb ? 28 : 22,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.subtitle,
                style: TextStyle(
                  color: const Color(0xFF7C7C7C),
                  fontSize: isWeb ? 18 : 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildFavoriteButton(),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTapDown: (_) => _buttonAnimationController.forward(),
      onTapUp: (_) => _buttonAnimationController.reverse(),
      onTapCancel: () => _buttonAnimationController.reverse(),
      onTap: () {
        HapticFeedback.lightImpact();
        toggleFavorite(widget.orderid);
      },
      child: ScaleTransition(
        scale: _buttonScaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                isInFavorites ? Colors.red.withOpacity(0.1) : Colors.grey[100],
            shape: BoxShape.circle,
            border: Border.all(
              color: isInFavorites ? Colors.red : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Icon(
            isInFavorites ? Icons.favorite : Icons.favorite_border,
            color: isInFavorites ? Colors.red : Colors.grey[600],
            size: isWeb ? 24 : 20,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.greenthemecolor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.greenthemecolor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Price',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${totalprice}',
                style: TextStyle(
                  color: AppColors.greenthemecolor,
                  fontSize: isWeb ? 28 : 24,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (quantity > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.greenthemecolor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '₹${widget.price} × $quantity',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(double height, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity',
          style: TextStyle(
            color: const Color(0xFF181725),
            fontSize: isWeb ? 18 : 16,
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildQuantityButton(
              icon: Icons.remove,
              onPressed: quantitydecrement,
              enabled: quantity > 1,
            ),
            const SizedBox(width: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                quantity.toString(),
                style: TextStyle(
                  color: const Color(0xFF181725),
                  fontSize: isWeb ? 20 : 18,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 20),
            _buildQuantityButton(
              icon: Icons.add,
              onPressed: quantityincrement,
              enabled: quantity < widget.maxquantity,
            ),
            const Spacer(),
            if (widget.maxquantity > 0)
              Text(
                '${widget.maxquantity} available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        width: isWeb ? 44 : 40,
        height: isWeb ? 44 : 40,
        decoration: BoxDecoration(
          color: enabled
              ? (icon == Icons.add ? AppColors.greenthemecolor : Colors.white)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled
                ? (icon == Icons.add
                    ? AppColors.greenthemecolor
                    : Colors.grey[300]!)
                : Colors.grey[200]!,
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: enabled
              ? (icon == Icons.add ? Colors.white : Colors.grey[700])
              : Colors.grey[400],
          size: 18,
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Product Details',
                style: TextStyle(
                  color: const Color(0xFF181725),
                  fontSize: isWeb ? 18 : 16,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.expand_more,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                widget.discription.isNotEmpty
                    ? widget.discription
                    : 'No product description available.',
                style: TextStyle(
                  color: const Color(0xFF7C7C7C),
                  fontSize: isWeb ? 16 : 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: _buildAddToCartButton(0, 0),
      ),
    );
  }

  Widget _buildAddToCartButton(double height, double width) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:
            widget.maxquantity > 0 ? (isInCart ? _gotoCart : _addToCart) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.maxquantity > 0
              ? AppColors.greenthemecolor
              : Colors.grey[300],
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.maxquantity > 0
                        ? (isInCart
                            ? Icons.shopping_cart
                            : Icons.add_shopping_cart)
                        : Icons.remove_shopping_cart,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.maxquantity > 0
                        ? (isInCart ? 'Go To Cart' : 'Add To Cart')
                        : 'Out Of Stock',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void quantityincrement() {
    if (quantity < widget.maxquantity) {
      HapticFeedback.selectionClick();
      setState(() {
        quantity++;
        totalprice = int.parse(widget.price) * quantity;
      });
    }
  }

  void quantitydecrement() {
    if (quantity > 1) {
      HapticFeedback.selectionClick();
      setState(() {
        quantity--;
        totalprice = int.parse(widget.price) * quantity;
      });
    }
  }

  Future<void> _addToCart() async {
    if (quantity < 1) {
      Utils().toastMessage('You must add at least one quantity');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String userEmailsDocumentId = checkUserAuthenticationType();
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmailsDocumentId);

      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      if (userDocSnapshot.exists) {
        DocumentReference cartDocRef =
            userDocRef.collection('Cart').doc(widget.orderid);

        await cartDocRef.set({
          'id': widget.orderid,
          'quantity': quantity,
        }, SetOptions(merge: true));

        setState(() {
          isLoading = false;
          isInCart = true;
        });

        HapticFeedback.mediumImpact();
        Utils().toastMessage('Item added to cart');
      } else {
        throw Exception('User document not found');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding item to cart: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> toggleFavorite(String productid) async {
    try {
      String userEmailsDocumentId = checkUserAuthenticationType();
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmailsDocumentId);

      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      if (userDocSnapshot.exists) {
        if (isInFavorites) {
          await userDocRef.update({
            'Favorites': FieldValue.arrayRemove([productid])
          });
          setState(() {
            isInFavorites = false;
          });
          Utils().toastMessage('Item removed from Favorites');
        } else {
          await userDocRef.update({
            'Favorites': FieldValue.arrayUnion([productid])
          });
          setState(() {
            isInFavorites = true;
          });
          Utils().toastMessage('Item added to Favorites');
        }
      }
      await checkIfInFavorites();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating favorites: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> checkIfInFavorites() async {
    try {
      String userEmailsDocumentId = checkUserAuthenticationType();
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userEmailsDocumentId);

      DocumentSnapshot userDocSnapshot = await userDocRef.get();
      if (userDocSnapshot.exists) {
        List<dynamic> favorites = userDocSnapshot.get('Favorites') ?? [];
        setState(() {
          isInFavorites = favorites.contains(widget.orderid);
        });
      }
    } catch (error) {
      debugPrint('Error checking favorites: $error');
    }
  }

  void _gotoCart() {
    HapticFeedback.lightImpact();
    if (kIsWeb) {
      context.go('/cart');
    } else {
      context.push('/cart');
    }
  }
}
