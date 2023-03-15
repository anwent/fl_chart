import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

///
/// 活动模块折线图数据源
///
/// X -> time
/// Y -> price
///
class PinPromotionPoint {
  PinPromotionPoint({required this.index, required this.time, required this.price});

  int index;

  // X 时间
  String time;

  // Y 价格
  double price;
}
