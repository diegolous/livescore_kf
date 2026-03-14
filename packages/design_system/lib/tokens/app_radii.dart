import 'package:flutter/material.dart';

abstract final class AppRadii {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double full = 9999.0;

  static final smBorder = BorderRadius.circular(sm);
  static final mdBorder = BorderRadius.circular(md);
  static final lgBorder = BorderRadius.circular(lg);
  static final xlBorder = BorderRadius.circular(xl);
  static final fullBorder = BorderRadius.circular(full);
}
