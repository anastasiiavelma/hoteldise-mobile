import 'package:flutter/material.dart';
import 'package:hoteldise/widgets/text_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:intl/intl.dart';

import '/../../themes/constants.dart';

class HotelComment extends StatefulWidget {
  final String? avatarUrl;
  final String authorName;
  final DateTime publishDate;
  final String content;

  const HotelComment(
      {Key? key,
      required this.avatarUrl,
      required this.authorName,
      required this.publishDate,
      required this.content})
      : super(key: key);

  @override
  State<HotelComment> createState() => _HotelCommentState();
}

class _HotelCommentState extends State<HotelComment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          CircleAvatar(
              radius: 24,
              backgroundImage: widget.avatarUrl != null
                  ? NetworkImage(widget.avatarUrl!)
                  : const NetworkImage(
                      'https://images.unsplash.com/photo-1498503403619-e39e4ff390fe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80')),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: widget.authorName,
                  color: textBase,
                  size: 16,
                ),
                AppText(
                  text: DateFormat('dd MMM yyyy').format(widget.publishDate),
                  color: lightGreyColor,
                  size: 14,
                ),
                const SizedBox(height: 4),
                ReadMoreText(
                  widget.content,
                  trimLines: 3,
                  trimCollapsedText: 'Read More',
                  trimExpandedText: 'Read Less',
                  trimMode: TrimMode.Line,
                  style: const TextStyle(fontSize: 14, color: lightGreyColor),
                  lessStyle:
                      const TextStyle(fontSize: 14, color: secondaryColor),
                  moreStyle:
                      const TextStyle(fontSize: 14, color: secondaryColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
