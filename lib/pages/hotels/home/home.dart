import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:hoteldise/models/hotel.dart';
import 'package:hoteldise/pages/hotels/home/search/address_search.dart';
import 'package:hoteldise/pages/hotels/home/sort.dart';
import 'package:hoteldise/services/auth.dart';
import 'package:hoteldise/widgets/hotel_card.dart';
import 'package:provider/provider.dart';

import '../../../themes/constants.dart';
import '../../../widgets/loader.dart';
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
  RangeValues costRange = const RangeValues(0, 1000);
  List<String> facilities = [];
  bool hotelsLoaded = false;

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
    hotelsLoaded = false;
    FirebaseFirestore db = FirebaseFirestore.instance;

    //getting hotel instances
    List<Hotel> newHotels = <Hotel>[];
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
    });

    //with at least one empty room, in cost range
    newHotels = newHotels
        .where((h) => h.rooms.any((r) =>
            r.numOfFreeSuchRooms > 0 &&
            r.price.price >= costRange.start &&
            r.price.price <= costRange.end &&
            facilities.every((f) => r.facilities!.contains(f))))
        .toList();

    //search filter
    newHotels = newHotels
        .where((element) => element.address.address
            .toLowerCase()
            .contains(searchValue.toLowerCase()))
        .toList();

    //setting extra fields
    for (int i = 0; i < newHotels.length; i++) {
      await newHotels[i].setExtraFields();
    }

    //setting new hotels and doing sort
    if (mounted) {
      setState(() {
        matchedHotels = newHotels;
        currentSortOption.doSort(matchedHotels);
        hotelsLoaded = true;
      });
    }
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
    AuthBase Auth = Provider.of<AuthBase>(context);
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
                      openFiltersAdGetResult(context);
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
              hotelsLoaded == false ?
              const Loader() :
              Flexible(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemCount: matchedHotels.length + 1,
                  itemBuilder: (context, index) {
                    if (index == matchedHotels.length) {
                      return const SizedBox(height: 0);
                    }
                    else {
                        return HotelCard(
                          hotel: matchedHotels[index],
                          Auth: Auth,
                        );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 20);
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openFiltersAdGetResult(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) =>
              FiltersScreen(costRange: costRange, facilities: facilities),
          fullscreenDialog: true),
    );
    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted || result == null) return;
    setState(() {
      costRange = result[0];
      facilities = result[1];
      getHotels();
    });
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
