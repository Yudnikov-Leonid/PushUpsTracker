import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GoalPie extends StatelessWidget {
  const GoalPie(this.current, this.goal, {super.key});

  final int current;
  final int goal;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Goal: $goal'),
                Text('${((current / goal * 1000).round() / 10)}%'),
              ],
            ),
          ),
          PieChart(PieChartData(
            pieTouchData: PieTouchData(),
            sections: _sections(),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 60,
          )),
        ],
      ),
    );
  }

  List<PieChartSectionData> _sections() {
    if (current < goal) {
      return [
        PieChartSectionData(
          color: Colors.green,
          value: current.toDouble(),
          title: '',
          radius: 40,
        ),
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: goal.toDouble() - current,
          title: '',
          radius: 40,
        )
      ];
    } else {
      return [PieChartSectionData(
          color: Colors.green,
          value: current.toDouble(),
          title: '',
          radius: 40,
        ),];
    }
  }
}
