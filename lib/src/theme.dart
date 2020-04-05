import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

///自动宽度的样式部件
class AutoWidhtTheme extends SingleChildRenderObjectWidget {
  AutoWidhtTheme({
    Key key,
    Widget child,
    AutoWidhtThemeData data,
  })  : assert(null != child),
        super(
          key: key,
          child: child,
        ) {
    _data = data ?? AutoWidhtThemeData();
  }

  AutoWidhtThemeData _data;
  SingleChildRenderObjectElement _element;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderAutoWidhtThemeBox(_data);
  }

  @override
  void updateRenderObject(BuildContext context, RenderAutoWidhtThemeBox renderObject) {
    renderObject._data = _data;
  }

  static AutoWidhtThemeData of(BuildContext context) {
    assert(null != context);
    AutoWidhtTheme theme = context.findAncestorWidgetOfExactType<AutoWidhtTheme>();
    assert(null != theme, "Not find AutoWidhtTheme");
    return theme._data;
  }
}

class RenderAutoWidhtThemeBox extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  RenderAutoWidhtThemeBox(this._data) : super();

  AutoWidhtThemeData _data;

  AutoWidhtThemeData get data => _data;

  double _useSize;

  double get useSize => _useSize;

  @override
  bool get sizedByParent => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child, offset);
  }

  @override
  void performLayout() {
    _onSizeChange();
    child.layout(BoxConstraints.tight(size));
    super.performLayout();
  }

  void _onSizeChange() {
    double temp = size.width;
    for (double item in _data.sizes) {
      if (item >= temp) {
        temp = item;
        break;
      }
    }
    _useSize = temp;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return child.hitTestChildren(result, position: position);
  }
}

const double sm = 540;
const double md = 720;
const double lg = 960;
const double xl = 1140;
const double ll = 1600;

class AutoWidhtThemeData {
  AutoWidhtThemeData({
    List<double> sizes = const [sm, md, lg, xl, ll],
    this.split = 24,
  }) {
    _sizes = sizes.toList();
    _sizes.sort((a, b) => (a - b).ceil());
  }

  ///切分数量
  final int split;

  ///定义屏幕尺寸
  List<double> _sizes;

  List<double> get sizes => _sizes;
}
