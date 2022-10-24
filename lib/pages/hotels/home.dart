import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/text_widget.dart';

class HotelsHome extends StatefulWidget {
  const HotelsHome({Key? key}) : super(key: key);

  @override
  State<HotelsHome> createState() => _HotelsHomeState();
}

class _HotelsHomeState extends State<HotelsHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: TextField(
                  autocorrect: false,
                  enableSuggestions: false,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  cursorColor: Colors.black87,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    filled: true,
                    fillColor: Colors.grey[200],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0),
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.black54),
                    hintText: "Search for hotels",
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.sort, color: Colors.black),
                    label: AppText(
                      text: "Most relevant",
                      size: 12,
                      weight: FontWeight.w500,
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.filter_alt_rounded, color: Colors.black),
                    label: AppText(
                      text: "Filter",
                      size: 12,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Flexible(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: hotelCount + 1,
                    itemBuilder: (context, index) {
                      if (index == hotelCount) {
                        return const SizedBox(height: 0);
                      } else
                        return _buildIToteltem(index);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 20);
                    },
                  ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}

int hotelCount = 3;

Widget _buildIToteltem(int index) {
  return Center(
    child: Container(
      constraints: BoxConstraints(maxWidth: 350),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(220, 218, 218, 1),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xffDDDDDD),
            blurRadius: 6.0,
            spreadRadius: 2.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16)),
            child: Image.asset(
              height: 180,
              width: double.infinity,
              fit: BoxFit.fitWidth,
              "assets/images/hotel_template.jpg",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Grand Royal Hotel",
                      size: 16,
                      weight: FontWeight.w700,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        AppText(
                            text: "Wembley, London",
                            size: 12,
                            color: Colors.grey),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: primaryColor,
                        ),
                        AppText(
                            text: "2 km to city", size: 12, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        for (int i = 0; i < 4; i++)
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: primaryColor,
                          ),
                        for (int i = 0; i < 1; i++)
                          Icon(
                            Icons.star_border_rounded,
                            size: 16,
                            color: primaryColor,
                          ),
                        const SizedBox(width: 4),
                        AppText(text: "70 Reviews", size: 12, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    AppText(
                      text: "190\$",
                      size: 16,
                      weight: FontWeight.w700,
                    ),
                    const SizedBox(height: 4),
                    AppText(text: "/per night", size: 12, color: Colors.black),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
