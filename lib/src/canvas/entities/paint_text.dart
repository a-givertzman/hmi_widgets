import 'dart:ui';
import 'package:cronosun_text_to_path_maker/cronosun_text_to_path_maker.dart';
import 'package:hmi_widgets/src/canvas/entities/paint_character.dart';
import 'package:hmi_widgets/src/canvas/paint_item.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_item_transformations.dart';
import 'package:hmi_widgets/src/canvas/transformations/paint_logical.dart';
///
/// Declarative text drawing for [Canvas].
class PaintText implements PaintItem {
  final PMFont _font;
  final double _characterSpacing;
  final String _text;
  final Color _color;
  /// 
  /// Declarative text drawing for [Canvas].
  /// - [font] - loaded asset of font.
  /// - [text] - only letters and digits are supported. If font does not contain symbols - they will be skipped.
  /// - [color] - color of the [text]
  /// - [characterSpacing] - distance between characters.
  /// 
  /// Attention: can't draw symbols if [font] doesn't contain them!
  /// 
  /// Example:
  /// ```dart
  /// final fontAsset = await rootBundle.load("assets/font2.ttf");
  /// final font = PMFontReader().parseTTFAsset(fontAsset);
  /// PaintItems(
  ///   items: [
  ///     PaintText(
  ///       font: font,
  ///       text: 'test',
  ///       color: Colors.blue,
  ///     ),
  ///   ],
  /// );
  /// ```
  const PaintText({
    required PMFont font,
    required String text,
    required Color color,
    double characterSpacing = 0.0,
  }) :
    _color = color,
    _text = text,
    _font = font,
    _characterSpacing = characterSpacing;
  //
  @override
  Path path(Size size) {
    return _text.codeUnits.map<PaintItem>(
      (code) => PaintCharacter(
        characterCode: code,
        color: _color,
        font: _font,
      ),
    )
    .reduce(
      (text, additionalCaracter) => PaintLogical(
        [
          text,
          additionalCaracter.translate(
            Offset(
              text.path(size).getBounds().right + _characterSpacing,
              0.0,
            ),
          ),
        ],
        operation: PathOperation.union,
      ),
    )
    .path(size);
  }
  //
  @override
  Paint get brush => Paint()
    ..style = PaintingStyle.fill
    ..color = _color
    ..isAntiAlias = true;
}