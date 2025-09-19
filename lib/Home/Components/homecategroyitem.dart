import 'package:flutter/material.dart';

class HomeCategoryItems extends StatelessWidget {
  final String img;
  final String title;
  final VoidCallback ontap;

  const HomeCategoryItems(
      {super.key, required this.img, required this.title, required this.ontap});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final bool isWeb = width > 600;

    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: isWeb ? 280 : width * 0.45,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8A44C).withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF8A44C).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image Container
            Container(
              width: isWeb ? 60 : width * 0.15,
              height: isWeb ? 60 : width * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  img,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFFF8A44C),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey[400],
                        size: isWeb ? 24 : 20,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Title Text
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF3E423F),
                  fontSize: isWeb ? 16 : 14,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.arrow_forward_ios,
              size: isWeb ? 16 : 14,
              color: const Color(0xFFF8A44C),
            ),
          ],
        ),
      ),
    );
  }
}
