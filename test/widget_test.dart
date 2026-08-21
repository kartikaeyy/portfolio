import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/portfolio_app.dart';
import 'package:portfolio/data/portfolio_data.dart';
import 'package:portfolio/widgets/nav_bar.dart';

/// Renders the whole page at one viewport size and fails on any layout
/// overflow or paint exception — the cheapest guard for a responsive site that
/// has to hold up from a small phone to an ultrawide display.
Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const PortfolioApp());
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  testWidgets('renders the hero and nav on a phone', (tester) async {
    await _pumpAt(tester, const Size(390, 844));

    expect(find.byType(PortfolioNavBar), findsOneWidget);
    expect(find.text('Kartikey\nSrivastava'), findsOneWidget);
    // The phone layout shows the sections inline instead of hiding them behind
    // a menu sheet.
    for (final label in PortfolioNavBar.labels) {
      expect(find.text(label), findsWidgets);
    }
  });

  testWidgets('lays out without overflow on tablet', (tester) async {
    await _pumpAt(tester, const Size(900, 1200));
    expect(tester.takeException(), isNull);
  });

  testWidgets('lays out without overflow on desktop', (tester) async {
    await _pumpAt(tester, const Size(1440, 900));
    expect(tester.takeException(), isNull);
  });

  // Every section — including the Work section, which keeps its own padding —
  // must start on the same vertical line, on the phone and on the desktop.
  for (final size in const [Size(390, 844), Size(1440, 900), Size(900, 1200)]) {
    testWidgets(
      'section content shares one gutter at ${size.width.toInt()}px',
      (tester) async {
        await _pumpAt(tester, size);

        final hero = tester.getTopLeft(find.text('Kartikey\nSrivastava')).dx;
        final work = tester.getTopLeft(find.text('My Work')).dx;
        final experience = tester.getTopLeft(find.text('Experience')).dx;
        final story = tester.getTopLeft(find.text('My Story')).dx;

        expect(work, closeTo(hero, 0.5));
        expect(experience, closeTo(hero, 0.5));
        expect(story, closeTo(hero, 0.5));
      },
    );
  }

  // The labels used to shrink-wrap to the top of the indicator track, so they
  // floated above the sliding pill instead of sitting inside it.
  for (final size in const [Size(390, 844), Size(1440, 900)]) {
    testWidgets('nav labels centre on the pill at ${size.width.toInt()}px', (
      tester,
    ) async {
      await _pumpAt(tester, size);

      final barCentre = tester.getCenter(find.byType(PortfolioNavBar)).dy;
      for (final label in PortfolioNavBar.labels) {
        final tab = find.descendant(
          of: find.byType(PortfolioNavBar),
          matching: find.text(label),
        );
        expect(tester.getCenter(tab).dy, closeTo(barCentre, 1.0));
      }
    });
  }

  testWidgets('experience sits between the Work cards and Story', (
    tester,
  ) async {
    await _pumpAt(tester, const Size(1440, 900));

    final work = tester.getTopLeft(find.text('My Work')).dy;
    final experience = tester.getTopLeft(find.text('Experience')).dy;
    final story = tester.getTopLeft(find.text('My Story')).dy;

    expect(experience, greaterThan(work));
    expect(experience, lessThan(story));
    // One timeline on the page, one card per role.
    expect(find.text('Experience'), findsOneWidget);
    for (final exp in kExperiences) {
      expect(find.text(exp.company), findsWidgets);
    }
  });

  testWidgets('socials use real brand marks, not lookalike glyphs', (
    tester,
  ) async {
    await _pumpAt(tester, const Size(1440, 900));

    for (final brand in const [
      FontAwesomeIcons.github,
      FontAwesomeIcons.linkedinIn,
    ]) {
      expect(
        find.byWidgetPredicate(
          (w) => w is FaIcon && w.icon == brand.data,
          description: 'FaIcon(${brand.data.codePoint})',
        ),
        findsWidgets,
      );
    }
    // The old stand-ins are gone everywhere outside the Work cards.
    expect(find.byIcon(Icons.code_rounded), findsNothing);
    expect(find.byIcon(Icons.work_outline_rounded), findsNothing);
  });

  testWidgets('every role renders its company logo', (tester) async {
    await _pumpAt(tester, const Size(1440, 900));

    for (final exp in kExperiences) {
      expect(exp.logoAsset, isNotNull, reason: '${exp.company} has no logo');
      expect(
        find.image(AssetImage(exp.logoAsset!)),
        findsOneWidget,
        reason: '${exp.company} logo not painted',
      );
    }
  });
}
