// import 'package:flutter/material.dart';

// class AboutUsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('About Us'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Welcome to Hakeeqat App!',
//               style: Theme.of(context).textTheme.headline5,
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'HAKEEQAT was founded in July 2016 and the first store opened in November 2016. Late Shri Om Prakash Manjhu and ,Shri Bhagwan singh,Shri Praveen  Godara ,Shri Prem sukh mahiya,Dr. Aakash Goyal are the minds behind this idea.  Presently there are 350 dedicated farmers and more than 1200 satisfied consumer families.  Over 100 products are available in the store, produced and processed by farmers and HAKEEQAT.',
//               style: Theme.of(context).textTheme.bodyText2,
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Our Story',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               'The idea behind the formation of HAKEEQAT is to provide a trusted platform to producers and consumers to make natural products available at affordable prices.HAKEEQAT conducts seminars and conducts free training programs to make people aware about natural farming.',
//               style: Theme.of(context).textTheme.bodyText2,
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Our Values',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             SizedBox(height: 8.0),
//             _buildValueItem(
//                 context, 'Quality', 'We source only the best products.'),
//             _buildValueItem(context, 'Convenience', 'Order anytime, anywhere.'),
//             _buildValueItem(context, 'Customer Satisfaction',
//                 'Your happiness is our priority.'),
//             SizedBox(height: 16.0),
//             Text(
//               'Contact Us',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               'Phone: 9672-261265',
//               style: Theme.of(context).textTheme.bodyText2,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildValueItem(
//       BuildContext context, String title, String description) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
//           SizedBox(width: 8.0),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: Theme.of(context).textTheme.subtitle1),
//                 Text(description, style: Theme.of(context).textTheme.bodyText2),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
