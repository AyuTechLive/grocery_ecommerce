import 'package:flutter/material.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/Album/albumscreen.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/Farmerbanner.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/Tutorials/farmerpdftutorials.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/Tutorials/farmervideotutorials.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/addfarmerbanner.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/addfarmerevent.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/addfarmerpdf.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/addgalleryimg.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/farmer_application_List.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/sanstha_application_list.dart';
import 'package:hakikat_app_new/AdminSide/FarmerAdmin/Farmerevent/eventpage.dart';
import 'package:hakikat_app_new/Utils/widget.dart';

class FarmerAdminPanel extends StatelessWidget {
  const FarmerAdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.agriculture_outlined,
            color: Colors.white,
            size: isWeb ? 28 : 24,
          ),
          SizedBox(width: 8),
          Text(
            'Farmer Admin Panel',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isWeb ? 22 : 18,
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.green.shade700,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade600,
              Colors.green.shade800,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isWeb = screenSize.width > 600;
    final isTablet = screenSize.width > 800;
    final isDesktop = screenSize.width > 1200;

    // Determine grid parameters based on screen size
    int crossAxisCount;
    double maxWidth;
    EdgeInsets padding;

    if (isDesktop) {
      crossAxisCount = 6;
      maxWidth = 1400;
      padding = EdgeInsets.symmetric(horizontal: 40, vertical: 24);
    } else if (isTablet) {
      crossAxisCount = 4;
      maxWidth = 1000;
      padding = EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    } else if (isWeb) {
      crossAxisCount = 3;
      maxWidth = 800;
      padding = EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    } else {
      crossAxisCount = 2;
      maxWidth = double.infinity;
      padding = EdgeInsets.all(16);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.shade50,
            Colors.grey.shade50,
            Colors.white,
          ],
          stops: [0.0, 0.3, 1.0],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: padding,
            child: CustomScrollView(
              slivers: [
                if (isWeb) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: Text(
                        'Farmer Management Dashboard',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: isWeb ? 20 : 16,
                    crossAxisSpacing: isWeb ? 20 : 16,
                    childAspectRatio: isWeb ? 1.1 : 1.0,
                  ),
                  delegate: SliverChildListDelegate([
                    _buildAdminCard(
                      context,
                      'Farmer Tutorials',
                      Icons.video_collection_outlined,
                      Colors.red.shade600,
                      VideosListScreen(),
                      'Video learning content',
                    ),
                    _buildAdminCard(
                      context,
                      'Farmer PDFs',
                      Icons.picture_as_pdf_outlined,
                      Colors.blue.shade600,
                      PdfListScreen(),
                      'Document resources',
                    ),
                    _buildAdminCard(
                      context,
                      'Farmer Applications',
                      Icons.assignment_outlined,
                      Colors.orange.shade600,
                      FarmerApplicationsList(),
                      'Registration requests',
                    ),
                    _buildAdminCard(
                      context,
                      'Sanstha Applications',
                      Icons.assignment_turned_in_outlined,
                      Colors.purple.shade600,
                      SansthaApplicationList(),
                      'Organization requests',
                    ),
                    _buildAdminCard(
                      context,
                      'Farmer Events',
                      Icons.event_outlined,
                      Colors.indigo.shade600,
                      FarmerEventPage(),
                      'Manage events',
                    ),
                    _buildAdminCard(
                      context,
                      'Gallery Management',
                      Icons.photo_library_outlined,
                      Colors.teal.shade600,
                      AddGalleryImages(),
                      'Upload images',
                    ),
                    _buildAdminCard(
                      context,
                      'Farmer Banners',
                      Icons.branding_watermark,
                      Colors.green.shade600,
                      FarmerBanner(),
                      'Promotional content',
                    ),
                    _buildAdminCard(
                      context,
                      'Photo Albums',
                      Icons.collections_outlined,
                      Colors.amber.shade600,
                      GalleryAlbum(),
                      'Image collections',
                    ),
                  ]),
                ),
                // Add some bottom padding
                SliverToBoxAdapter(
                  child: SizedBox(height: isWeb ? 40 : 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget destination,
    String subtitle,
  ) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Card(
      elevation: isWeb ? 6 : 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isWeb ? 16 : 12),
      ),
      child: InkWell(
        onTap: () => nextScreen(context, destination),
        borderRadius: BorderRadius.circular(isWeb ? 16 : 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isWeb ? 16 : 12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                color.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(isWeb ? 20 : 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(isWeb ? 16 : 12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: isWeb ? 32 : 28,
                    color: color,
                  ),
                ),
                SizedBox(height: isWeb ? 16 : 12),
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isWeb ? 12 : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isWeb && subtitle.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
