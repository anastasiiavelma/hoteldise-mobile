import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoteldise/models/hotel.dart';
import 'package:hoteldise/pages/hotels/home/sort.dart';
import 'package:hoteldise/widgets/hotel_card.dart';
import '../../../themes/colors.dart';
import '../../../widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'calendarPopUp.dart';
import 'filter.dart';
import 'package:hoteldise/services/auth.dart';
import 'package:provider/provider.dart';

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
  List<Hotel> hotels = <Hotel>[];
  SortOption currentSortOption = sortOptions[0];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    getAllHotels();
    super.initState();
  }

  getAllHotels() async {
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
        newHotels.last.hotelId = doc.reference.id;
      }

      for (int i = 0; i < newHotels.length; i++) {
        await newHotels[i].setDistance();
        await newHotels[i].setMainImage();
      }

      setState(() {
        hotels = newHotels;
        SortByMark().doSort(hotels);
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
              sortOptions[i].doSort(hotels);
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
              TextField(
                autocorrect: false,
                enableSuggestions: false,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                cursorColor: Colors.black87,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  filled: true,
                  fillColor: veryLightGreyColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  prefixIcon: const Icon(Icons.search, color: greyColor),
                  hintText: "Search for hotels",
                  hintStyle: const TextStyle(fontSize: 14, color: greyColor),
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
                  itemCount: hotels.length + 1,
                  itemBuilder: (context, index) {
                    if (index == hotels.length) {
                      return const SizedBox(height: 0);
                    } else {
                      return HotelCard(
                        hotel: hotels[index],
                        Auth: Auth,
                      );
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
                      // setState(() {
                      //   isDatePopupOpen = true;
                      // });
                      showDemoDialog(context: context);
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
                          const Text(
                            '1 Room - 2 Adults',
                            style: TextStyle(
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

  void showDemoDialog({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
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
}
