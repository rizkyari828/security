import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceEmbeddingModel {
  FaceEmbeddingModel({
    this.assetPath = 'assets/models/mobilefacenet.tflite',
    InterpreterOptions? options,
  }) : _options = options ?? (InterpreterOptions()..threads = 2);

  final String assetPath;
  final InterpreterOptions _options;

  Interpreter? _interpreter;
  List<int>? _inputShape;
  List<int>? _outputShape;

  Future<void> ensureLoaded() async {
    if (_interpreter != null) return;

    final modelData = await rootBundle.load(assetPath);
    final interpreter = Interpreter.fromBuffer(
      modelData.buffer.asUint8List(),
      options: _options,
    );
    _interpreter = interpreter;
    _inputShape = interpreter.getInputTensor(0).shape;
    _outputShape = interpreter.getOutputTensor(0).shape;
  }

  List<int> get inputShape {
    final shape = _inputShape;
    if (shape == null) {
      throw StateError('FaceEmbeddingModel not loaded');
    }
    return shape;
  }

  List<int> get outputShape {
    final shape = _outputShape;
    if (shape == null) {
      throw StateError('FaceEmbeddingModel not loaded');
    }
    return shape;
  }

  int get inputWidth => inputShape.length >= 3 ? inputShape[2] : 0;
  int get inputHeight => inputShape.length >= 3 ? inputShape[1] : 0;
  int get inputChannels => inputShape.length >= 4 ? inputShape[3] : 0;

  int get outputLength {
    final shape = outputShape;
    var length = 1;
    for (final v in shape) {
      length *= v;
    }
    return length;
  }

  Future<List<double>> embed(Float32List input) async {
    await ensureLoaded();
    final interpreter = _interpreter!;

    final expectedInputLen = inputWidth * inputHeight * inputChannels;
    if (expectedInputLen <= 0 || input.lengthInBytes != expectedInputLen * 4) {
      throw ArgumentError(
        'Unexpected input size. Got ${input.length}, expected $expectedInputLen.',
      );
    }

    final reshapedInput = input.toList(growable: false).reshape([
      1,
      inputHeight,
      inputWidth,
      inputChannels,
    ]);

    final output = List<double>.filled(outputLength, 0.0).reshape([
      1,
      outputLength,
    ]);
    interpreter.run(reshapedInput, output);

    final embedding = List<double>.from((output).first as List);
    return _l2Normalize(embedding);
  }

  List<double> _l2Normalize(List<double> v) {
    var sum = 0.0;
    for (final x in v) {
      sum += x * x;
    }
    final norm = math.sqrt(sum);
    if (norm == 0.0) return v;
    return v.map((x) => x / norm).toList(growable: false);
  }
}
