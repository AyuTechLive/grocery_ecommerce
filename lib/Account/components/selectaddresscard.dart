import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SelectAddressCard extends StatelessWidget {
  final String name;
  final String no;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String pincode;
  final bool selectedAddress;
  final Function(bool) onAddressSelected;
  final Function() onDeleteAddress;
  const SelectAddressCard(
      {super.key,
      required this.addressLine1,
      required this.addressLine2,
      required this.city,
      required this.pincode,
      required this.selectedAddress,
      required this.onAddressSelected,
      required this.name,
      required this.no,
      required this.onDeleteAddress});

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return Container(
      width: width * 0.9,
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10)),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(no),
                    ],
                  ),
                  SizedBox(
                    width: width * 0.5,
                    child: Text(addressLine1 +
                        " , " +
                        addressLine2 +
                        " , " +
                        city +
                        " , " +
                        pincode),
                  )
                ],
              ),
              Spacer(),
              Column(
                children: [
                  IconButton(
                      onPressed: onDeleteAddress, icon: Icon(Icons.delete)),
                  Radio<bool>(
                    value: !selectedAddress,
                    groupValue: false,
                    onChanged: (value) {
                      onAddressSelected(!selectedAddress);
                    },
                  ),
                ],
              ),
              SizedBox(
                width: width * 0.02,
              )
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
        ],
      ),
    );
  }
}
