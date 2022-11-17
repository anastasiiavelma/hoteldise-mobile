import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:hoteldise/models/hotel.dart';
import 'package:hoteldise/pages/hotels/home/search/address_search.dart';
import 'package:hoteldise/pages/hotels/home/sort.dart';

import '../../../themes/constants.dart';
import '../../../widgets/text_widget.dart';

import 'package:intl/intl.dart';

import 'calendarPopUp.dart';
import 'roomsAdultsPopUp.dart';
import 'filter.dart';

class HotelsHome extends StatefulWidget {
  const HotelsHome({Key? key}) : super(key: key);

  @override
  State<HotelsHome> createState() => _HotelsHomeState();
}

List<SortOption> sortOptions = [
  SortByMark(),
  SortByPriceIncrease(),
  SortByPriceDecrease()
];

class _HotelsHomeState extends State<HotelsHome> {
  List<Hotel> matchedHotels = <Hotel>[];
  SortOption currentSortOption = sortOptions[0];
  String searchValue = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  int numberOfRooms = 1;
  int numberOfAdults = 2;

  String getRoomsAdultsString() {
    String text = "";
    text += "$numberOfRooms ${numberOfRooms == 1 ? "Room - " : "Rooms - "}";
    text += "$numberOfAdults ${numberOfAdults == 1 ? "Adult" : "Adults"}";
    return text;
  }

  @override
  void initState() {
    getHotels();
    super.initState();
  }

  getHotels() async {
    List<Hotel> newHotels = <Hotel>[];
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("hotels")
        .withConverter(
            fromFirestore: Hotel.fromFirestore,
            toFirestore: (Hotel hotel, _) => hotel.toFirestore())
        .get()
        .then((event) async {
      for (var doc in event.docs) {
        newHotels.add(doc.data());
      }

      for (int i = 0; i < newHotels.length; i++) {
        await newHotels[i].setExtraFields();
      }
      //search filter
      newHotels = newHotels
          .where((element) => element.address.address
              .toLowerCase()
              .contains(searchValue.toLowerCase()))
          .toList();
      setState(() {
        matchedHotels = newHotels;
        currentSortOption.doSort(matchedHotels);
      });
    });
  }

  List<Material> getSortListItems() {
    List<Material> list = [];
    for (int i = 0; i < sortOptions.length; i++) {
      String label = sortOptions[i].name;
      var newItem = Material(
        color: elevatedGrey,
        child: InkWell(
          child: ListTile(
            title: AppText(
                text: label,
                color:
                    label == currentSortOption.name ? primaryColor : textBase),
            onTap: () {
              setState(() {
                currentSortOption = sortOptions[i];
              });
              sortOptions[i].doSort(matchedHotels);
              Navigator.pop(context);
            },
            contentPadding: EdgeInsets.zero,
          ),
        ),
      );
      list.add(newItem);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  // var token = await FirebaseAuth.instance.currentUser?.getIdToken();
                  final String? result = await showSearch(
                    context: context,
                    query: searchValue,
                    delegate: AddressSearch(searchValue),
                  );
                  if (result != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        searchValue = result;
                        getHotels();
                      });
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: veryLightGreyColor,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(children: [
                          const Icon(Icons.search, color: greyColor),
                          const SizedBox(width: 10),
                          AppText(
                              text: searchValue == ''
                                  ? 'Choose location'
                                  : searchValue,
                              size: 14,
                              color: greyColor,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ]),
                      ),
                      if (searchValue != '')
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                searchValue = '';
                                getHotels();
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: greyColor,
                            ))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              getTimeDateUI(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      showModalBottomSheet<dynamic>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext buildContext) {
                            return Wrap(children: <Widget>[
                              Container(
                                color: backgroundColor,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: elevatedGrey,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 30, top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: AppText(
                                            text: 'Sort by',
                                            weight: FontWeight.w900,
                                            size: 20,
                                            color: textBase,
                                          ),
                                        ),
                                        Column(children: getSortListItems()),
                                        Center(
                                          child: ListTile(
                                            title: Center(
                                                child: AppText(
                                              text: 'CANCEL',
                                              weight: FontWeight.w700,
                                              color: lightGreyColor,
                                            )),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]);
                          });
                    },
                    icon: const Icon(Icons.sort, color: textBase),
                    label: AppText(
                      text: currentSortOption.name,
                      size: 12,
                      weight: FontWeight.w500,
                      color: textBase,
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
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => FiltersScreen(),
                            fullscreenDialog: true),
                      );
                    },
                    icon: const Icon(
                      Icons.filter_alt_rounded,
                      color: textBase,
                    ),
                    label: AppText(
                      text: "Filter",
                      size: 12,
                      weight: FontWeight.w500,
                      color: textBase,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: matchedHotels.length + 1,
                  itemBuilder: (context, index) {
                    if (index == matchedHotels.length) {
                      return const SizedBox(height: 0);
                    } else {
                      return getHotelCard(matchedHotels[index]);
                    }
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
    );
  }

  Widget getHotelCard(Hotel hotel) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: elevatedGrey,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: elevatedGrey,
              blurRadius: 8.0,
              spreadRadius: 4.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16)),
                child: Image.network(
                  hotel.mainImageUrl,
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: hotel.name,
                          size: 16,
                          weight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                          color: textBase,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                hotel.address.address,
                                softWrap: false,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: lightGreyColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 4),
                            // const Icon(
                            //   Icons.location_on,
                            //   size: 14,
                            //   color: primaryColor,
                            // ),
                            // AppText(
                            //     text: hotel.distance != 0
                            //         ? "${hotel.distance.toInt()} km to hotel"
                            //         : "hotel too far",
                            //     size: 12,
                            //     color: lightGreyColor),
                            const SizedBox(width: 50),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            for (int i = 0; i < hotel.rating.mark; i++)
                              const Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: primaryColor,
                              ),
                            for (int i = 0; i < 5 - hotel.rating.mark; i++)
                              const Icon(
                                Icons.star_border_rounded,
                                size: 16,
                                color: primaryColor,
                              ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: AppText(
                                text:
                                    "based on ${hotel.rating.count.toString()} mark${hotel.rating.count > 1 ? "s" : ""}",
                                size: 12,
                                color: lightGreyColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      AppText(
                        text: "${hotel.averageCost}\$",
                        size: 16,
                        weight: FontWeight.w700,
                        color: textBase,
                      ),
                      const SizedBox(height: 4),
                      AppText(text: "/per night", size: 12, color: textBase),
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

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showDatePicker(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Choose date',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8),
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            '${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showRoomsAdults(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Number of Rooms',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            getRoomsAdultsString().toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showDatePicker({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        maximumDate: DateTime.now().add(const Duration(days: 365)),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });
        },
        onCancelClick: () {},
      ),
    );
  }

  void showRoomsAdults({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => RoomsAdultsView(
        barrierDismissible: true,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });
        },
        onCancelClick: () {},
      ),
    );
  }
}
