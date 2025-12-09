import 'package:custom_slidable/custom_slidable/auto_close_behavior.dart';
import 'package:custom_slidable/custom_slidable/dismissal.dart';
import 'package:custom_slidable/custom_slidable/gesture_detector.dart';
import 'package:custom_slidable/custom_slidable/scrolling_behavior.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'action_pane_configuration.dart';
import 'controller.dart';

part 'action_pane.dart';

/// A widget which can be dragged to reveal contextual actions.
class CustomSlidable extends StatefulWidget {
  /// Creates a [CustomSlidable].
  ///
  /// The [enabled], [closeOnScroll], [direction], [dragStartBehavior],
  /// [useTextDirection] and [child] arguments must not be null.
  const CustomSlidable({
    super.key,
    this.controller,
    this.groupTag,
    this.enabled = true,
    this.closeOnScroll = true,
    this.startActionPane,
    this.endActionPane,
    this.direction = Axis.horizontal,
    this.dragStartBehavior = DragStartBehavior.down,
    this.useTextDirection = true,
    required this.child,
  });

  /// The CustomSlidable widget controller.
  final CustomSlidableController? controller;

  /// Whether this CustomSlidable is interactive.
  ///
  /// If false, the child will not slid to show actions.
  ///
  /// Defaults to true.
  final bool enabled;

  /// Specifies to close this [CustomSlidable] after the closest [Scrollable]'s
  /// position changed.
  ///
  /// Defaults to true.
  final bool closeOnScroll;

  /// {@template CustomSlidable.groupTag}
  /// The tag shared by all the [CustomSlidable]s of the same group.
  ///
  /// This is used by [CustomSlidableAutoCloseBehavior] to keep only one [CustomSlidable]
  /// of the same group, open.
  /// {@endtemplate}
  final Object? groupTag;

  /// A widget which is shown when the user drags the [CustomSlidable] to the right or
  /// to the bottom.
  ///
  /// When [direction] is [Axis.horizontal] and [useTextDirection] is true, the
  /// [startActionPane] is determined by the ambient [TextDirection].
  final ActionPane? startActionPane;

  /// A widget which is shown when the user drags the [CustomSlidable] to the left or
  /// to the top.
  ///
  /// When [direction] is [Axis.horizontal] and [useTextDirection] is true, the
  /// [startActionPane] is determined by the ambient [TextDirection].
  final ActionPane? endActionPane;

  /// The direction in which this [CustomSlidable] can be dragged.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis direction;

  /// Whether the ambient [TextDirection] should be used to determine how
  /// [startActionPane] and [endActionPane] should be revealed.
  ///
  /// If [direction] is [Axis.vertical], this has no effect.
  /// If [direction] is [Axis.horizontal], then [startActionPane] is revealed
  /// when the users drags to the reading direction (and in the inverse of the
  /// reading direction for [endActionPane]).
  final bool useTextDirection;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag gesture used to dismiss a
  /// dismissible will begin upon the detection of a drag gesture. If set to
  /// [DragStartBehavior.down] it will begin when a down event is first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for the different behaviors.
  final DragStartBehavior dragStartBehavior;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  _CustomSlidableState createState() => _CustomSlidableState();

  /// The closest instance of the [CustomSlidableController] which controls this
  /// [CustomSlidable] that encloses the given context.
  ///
  /// {@tool snippet}
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// CustomSlidableController controller = CustomSlidable.of(context);
  /// ```
  /// {@end-tool}
  static CustomSlidableController? of(BuildContext context) {
    final scope = context
        .getElementForInheritedWidgetOfExactType<
            _CustomSlidableControllerScope>()
        ?.widget as _CustomSlidableControllerScope?;
    return scope?.controller;
  }
}

