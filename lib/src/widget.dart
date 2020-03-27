import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_aoutwidth/src/theme.dart';

class AutoWidth extends SingleChildRenderObjectWidget {
  AutoWidth({
    Key key,
    Widget child,
    this.sizes = const {},
  }) : super(key: key) {
    _child = child;
  }

  SingleChildRenderObjectElement _element;

  final Map<double, int> sizes;

  Widget _child;

  @override
  Widget get child {
    return _child;
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderAutoWidthBox(sizes).._onReBuilder = _onReBuilder;
  }

  @override
  void updateRenderObject(BuildContext context, _RenderAutoWidthBox renderObject) {
    renderObject.sizes = sizes;
  }

  @override
  SingleChildRenderObjectElement createElement() {
    return _element = super.createElement();
  }

  _onReBuilder(double useSize) {
    Timer(Duration(), () {
      _element.markNeedsBuild();
    });
  }
}

class _RenderAutoWidthBox extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  Map<double, int> sizes;
  double _key;

  void Function(double useSize) _onReBuilder;

  _RenderAutoWidthBox(this.sizes);

  @override
  bool get sizedByParent => false;

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child, offset);
  }

  @override
  void performLayout() {
    var temp = parent;
    while (null != temp && !(temp is RenderAutoWidhtThemeBox)) {
      temp = temp.parent;
    }

    var width = constraints.biggest.width;
    var keys = sizes.keys.toList()..sort((a, b) => (b - a).ceil());
    if (null != temp && 0 < sizes.length) {
      double key = (temp as RenderAutoWidhtThemeBox).useSize;
      for (var item in keys) {
        if (key > item) {
          key = item;
          break;
        }
      }
      if (_key != key && null != _onReBuilder) {
        _onReBuilder(key);
      }
      width = width / (temp as RenderAutoWidhtThemeBox).data.split * sizes[key];
      _key = key;
    }

    child.layout(BoxConstraints.tightForFinite(width: width), parentUsesSize: true);
    size = child.size;
    print("aa ${size.width}----$width");
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
