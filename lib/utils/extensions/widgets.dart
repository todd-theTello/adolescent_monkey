import 'package:flutter/material.dart';

/// Extension on widgets
extension T on Widget {
  ///
  Widget visibility({required bool isVisible}) {
    return Visibility(visible: isVisible, child: this);
  }

  ///
  Widget get safeArea {
    return SafeArea(child: this);
  }

  /// wrap widget with icon button
  Widget iconButton({required void Function() onTap, EdgeInsetsGeometry? padding}) {
    return IconButton(padding: padding, onPressed: onTap, icon: this);
  }

  /// padding from left top right bottom
  Widget paddingLTRB(double left, double top, double right, double bottom) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: this,
    );
  }

  /// symmetric padding on child
  Widget paddingSymmetric({double? horizontal, double? vertical}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      ),
      child: this,
    );
  }

  /// default horizontal padding on child
  Widget get horizontalPadding20 => Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: this);

  /// default horizontal padding on child
  Widget get kVerticalPadding20 => Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: this);

  /// padding of 8 on top
  Widget get topPadding8 => Padding(padding: const EdgeInsets.only(top: 8), child: this);

  /// padding of 12 on top
  Widget get topPadding12 => Padding(padding: const EdgeInsets.only(top: 12), child: this);

  /// padding of 12 on top
  Widget get topPadding14 => Padding(padding: const EdgeInsets.only(top: 14), child: this);

  /// padding of 8 on bottom
  Widget get bottomPadding8 => Padding(padding: const EdgeInsets.only(bottom: 8), child: this);

  /// padding of 12 on bottom
  Widget get bottomPadding12 => Padding(padding: const EdgeInsets.only(bottom: 12), child: this);

  /// padding of 16 on bottom
  Widget get bottomPadding16 => Padding(padding: const EdgeInsets.only(bottom: 16), child: this);

  /// padding of 20 on bottom
  Widget get bottomPadding20 => Padding(padding: const EdgeInsets.only(bottom: 20), child: this);

  /// default horizontal padding on child
  Widget get horizontalSliverPadding20 => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: this,
      );

  /// padding of 8 on bottom
  Widget get bottomSliverPadding8 => SliverPadding(padding: const EdgeInsets.only(bottom: 8), sliver: this);

  /// padding of 12 on bottom
  Widget get bottomSliverPadding12 => SliverPadding(padding: const EdgeInsets.only(bottom: 12), sliver: this);

  /// padding of 16 on bottom
  Widget get bottomSliverPadding16 => SliverPadding(padding: const EdgeInsets.only(bottom: 16), sliver: this);

  /// padding of 20 on bottom
  Widget get bottomSliverPadding20 => SliverPadding(padding: const EdgeInsets.only(bottom: 20), sliver: this);

  /// padding of 8 on bottom
  Widget paddingOnly({double? left, double? top, double? right, double? bottom}) {
    return Padding(
      padding: EdgeInsets.only(left: left ?? 0, top: top ?? 0, right: right ?? 0, bottom: bottom ?? 0),
      child: this,
    );
  }

  /// padding from left top right bottom
  Widget sliverPaddingLTRB(double left, double top, double right, double bottom) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      sliver: this,
    );
  }

  /// symmetric padding on child
  Widget sliverPaddingSymmetric({double? horizontal, double? vertical}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontal ?? 0, vertical: vertical ?? 0),
      sliver: this,
    );
  }

  /// padding from left top right bottom
  Widget sliverPaddingOnly({double? left, double? top, double? right, double? bottom}) {
    return SliverPadding(
      padding: EdgeInsets.only(left: left ?? 0, top: top ?? 0, right: right ?? 0, bottom: bottom ?? 0),
      sliver: this,
    );
  }

  ///
  Widget get center => Center(child: this);

  ///
  Widget get centerAlign => Align(child: this);

  ///
  Widget get centerLeftAlign => Align(alignment: Alignment.centerLeft, child: this);

  ///
  Widget get centerRightAlign => Align(alignment: Alignment.centerRight, child: this);

  ///
  Widget get topCenterAlign => Align(alignment: Alignment.topCenter, child: this);

  ///
  Widget get topLeftAlign => Align(alignment: Alignment.topLeft, child: this);

  ///
  Widget get topRightAlign => Align(alignment: Alignment.topRight, child: this);

  ///
  Widget get bottomCenterAlign => Align(alignment: Alignment.bottomCenter, child: this);

  ///
  Widget get bottomLeftAlign => Align(alignment: Alignment.bottomLeft, child: this);

  ///
  Widget get bottomRightAlign => Align(alignment: Alignment.bottomRight, child: this);

  ///
  Widget get expanded => Expanded(child: this);

  ///
  Widget get flexible => Flexible(child: this);

  ///
  Widget expandedWithFlex({int? flex}) => Expanded(flex: flex ?? 1, child: this);
}