class _CustomSlidableState extends State<CustomSlidable>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final CustomSlidableController controller;
  late Animation<Offset> moveAnimation;
  late bool keepPanesOrder;

  @override
  bool get wantKeepAlive => !widget.closeOnScroll;

  @override
  void initState() {
    super.initState();
    controller = (widget.controller ?? CustomSlidableController(this))
      ..actionPaneType.addListener(handleActionPanelTypeChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateIsLeftToRight();
    updateController();
    updateMoveAnimation();
  }

  @override
  void didUpdateWidget(covariant CustomSlidable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      controller.actionPaneType.removeListener(handleActionPanelTypeChanged);

      controller = (widget.controller ?? CustomSlidableController(this))
        ..actionPaneType.addListener(handleActionPanelTypeChanged);
    }

    updateIsLeftToRight();
    updateController();
  }

  @override
  void dispose() {
    controller.actionPaneType.removeListener(handleActionPanelTypeChanged);

    if (controller != widget.controller) {
      controller.dispose();
    }
    super.dispose();
  }

  void updateController() {
    controller
      ..enableStartActionPane = startActionPane != null
      ..startActionPaneExtentRatio = startActionPane?.extentRatio ?? 0;

    controller
      ..enableEndActionPane = endActionPane != null
      ..endActionPaneExtentRatio = endActionPane?.extentRatio ?? 0;
  }

  void updateIsLeftToRight() {
    final textDirection = Directionality.of(context);
    controller.isLeftToRight = widget.direction == Axis.vertical ||
        !widget.useTextDirection ||
        textDirection == TextDirection.ltr;
  }

  void handleActionPanelTypeChanged() {
    setState(() {
      updateMoveAnimation();
    });
  }

  void handleDismissing() {
    if (controller.resizeRequest.value != null) {
      setState(() {});
    }
  }

  void updateMoveAnimation() {
    final double end = controller.direction.value.toDouble();
    moveAnimation = controller.animation.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: widget.direction == Axis.horizontal
            ? Offset(end, 0)
            : Offset(0, end),
      ),
    );
  }

  Widget? get actionPane {
    switch (controller.actionPaneType.value) {
      case ActionPaneType.start:
        return startActionPane;
      case ActionPaneType.end:
        return endActionPane;
      default:
        return null;
    }
  }

  ActionPane? get startActionPane => widget.startActionPane;

  ActionPane? get endActionPane => widget.endActionPane;

  Alignment get actionPaneAlignment {
    final sign = controller.direction.value.toDouble();
    if (widget.direction == Axis.horizontal) {
      return Alignment(-sign, 0);
    } else {
      return Alignment(0, -sign);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    Widget content = SlideTransition(
      position: moveAnimation,
      child: CustomSlidableAutoCloseBehaviorInteractor(
        groupTag: widget.groupTag,
        controller: controller,
        child: widget.child,
      ),
    );

    content = Stack(
      children: <Widget>[
        if (actionPane != null)
          Positioned.fill(
            child: ClipRect(
              clipper: _CustomSlidableClipper(
                axis: widget.direction,
                controller: controller,
              ),
              child: actionPane,
            ),
          ),
        content,
      ],
    );

    return CustomSlidableGestureDetector(
      enabled: widget.enabled,
      controller: controller,
      direction: widget.direction,
      dragStartBehavior: widget.dragStartBehavior,
      child: CustomSlidableAutoCloseNotificationSender(
        groupTag: widget.groupTag,
        controller: controller,
        child: CustomSlidableScrollingBehavior(
          controller: controller,
          closeOnScroll: widget.closeOnScroll,
          child: CustomSlidableDismissal(
            axis: flipAxis(widget.direction),
            controller: controller,
            child: ActionPaneConfiguration(
              alignment: actionPaneAlignment,
              direction: widget.direction,
              isStartActionPane:
                  controller.actionPaneType.value == ActionPaneType.start,
              child: _CustomSlidableControllerScope(
                controller: controller,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomSlidableControllerScope extends InheritedWidget {
  const _CustomSlidableControllerScope({
    required this.controller,
    required super.child,
  });

  final CustomSlidableController? controller;

  @override
  bool updateShouldNotify(_CustomSlidableControllerScope old) {
    return controller != old.controller;
  }
}

class _CustomSlidableClipper extends CustomClipper<Rect> {
  _CustomSlidableClipper({required this.axis, required this.controller})
      : super(reclip: controller.animation);

  final Axis axis;
  final CustomSlidableController controller;

  @override
  Rect getClip(Size size) {
    switch (axis) {
      case Axis.horizontal:
        final double offset = controller.ratio * size.width;
        if (offset < 0) {
          return Rect.fromLTRB(size.width + offset, 0, size.width, size.height);
        }
        return Rect.fromLTRB(0, 0, offset, size.height);
      case Axis.vertical:
        final double offset = controller.ratio * size.height;
        if (offset < 0) {
          return Rect.fromLTRB(
            0,
            size.height + offset,
            size.width,
            size.height,
          );
        }
        return Rect.fromLTRB(0, 0, size.width, offset);
    }
  }

  @override
  Rect getApproximateClipRect(Size size) => getClip(size);

  @override
  bool shouldReclip(_CustomSlidableClipper oldClipper) {
    return oldClipper.axis != axis;
  }
}
