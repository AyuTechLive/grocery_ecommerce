import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class MyOrderTile extends StatelessWidget {
  final String orderid;
  final String date;
  final String img;
  final String price;
  final String quantity;
  final String processing;
  final String title;
  final VoidCallback ontaptrack;
  final VoidCallback ontap;
  const MyOrderTile(
      {super.key,
      required this.orderid,
      required this.date,
      required this.img,
      required this.price,
      required this.quantity,
      required this.processing,
      required this.title,
      required this.ontap,
      required this.ontaptrack});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Container(
        width: width * 0.95,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.01),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.withOpacity(0.2))),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              children: [
                SizedBox(
                  width: width * 0.02,
                ),
                container(processing)
                // Container(
                //   decoration: BoxDecoration(
                //       color: Colors.amber,
                //       borderRadius: BorderRadius.circular(5)),
                //   child: Text(
                //     '  ${processing}  ',
                //     style: TextStyle(
                //         fontWeight: FontWeight.w600, color: Colors.white),
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Row(
              children: [
                SizedBox(
                  width: width * 0.02,
                ),
                Text('Order Id:${orderid}',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Spacer(),
                Text('₹ ${price}',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(
                  width: width * 0.02,
                ),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Row(
              children: [
                SizedBox(
                  width: width * 0.02,
                ),
                Text(date),
                Spacer(),
                Text('${quantity} Items'),
                SizedBox(
                  width: width * 0.02,
                ),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Divider(),
            SizedBox(
              height: height * 0.01,
            ),
            Row(
              children: [
                SizedBox(
                  width: width * 0.02,
                ),
                SizedBox(
                  width: width * 0.2,
                  height: height * 0.08,
                  child: Image.network(
                    img,
                    fit: BoxFit.fill,
                  ),
                ),
                Text('${title} '),
                Text('+ ${int.parse(quantity) - 1} items')
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: ontap,
                  icon: Container(
                      width: width * 0.4,
                      height: height * 0.060,
                      decoration: ShapeDecoration(
                        color: AppColors.greenthemecolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            color: Color(0xFFFCFCFC),
                            fontSize: 16,
                            fontFamily: 'Gilroy',
                            fontWeight: FontWeight.w600,
                            height: 0.06,
                          ),
                        ),
                      )),
                ),
                Spacer(),
                IconButton(onPressed: ontaptrack, icon: Text('Track Order')),
                SizedBox(
                  width: width * 0.1,
                )
              ],
            )
          ],
        ));
  }

  Widget container(String processing) {
    if (processing == 'Order Placed') {
      return Container(
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(5)),
        child: Text(
          '  Order Placed  ',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
    }
    if (processing == 'Order Confirmed') {
      return Container(
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(5)),
        child: Text(
          '  Order Confirmed  ',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
    }
    if (processing == 'Delivered') {
      return Container(
        decoration: BoxDecoration(
            color: AppColors.greenthemecolor,
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          ' Delivered  ',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(5)),
        child: Text(
          '  Cancelled  ',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
    }
  }
}
