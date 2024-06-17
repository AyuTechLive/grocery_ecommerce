import 'package:flutter/material.dart';
import 'package:hakikat_app_new/Utils/colors.dart';

class MyOrderTile extends StatelessWidget {
  final String orderid;
  final String date;
  final String img;
  final String price;
  final String quantity;
  final bool processing;
  final String title;
  const MyOrderTile(
      {super.key,
      required this.orderid,
      required this.date,
      required this.img,
      required this.price,
      required this.quantity,
      required this.processing,
      required this.title});

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
                Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    '  Processing  ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
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
                  onPressed: () {},
                  icon: Container(
                      width: width * 0.4,
                      height: height * 0.064,
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
                IconButton(onPressed: () {}, icon: Text('Help')),
                SizedBox(
                  width: width * 0.1,
                )
              ],
            )
          ],
        ));
  }
}
