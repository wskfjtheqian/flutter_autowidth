import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AutoWidhtTheme extends SingleChildRenderObjectWidget {
  AutoWidhtTheme({
    Key key,
    Widget child,
    AutoWidhtThemeData data,
  }) : super(
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
    if (child != null) {
      final BoxParentData childParentData = child.parentData as BoxParentData;
      return result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
    }
    return false;
  }
}

const double sm = 540;
const double md = 720;
const double lg = 960;
const double xl = 1140;

class AutoWidhtThemeData {
  AutoWidhtThemeData({
    List<double> sizes = const [sm, md, lg, xl],
    this.split = 24,
  }) {
    _sizes = sizes.toList();
    _sizes.sort((a, b) => (a - b).ceil());
  }

  final int split;

  List<double> _sizes;

  List<double> get sizes => _sizes;
}
