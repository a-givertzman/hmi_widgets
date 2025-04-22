import 'dart:ui';
import 'package:cronosun_text_to_path_maker/cronosun_text_to_path_maker.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
/// [Canvas]-ready drawing of single character.
class PaintCharacter implements PaintItem {
  final PMFont _font;
  final int _characterCode;
  final Color _color;
  ///
  /// [Canvas]-ready drawing of single character.
  /// - [font] - loaded asset of font;
  /// - [characterCode] - character code from Unicode;
  /// - [color] - color of the character.
  ///
  /// Attention: can't draw symbols (periods, сommas etc.) if [font] doesn't contain them!
  /// 
  /// Example:
  /// ```dart
  /// final fontAsset = await rootBundle.load("assets/font2.ttf");
  /// final font = PMFontReader().parseTTFAsset(fontAsset);
  /// PaintItems(
  ///   items: [
  ///     PaintCharacter(
  ///       font: font,
  ///       characterCode: 65,
  ///       color: Colors.blue,
  ///     ),
  ///   ],
  /// );
  /// ```
  const PaintCharacter({
    required PMFont font,
    required int characterCode,
    required Color color,
  }) :
    _color = color,
    _characterCode = characterCode,
    _font = font;
  //
  @override
  Path path(Size size) => PMTransform.moveAndScale(
    _font.generatePathForCharacter(_characterCode),
    0,
    0,
    1/200,
    1/200,
  );
  //
  @override
  Paint get brush => Paint()
    ..style = PaintingStyle.fill
    ..color = _color
    ..isAntiAlias = true;
}