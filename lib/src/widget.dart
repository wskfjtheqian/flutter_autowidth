import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_aoutwidth/src/theme.dart';

///创建部件的回调
/// context 上下文
/// constraints AutoWidth 组件的当前尺寸
/// useSize 当前组件使用的屏幕
typedef AutoWidthBuilder = Widget Function(BuildContext context, BoxConstraints constraints, double useSize);

///根据尺寸尺寸自动调解部件宽度
class AutoWidth extends RenderObjectWidget {
  AutoWidth({
    Key key,
    this.sizes = const {},
    this.builder,
    this.height,
  })  : assert(null != builder),
        assert(null != sizes),
        super(key: key);

  ///组件的高度 ,默认为null会根据子部件调整高度
  final double height;

  ///
  final Map<double, int> sizes;

  final AutoWidthBuilder builder;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderAutoWidthBox(sizes, height);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderAutoWidthBox renderObject) {
    renderObject.sizes = sizes;
  }

  @override
  _AutoWidthElement createElement() {
    return _AutoWidthElement(this);
  }
}

class _AutoWidthElement extends RenderObjectElement {
  _AutoWidthElement(AutoWidth widget) : super(widget);

  @override
  AutoWidth get widget => super.widget as AutoWidth;

  @override
  _RenderAutoWidthBox get renderObject => super.renderObject as _RenderAutoWidthBox;

  Element _child;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_child != null) visitor(_child);
  }

  @override
  void forgetChild(Element child) {
    assert(child == _child);
    _child = null;
    super.forgetChild(child);
  }

  @override
  void mount(Element parent, dynamic newSlot) {
    super.mount(parent, newSlot); // Creates the renderObject.
    renderObject.updateCallback(_layout);
  }

  @override
  void update(AutoWidth newWidget) {
    assert(widget != newWidget);
    super.update(newWidget);
    assert(widget == newWidget);
    renderObject.updateCallback(_layout);
    renderObject.markNeedsLayout();
  }

  @override
  void performRebuild() {
    renderObject.markNeedsLayout();
    super.performRebuild();
  }

  @override
  void unmount() {
    renderObject.updateCallback(null);
    super.unmount();
  }

  void _layout(BoxConstraints constraints, double useSize) {
    owner.buildScope(this, () {
      Widget built;
      if (widget.builder != null) {
        try {
          built = widget.builder(this, constraints, useSize);
          debugWidgetBuilderValue(widget, built);
        } catch (e, stack) {
          built = ErrorWidget.builder(
            _debugReportException(
              ErrorDescription('building $widget'),
              e,
              stack,
              informationCollector: () sync* {
                yield DiagnosticsDebugCreator(DebugCreator(this));
              },
            ),
          );
        }
      }
      try {
        _child = updateChild(_child, built, null);
        assert(_child != null);
      } catch (e, stack) {
        built = ErrorWidget.builder(
          _debugReportException(
            ErrorDescription('building $widget'),
            e,
            stack,
            informationCollector: () sync* {
              yield DiagnosticsDebugCreator(DebugCreator(this));
            },
          ),
        );
        _child = updateChild(null, built, slot);
      }
    });
  }

  @override
  void insertChildRenderObject(RenderObject child, dynamic slot) {
    final _RenderAutoWidthBox renderObject = this.renderObject;
    assert(slot == null);
    assert(renderObject.debugValidateChild(child));
    renderObject.child = child;
    assert(renderObject == this.renderObject);
  }

  @override
  void moveChildRenderObject(RenderObject child, dynamic slot) {
    assert(false);
  }

  @override
  void removeChildRenderObject(RenderObject child) {
    final _RenderAutoWidthBox renderObject = this.renderObject;
    assert(renderObject.child == child);
    renderObject.child = null;
    assert(renderObject == this.renderObject);
  }
}

typedef _RenderAutoWidthBoxBuilder = void Function(BoxConstraints constraints, double useSize);

class _RenderAutoWidthBox extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  Map<double, int> sizes;
  double _key;
  double height;

  _RenderAutoWidthBox(this.sizes, this.height);

  @override
  double computeMinIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  void performLayout() {
    var temp = parent;
    while (null != temp && !(temp is RenderAutoWidhtThemeBox)) {
      temp = temp.parent;
    }
    assert(null != temp, "not find AutoWidhtTheme");

    var width = constraints.biggest.width;
    var keys = sizes.keys.toList()..sort((a, b) => (b - a).ceil());
    double key = (temp as RenderAutoWidhtThemeBox).useSize;
    for (var item in keys) {
      if (key > item) {
        key = item;
        break;
      }
    }
    width = width / (temp as RenderAutoWidhtThemeBox).data.split * sizes[key];
    var cons = BoxConstraints.tightForFinite(width: width - 0.0001, height: height ?? double.infinity);

    if (_key != key && null != _callback) {
      invokeLayoutCallback((constraints) {
        _callback(cons, key);
      });
    }
    _key = key;

    if (child != null) {
      child.layout(cons, parentUsesSize: true);
      size = cons.constrain(child.size);
    } else {
      size = Size(constraints.biggest.width, height ?? 0);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return child?.hitTest(result, position: position) ?? false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) context.paintChild(child, offset);
  }

  _RenderAutoWidthBoxBuilder _callback;

  void updateCallback(_RenderAutoWidthBoxBuilder value) {
    _key = null;
    if (value == _callback) return;
    _callback = value;
    markNeedsLayout();
  }

  bool _debugThrowIfNotCheckingIntrinsics() {
    assert(() {
      if (!RenderObject.debugCheckingIntrinsics) {
        throw FlutterError('LayoutBuilder does not support returning intrinsic dimensions.\n'
            'Calculating the intrinsic dimensions would require running the layout '
            'callback speculatively, which might mutate the live render object tree.');
      }
      return true;
    }());

    return true;
  }
}

FlutterErrorDetails _debugReportException(
  DiagnosticsNode context,
  dynamic exception,
  StackTrace stack, {
  InformationCollector informationCollector,
}) {
  final FlutterErrorDetails details = FlutterErrorDetails(
    exception: exception,
    stack: stack,
    library: 'widgets library',
    context: context,
    informationCollector: informationCollector,
  );
  FlutterError.reportError(details);
  return details;
}
