import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

typedef FlTouchEventHandler = void Function(FlTouchEvent, int?);

class PinPromotionChartContainer extends StatefulWidget {
  PinPromotionChartContainer(
    this.datasource, {
    super.key,
    this.dashLineColor = const Color(0xff666666),
    this.dashWidth = 0.5,
    this.dashArray = const [5, 5],
    this.bottomBarHeight = 45,
    this.leftBarWidth = 62,
    this.minX = 0,
    this.minY = -1,
    this.maxX = 5,
    this.maxY = 12,
    this.lineWidth = 2.0,
    this.tipsLabelColor = const Color(0xFF409EFF),
    this.tipsTextStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
    this.barTitleStyle = const TextStyle(fontWeight: FontWeight.w200, fontSize: 14, color: Color(0xff999999)),
    this.curveSmoothness = 0,
    this.touchEvent,
  }) {
    scale = maxVal > 10.0 ? (maxVal / 10) : 1.0;
  }

  List<Color> gradientColors = [const Color(0xFF409EFF), const Color(0xFF409EFF)];

  // 数据源
  List<PinPromotionPoint> datasource;

  // 虚线颜色
  Color dashLineColor;

  // 虚线宽度
  double dashWidth;

  // 虚线间隔
  List<int> dashArray;

  // 底部高度
  double bottomBarHeight;

  // 左边栏宽度
  double leftBarWidth;

  // X Y轴的最大最小值
  double minX, minY, maxX, maxY;

  // 折线宽度
  double lineWidth;

  // 提示label背景
  Color tipsLabelColor;

  // 提示字体
  TextStyle tipsTextStyle;

  // 刻度字体
  TextStyle barTitleStyle;

  // 平滑度
  double curveSmoothness;

  // callback
  FlTouchEventHandler? touchEvent;

  @override
  State<PinPromotionChartContainer> createState() => PinPromotionChartControlerState();

  /// 数据源缩放比例
  double scale = 1.0;

  /// 获取数据源中最大的值
  double get maxVal => datasource.map((e) => e.price).toList().reduce((value, element) => value > element ? value : element);
}

class PinPromotionChartControlerState extends State<PinPromotionChartContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LineChart(_chartData),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  /// 转换后的数据源
  List<FlSpot> get dataConversion {
    final res = widget.datasource.map((e) => FlSpot(e.index.toDouble(), e.price / widget.scale)).toList();
    return res;
  }

  LineChartData get _chartData => LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: widget.dashLineColor,
              strokeWidth: widget.dashWidth,
              dashArray: widget.dashArray,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: widget.bottomBarHeight,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: leftTitleWidgets,
              reservedSize: widget.leftBarWidth,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: widget.minX,
        maxX: widget.maxX,
        minY: widget.minY,
        maxY: widget.maxY,
        lineBarsData: [
          LineChartBarData(
            spots: dataConversion,
            curveSmoothness: widget.curveSmoothness,
            isCurved: true,
            gradient: LinearGradient(
              colors: widget.gradientColors,
            ),
            barWidth: widget.lineWidth,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
          ),
        ],
        lineTouchData: touchData,
      );

  LineTouchData get touchData => LineTouchData(
        handleBuiltInTouches: true,
        getTouchLineEnd: defaultGetTouchLineStart,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: tooltipItem,
          tooltipBgColor: widget.tipsLabelColor,
        ),
        touchCallback: (event, response) {
          if ((response?.lineBarSpots?.length ?? 0) > 0) {
            widget.touchEvent?.call(event, response?.lineBarSpots?.first.spotIndex);
          } else {
            widget.touchEvent?.call(event, null);
          }
        },
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < widget.datasource.length) {
      if (!widget.datasource[index].showBottomX) {
        return Container();
      }
      final title = widget.datasource[index].xVal.length == 10 ? widget.datasource[index].xVal.substring(5) : widget.datasource[index].xVal;
      Widget text = Text(title, style: widget.barTitleStyle);
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: text,
      );
    }

    return Container();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    if (value >= 0 && value % 2 == 0) {
      return Text('${(value * widget.scale).toInt()}', style: widget.barTitleStyle, textAlign: TextAlign.center);
    }
    return Container();
  }

  List<LineTooltipItem> tooltipItem(List<LineBarSpot> touchedSpots) {
    return touchedSpots.map((e) => LineTooltipItem('', widget.tipsTextStyle)).toList();
    // return touchedSpots.map((LineBarSpot touchedSpot) {
    //   // final price = widget.datasource[touchedSpot.spotIndex].price;
    //   // final time = widget.datasource[touchedSpot.spotIndex].xVal;
    //   // final sub = time.length == 10 ? time.substring(5) : time;
    //   return LineTooltipItem('', widget.tipsTextStyle);
    // }).toList();
  }
}
