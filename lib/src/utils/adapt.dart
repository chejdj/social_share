import 'dart:ui';

import 'package:flutter/material.dart';

class Adapt {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);

  /// 有时候会出现尺寸很小的情况，猜测是由于启动瞬间的竖屏引起，所以这里设置固定为长的一边为宽，消除掉竖屏对尺寸取值的影响
  static final double _width = mediaQuery.size.width < mediaQuery.size.height
      ? mediaQuery.size.width
      : mediaQuery.size.height;
  static final double _height = mediaQuery.size.width < mediaQuery.size.height
      ? mediaQuery.size.height
      : mediaQuery.size.width;
  static final double _topbarH = mediaQuery.padding.top;
  static final double _botbarH = mediaQuery.padding.bottom;
  static final double _pixelRatio = mediaQuery.devicePixelRatio;
  static final double _textScaleFactor = mediaQuery.textScaleFactor;
  //设计图宽度
  static int designWidth = 1080;
  static double? _ratio;
  static init(int number) {
    _ratio = _width / number;
  }

  static px(number) {
    if (!(_ratio is double || _ratio is int)) {
      Adapt.init(designWidth);
    }
    return number * _ratio;
  }

  static pxInt(number) {
    if (!(_ratio is double || _ratio is int)) {
      Adapt.init(designWidth);
    }
    return int.parse((number * _ratio).toString().split('.')[0]);
  }

  static onepx() {
    return 1 / _pixelRatio;
  }

  static screenW() {
    return _width;
  }

  static screenH() {
    return _height;
  }

  static padTopH() {
    return _topbarH;
  }

  static padBotH() {
    return _botbarH;
  }

  static fz(fontSize) {
    return ((fontSize * (_width / designWidth)) / _textScaleFactor);
  }

  static fz3(fontSize) {
    return ((fontSize * (_width / designWidth)) / _textScaleFactor) * 2.6;
  }
}
