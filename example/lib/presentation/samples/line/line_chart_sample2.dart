import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: PinPromotionChartContainer(
        [
          PinPromotionPoint(index: 0, time: '02-11', price: 3333),
          PinPromotionPoint(index: 1, time: '02-18', price: 50030),
          PinPromotionPoint(index: 2, time: '02-25', price: 1400),
          PinPromotionPoint(index: 3, time: '03-04', price: 11233),
          PinPromotionPoint(index: 4, time: '03-11', price: 72302),
        ],
      ),
    );
  }
}
