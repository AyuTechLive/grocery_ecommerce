import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hakikat_app_new/Account/addressscreen.dart';

class SelectAddressCard extends StatelessWidget {
  final String no;
  final String name;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String pincode;
  final RadioModel radioModel;
  final String addressString;
  final bool isSelected;
  final VoidCallback onDeleteAddress;
  final VoidCallback onEditAddress;
  final VoidCallback onSelectAddress;

  const SelectAddressCard({
    super.key,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.pincode,
    required this.name,
    required this.no,
    required this.onDeleteAddress,
    required this.onEditAddress,
    required this.radioModel,
    required this.addressString,
    required this.isSelected,
    required this.onSelectAddress,
  });

  @override
  Widget build(BuildContext context) {
    final Size screensize = MediaQuery.of(context).size;
    final double height = screensize.height;
    final double width = screensize.width;
    return GestureDetector(
      onTap: () {
        radioModel.setSelectedValue(addressString);
        onSelectAddress();
      },
      child: Container(
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
                  width: width * 0.025,
                ),
                Radio<String>(
                  value: addressString,
                  groupValue: radioModel.selectedValue,
                  onChanged: (value) {
                    radioModel.setSelectedValue(value);
                    onSelectAddress();
                  },
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
                        onPressed: onEditAddress, icon: Icon(Icons.edit)),
                    // IconButton(
                    //     onPressed: onDeleteAddress, icon: Icon(Icons.delete)),
                  ],
                ),
                SizedBox(
                  width: width * 0.02,
                ),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
