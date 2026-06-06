import 'package:flutter/material.dart';

/// Border radius tokens from Stitch Aura Couture shape language.
abstract final class TrendsRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double standard = 12;
  static const double card = 16;
  static const double hero = 24;
  static const double full = 9999;

  static final BorderRadius standardBorder = BorderRadius.circular(standard);
  static final BorderRadius cardBorder = BorderRadius.circular(card);
  static final BorderRadius heroBorder = BorderRadius.circular(hero);
  static final BorderRadius pillBorder = BorderRadius.circular(full);
}
