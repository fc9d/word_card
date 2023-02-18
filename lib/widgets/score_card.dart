import 'package:flutter/material.dart';

Widget ScoreCard(String title, String info) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 26.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text(
            info,
            style: const TextStyle(
              fontSize: 34.0,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    ),
  );
}
