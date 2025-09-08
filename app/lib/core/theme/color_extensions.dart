import 'package:flutter/material.dart';

/// Hilfs-Extension als Ersatz für das deprecated `withOpacity`.
/// Nutzt `withValues(alpha: ...)` (Flutter 3.27+) für präzisere Alpha-Anpassung.
extension ColorAlphaX on Color {
  /// Erwartet einen Wert zwischen 0.0 und 1.0 und konvertiert zu 0-255.
  Color alphaFrac(double opacity) {
    assert(
      opacity >= 0 && opacity <= 1,
      'opacity muss zwischen 0 und 1 liegen – erhalten: $opacity',
    );
    return withValues(alpha: opacity);
  }
}
