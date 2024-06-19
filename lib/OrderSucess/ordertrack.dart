import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderTrack extends StatefulWidget {
  final String status;
  final String orderid;
  final String date;
  final String estimated;
  const OrderTrack(
      {super.key,
      required this.status,
      required this.orderid,
      required this.date,
      required this.estimated});

  @override
  State<OrderTrack> createState() => _OrderTrackState();
}

class _OrderTrackState extends State<OrderTrack> {
  final List<String> statusList = [
    'Order Placed',
    'Order Confirmed',
    'Delivered',
  ];

  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = statusList.indexOf(widget.status);
  }

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Progress'),
      ),
      body: widget.status == 'Cancelled'
          ? Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Container(
                      width: width * 0.2,
                      height: height * 0.09,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Icon(Icons.shopping_cart),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Order Number',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(widget.orderid),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(widget.date),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: width * 0.8,
                      child: Text(
                        'Estimated Delivery : Order Cancelled',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.04,
                    ),
                    Text('Order Status'),
                    Spacer(),
                    Text(
                      '100%',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.04,
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.04, right: width * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 1.0,
                          backgroundColor: Colors.grey.shade300,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.04),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 16,
                        child: Text(
                          '1',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Order Placed',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.04),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 16,
                        child: Text(
                          '2',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Order Cancelled',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                //estimateddelivery(),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Container(
                      width: width * 0.2,
                      height: height * 0.09,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Icon(Icons.shopping_cart),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Order Number',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(widget.orderid),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(widget.date),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                estimateddelivery(),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width * 0.04,
                    ),
                    Text('Order Status'),
                    Spacer(),
                    Text(
                      '${((currentIndex + 1) / statusList.length * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.04,
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.04, right: width * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: (currentIndex + 1) / statusList.length,
                          backgroundColor: Colors.grey.shade300,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 2,
                        height: double.infinity,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 32);
                          },
                          itemCount: statusList.length,
                          itemBuilder: (context, index) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: index <= currentIndex
                                      ? Colors.green
                                      : Colors.grey,
                                  radius: 16,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    statusList[index],
                                    style: TextStyle(
                                      color: index <= currentIndex
                                          ? Colors.green
                                          : Colors.grey.shade600,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
    );
  }

  Widget estimateddelivery() {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    if (widget.estimated == '') {
      return SizedBox();
    } else {
      return Row(
        children: [
          SizedBox(
            width: 20,
          ),
          SizedBox(
            width: width * 0.8,
            child: Text(
              'Estimated Delivery : ${widget.estimated}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          )
        ],
      );
    }
  }
}
