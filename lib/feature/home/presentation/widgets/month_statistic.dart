import 'dart:math';

import 'package:flutter/material.dart';
import 'package:push_ups/core/colors.dart';

class MonthStatistic extends StatelessWidget {
  MonthStatistic(this.title, this.data, {super.key});

  final String title;
  final List<int> data;

  late int _max;

  @override
  Widget build(BuildContext context) {
    _max = data.reduce(max);
    return Container(
      height: 240,
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 160,
            width: double.infinity,
            child: GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 7,
              children: data.map((value) => _box(value)).toList(),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Text(
                '${data.fold(0, (a, b) => a + b)} in total',
                style: const TextStyle(fontSize: 13),
              ),
              const Expanded(child: SizedBox()),
              const Text(
                'Less',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(
                width: 2,
              ),
              _guideBox(AppColors.oneLevelColor),
              _guideBox(AppColors.twoLevelColor),
              _guideBox(AppColors.threeLevelColor),
              _guideBox(AppColors.fourLevelColor),
              _guideBox(AppColors.fiveLevelColor),
              const SizedBox(
                width: 2,
              ),
              const Text(
                'More',
                style: TextStyle(fontSize: 13),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _guideBox(Color color) {
    return Container(
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        width: 17,
        height: 17,
        margin: const EdgeInsets.symmetric(horizontal:  2));
  }

  Widget _box(int value) {
    final percent = (value / _max * 100).round();
    final Color color;
    if (percent == 0) {
      color = AppColors.oneLevelColor;
    } else if (percent < 25) {
      color = AppColors.twoLevelColor;
    } else if (percent < 50) {
      color = AppColors.threeLevelColor;
    } else if (percent < 75) {
      color = AppColors.fourLevelColor;
    } else {
      color = AppColors.fiveLevelColor;
    }
    return Container(
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        width: 10,
        height: 10,
        margin: const EdgeInsets.all(2));
  }
}
