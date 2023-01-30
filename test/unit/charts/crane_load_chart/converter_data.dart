
import 'package:flutter/material.dart';
///
///              SWL COLORING (FAKE VALUES)
/// 
///     0.0   4631.56   11,387.42  18,555.321  20,000.0
/// 
///      |-------|---------|-----------|----------|
/// 
///      | GREEN | YELLOW  |   ORANGE  |    RED   |
const limitSet = [4631.56, 11387.42, 18555.321, 20000.0];
const first = Color(0x000001);
const second = Color(0x000002);
const third = Color(0x000002);
const forth = Color(0x000002);
const colorSet = [first, second, third, forth];
const height = 500.0;
const width = 500.0;
const converterData = [
  {
    'input_point': Offset(0, 0),
    'output_point': Offset(0, 500),
    'swl': [0.0, 20000.0],
    'color': [first, forth],
  },
  {
    'input_point': Offset(0, 1),
    'output_point': Offset(0, 499),
    'swl': [1234.12, 18556.99],
    'color': [first, forth],
  },
  {
    'input_point': Offset(1, 0),
    'output_point': Offset(1, 500),
    'swl': [4631.56, 18555.321],
    'color': [first, forth],
  },
  {
    'input_point': Offset(234.85, 154.4),
    'output_point': Offset(234.85, 345.6),
    'swl': [4631.57, 18555.32],
    'color': [second, third],
  },
  {
    'input_point': Offset(289.85, 305.4),
    'output_point': Offset(289.85, 194.6),
    'swl': [5678.456, 15678.432],
    'color': [second, third],
  },
  {
    'input_point': Offset(456.543095, 142.34878394),
    'output_point': Offset(456.543095, 357.65121606),
    'swl': [11387.41, 11387.42],
    'color': [second, third],
  },
  {
    'input_point': Offset(498.3434905, 346.345),
    'output_point': Offset(498.3434905, 153.655),
    'swl': [11387.42, 11387.41],
    'color': [third, second],
  },
  {
    'input_point': Offset(123.3434905, 456.345),
    'output_point': Offset(123.3434905, 43.655),
    'swl': [15678.432, 5678.456],
    'color': [third, second],
  },
  {
    'input_point': Offset(456.3578798, 123.3489),
    'output_point': Offset(456.3578798, 376.6511),
    'swl': [18555.32, 4631.56],
    'color': [third, second],
  },
  {
    'input_point': Offset(275.094045, 296.897599),
    'output_point': Offset(275.094045, 203.102401),
    'swl': [18555.321, 4631.55],
    'color': [forth, first],
  },
  {
    'input_point': Offset(355.094045, 253.897599),
    'output_point': Offset(355.094045, 246.102401),
    'swl': [18556.99, 1234.12],
    'color': [ forth, first],
  },
  {
    'input_point': Offset(179, 197),
    'output_point': Offset(179, 303),
    'swl': [20000.0, 0.0],
    'color': [forth, first],
  },
];