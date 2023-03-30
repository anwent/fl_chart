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
  PinPromotionPoint({required this.index, required this.xVal, required this.price, required this.showBottomX});

  int index;

  // X
  String xVal;

  // Y 价格
  double price;

  bool showBottomX;
}
