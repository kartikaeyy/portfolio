import 'package:flutter/material.dart';

/// Gives any descendant access to the page's scroll controller and the shell's
/// "jump to section" behaviour, so hero buttons and the footer can drive
/// navigation without the pages knowing how the shell is wired.
class SectionScope extends InheritedWidget {
  final ScrollController controller;
  final void Function(int index) goToSection;

  const SectionScope({
    super.key,
    required this.controller,
    required this.goToSection,
    required super.child,
  });

  /// Section indices, mirrored by the nav bar labels.
  static const hey = 0;
  static const work = 1;
  static const story = 2;
  static const chat = 3;

  static SectionScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SectionScope>();

  @override
  bool updateShouldNotify(SectionScope oldWidget) =>
      controller != oldWidget.controller ||
      goToSection != oldWidget.goToSection;
}
