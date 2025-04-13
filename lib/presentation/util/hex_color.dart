import 'package:flutter/material.dart';

extension HexColor on Color {
  MaterialColor toMaterial() => MaterialColor(toARGB32(), {
    50: withTint(.9),
    100: withTint(.8),
    200: withTint(.6),
    300: withTint(.4),
    400: withTint(.2),
    500: this,
    600: withShade(.2),
    700: withShade(.4),
    800: withShade(.6),
    900: withShade(.8),
  });

  Color withTint(double value) {
    double calc(double channel) => channel + (1 - channel) * value;

    return Color.from(alpha: a, red: calc(r), green: calc(g), blue: calc(b));
  }

  Color withShade(double value) {
    double calc(double channel) => channel * (1 - value);

    return Color.from(alpha: a, red: calc(r), green: calc(g), blue: calc(b));
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Color invert() {
    final red = 1 - r;
    final green = 1 - g;
    final blue = 1 - b;
    return Color.from(alpha: a, red: red, green: green, blue: blue);
  }

  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${a.toInt().toRadixString(16).padLeft(2, '0')}'
      '${r.toInt().toRadixString(16).padLeft(2, '0')}'
      '${g.toInt().toRadixString(16).padLeft(2, '0')}'
      '${b.toInt().toRadixString(16).padLeft(2, '0')}';
}
