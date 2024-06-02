import 'dart:math';

import 'package:flutter/material.dart';
import 'package:push_ups/core/colors.dart';
import 'package:push_ups/feature/home/domain/entity/day_push_ups.dart';
import 'package:intl/intl.dart';

class MonthStatistic extends StatelessWidget {
  MonthStatistic(this.title, this.data, {super.key});

  final String title;
  final List<DayPushUps> data;

  late int _max;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy-MM-dd');

    _max = data.map((e) => e.value).reduce(max);
    var firstDayDateTime = formatter.parse(data.first.date);

    firstDayDateTime =
        DateTime(firstDayDateTime.year, firstDayDateTime.month, 1);

    while (firstDayDateTime.month != 3 &&
        firstDayDateTime.month != 6 &&
        firstDayDateTime.month != 9 &&
        firstDayDateTime.month != 12 &&
        firstDayDateTime.day != 1) {
      firstDayDateTime.add(const Duration(days: -1));
      firstDayDateTime.add(Duration(days: -firstDayDateTime.day));
    }
    var currentDate = firstDayDateTime.millisecondsSinceEpoch ~/ 86400000;

    var month = firstDayDateTime.month;
    final nextMonth = month + 3;

    final result = <int>[];
    for (int i = 0; i < firstDayDateTime.weekday -1; i++) {
      result.add(-1);
    }
    while (month < nextMonth) {
      if (data.isNotEmpty) {
        if (formatter.format(
                DateTime.fromMillisecondsSinceEpoch(currentDate * 86400000)) ==
            data.first.date) {
          result.add(data.first.value);
          data.removeAt(0);
        } else {
          result.add(0);
        }
      } else {
        result.add(0);
      }
      currentDate++;
      if (nextMonth == 15) {
        month =
            DateTime.fromMillisecondsSinceEpoch(currentDate * 86400000).month;
        if (month < 12) {
          month += 12;
        }
      } else {
        month =
            DateTime.fromMillisecondsSinceEpoch(currentDate * 86400000).month;
      }
    }

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
          Row(
            children: [
              const Column(
                children: [
                  Text('Tue'),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Thu'),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Sat')
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: SizedBox(
                  height: 160,
                  child: GridView.count(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 7,
                    children: result.map((value) => _box(value)).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Text(
                '${result.fold(0, (a, b) => a + b)} in total',
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
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        width: 17,
        height: 17,
        margin: const EdgeInsets.symmetric(horizontal: 2));
  }

  Widget _box(int value) {
    final percent = (value / _max * 100).round();
    final Color color;
    if (value == -1) {
      color = Colors.transparent;
    } else if (percent == 0) {
      color = AppColors.oneLevelColor;
    } else if (percent < 30) {
      color = AppColors.twoLevelColor;
    } else if (percent < 60) {
      color = AppColors.threeLevelColor;
    } else if (percent < 90) {
      color = AppColors.fourLevelColor;
    } else {
      color = AppColors.fiveLevelColor;
    }
    return Tooltip(
      message: value == -1 ? '' : value.toString(),
      triggerMode: TooltipTriggerMode.tap,
      child: Container(
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4)),
          width: 10,
          height: 10,
          margin: const EdgeInsets.all(2)),
    );
  }
}
