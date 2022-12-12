import 'package:flutter/material.dart';
import 'package:hoteldise/models/room_type.dart';
import 'package:hoteldise/pages/hotels/room_page/room_page.dart';
import 'package:hoteldise/widgets/text_widget.dart';

import '../../../themes/constants.dart';

class RoomCard extends StatefulWidget {
  final RoomType room;

  const RoomCard({Key? key, required this.room}) : super(key: key);

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard> {
  Future<void> setImages() async {
    await widget.room.setImagesUrls();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setImages();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) =>
                  RoomPage(room: widget.room),
              fullscreenDialog: true),
        );
      },
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: elevatedGrey,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(width: 1, color: elevatedGrey)
        ),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.bed_outlined),
            AppText(
              text: 'Cost: ${widget.room.price.price}${widget.room.price.currency}',
              color: textBase,
              size: 14,
            ),
            AppText(
              text: widget.room.description,
              color: textBase,
              size: 14,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
