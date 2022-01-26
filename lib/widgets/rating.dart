import 'package:flutter/material.dart';

Widget buildRatingStart(int rating) {
  String stars = '';
  for (int i = 0; i < 5; i++) {
    if (rating >= i) {
      stars += '⭐ ';
    } else {
      stars += '';
    }
  }
  stars.trim();
  return Text(stars, style: const TextStyle(fontSize: 10));
}
