import 'package:flutter/material.dart';
import 'package:tracing_game/src/colors/phonetics_color.dart';
import 'package:tracing_game/src/phontics_constants/arabic_shape_paths_blue_unit.dart';
import 'package:tracing_game/src/phontics_constants/arabis_shape_paths.dart';
import 'package:tracing_game/src/phontics_constants/english_shape_path2.dart';
import 'package:tracing_game/src/phontics_constants/math_trace_shape_paths.dart';
import 'package:tracing_game/src/phontics_constants/numbers_svg.dart';
import 'package:tracing_game/src/phontics_constants/shape_paths.dart';
import 'package:tracing_game/src/phontics_constants/telugu_shape_paths.dart';
import 'package:tracing_game/src/points_manager/shape_points_manger.dart';
import 'package:tracing_game/src/tracing/model/trace_model.dart';
import 'package:tracing_game/tracing_game.dart';

class TypeExtensionTracking {
  ArabicLetters _detectTheCurrentEnum({required String letter}) {
    if (letter == 'هـ') {
      return ArabicLetters.heh1;
    } else if (letter == 'ه') {
      return ArabicLetters.heh2;
    } else if (letter == 'ن') {
      return ArabicLetters.non;
    } else if (letter == 'ق') {
      return ArabicLetters.qaf;
    } else if (letter == 'ش') {
      return ArabicLetters.shen;
    } else if (letter == 'ز') {
      return ArabicLetters.zen;
    } else if (letter == 'ذ') {
      return ArabicLetters.zal;
    } else if (letter == 'ض') {
      return ArabicLetters.dad;
    } else if (letter == 'غ') {
      return ArabicLetters.ghen;
    } else if (letter == 'ت') {
      return ArabicLetters.ta2;
    } else if (letter == 'ك') {
      return ArabicLetters.kaf;
    } else if (letter == 'و') {
      return ArabicLetters.waw;
    } else if (letter == 'ظ') {
      return ArabicLetters.tha2;
    } else if (letter == 'د') {
      return ArabicLetters.dal;
    } else if (letter == 'ح') {
      return ArabicLetters.ha2;
    } else if (letter == 'ي') {
      return ArabicLetters.ya2;
    } else if (letter == 'ص') {
      return ArabicLetters.sad;
    } else if (letter == 'ث') {
      return ArabicLetters.theh;
    } else if (letter == 'خ') {
      return ArabicLetters.kha2;
    } else if (letter == 'أ') {
      return ArabicLetters.alf;
    } else if (letter == 'ط') {
      return ArabicLetters.tah;
    } else if (letter == 'ع') {
      return ArabicLetters.ein;
    } else if (letter == 'م') {
      return ArabicLetters.mem;
    } else if (letter == 'ف') {
      return ArabicLetters.fa2;
    } else if (letter == 'ج') {
      return ArabicLetters.gem;
    } else if (letter == 'س') {
      return ArabicLetters.sen;
    } else if (letter == 'ل') {
      return ArabicLetters.lam;
    } else if (letter == 'ر') {
      return ArabicLetters.ra2;
    } else if (letter == 'ب') {
      return ArabicLetters.ba2;
    } else {
      throw Exception('Unsupported character type for tracing.');
    }
  }

  PhonicsLetters _detectTheCurrentEnumFromPhonics({required String letter}) {
    if (letter == 'a') {
      return PhonicsLetters.a;
    } else if (letter == 'q') {
      return PhonicsLetters.q;
    } else if (letter == 'w') {
      return PhonicsLetters.w;
    } else if (letter == 'e') {
      return PhonicsLetters.e;
    } else if (letter == 'r') {
      return PhonicsLetters.r;
    } else if (letter == 't') {
      return PhonicsLetters.t;
    } else if (letter == 'y') {
      return PhonicsLetters.y;
    } else if (letter == 'u') {
      return PhonicsLetters.u;
    } else if (letter == 'i') {
      return PhonicsLetters.i;
    } else if (letter == 'o') {
      return PhonicsLetters.o;
    } else if (letter == 'p') {
      return PhonicsLetters.p;
    } else if (letter == 's') {
      return PhonicsLetters.s;
    } else if (letter == 'd') {
      return PhonicsLetters.d;
    } else if (letter == 'f') {
      return PhonicsLetters.f;
    } else if (letter == 'g') {
      return PhonicsLetters.g;
    } else if (letter == 'h') {
      return PhonicsLetters.h;
    } else if (letter == 'j') {
      return PhonicsLetters.j;
    } else if (letter == 'k') {
      return PhonicsLetters.k;
    } else if (letter == 'l') {
      return PhonicsLetters.l;
    } else if (letter == 'z') {
      return PhonicsLetters.z;
    } else if (letter == 'x') {
      return PhonicsLetters.x;
    } else if (letter == 'c') {
      return PhonicsLetters.c;
    } else if (letter == 'v') {
      return PhonicsLetters.v;
    } else if (letter == 'b') {
      return PhonicsLetters.b;
    } else if (letter == 'n') {
      return PhonicsLetters.n;
    } else if (letter == 'm') {
      return PhonicsLetters.m;
    } else {
      throw Exception('Unsupported character type for tracing.');
    }
  }

  TeluguLetters _detectTheCurrentEnumFromTelugu({required String letter}) {
    if (letter == 'అ') {
      return TeluguLetters.a;
    } else if (letter == 'ఆ') {
      return TeluguLetters.aa;
    } else {
      throw Exception('Unsupported Telugu character type for tracing.');
    }
  }

  List<TraceModel> getTracingData({
    List<TraceCharModel>? chars,
    TraceWordModel? word,
    required StateOfTracing currentOfTracking,
    List<MathShapeWithOption>? geometryShapes,
  }) {
  
    List<TraceModel> tracingDataList = [];

    if (currentOfTracking == StateOfTracing.traceShapes) {
      tracingDataList
          .addAll(getListOfTracingDataMathShapes(shapes: geometryShapes!));
    } else if (currentOfTracking == StateOfTracing.traceWords) {
      tracingDataList.addAll(getTraceWords(wordWithOption: word!));
    } else if (currentOfTracking == StateOfTracing.chars) {
        if(chars==null){
      return [];
    }
      for (var char in chars) {
        final letters = char.char;

        // Detect the type of letter and add the corresponding tracing data
        if (_isArabicCharacter(letters)) {
          tracingDataList
              .addAll(_getTracingDataArabic(letter: letters).map((e)=>e.copyWith(
                    innerPaintColor: char.traceShapeOptions.innerPaintColor,
                    outerPaintColor: char.traceShapeOptions.outerPaintColor,
                    indexColor: char.traceShapeOptions.indexColor,
                    dottedColor: char.traceShapeOptions.dottedColor,
                  )));
        } else if (_isNumber(letters)) {
          tracingDataList
              .add(_getTracingDataNumbers(number: letters).first.copyWith(
                    innerPaintColor: char.traceShapeOptions.innerPaintColor,
                    outerPaintColor: char.traceShapeOptions.outerPaintColor,
                    indexColor: char.traceShapeOptions.indexColor,
                    dottedColor: char.traceShapeOptions.dottedColor,
                  ));
        } else if (_isPhonicsCharacter(letters)) {
          tracingDataList.add(
              _getTracingDataPhonics(letter: letters.toLowerCase())
                  .first
                  .copyWith(
                    innerPaintColor: char.traceShapeOptions.innerPaintColor,
                    outerPaintColor: char.traceShapeOptions.outerPaintColor,
                    indexColor: char.traceShapeOptions.indexColor,
                    dottedColor: char.traceShapeOptions.dottedColor,
                  ));
        } else if (_isUpperCasePhonicsCharacter(letters)) {
          final uppers =
              _getTracingDataPhonicsUp(letter: letters.toLowerCase());
          final newBigSizedUppers = uppers
              .map((up) => up.copyWith(letterViewSize: const Size(300, 300)))
              .toList();
          tracingDataList.add(newBigSizedUppers.first.copyWith(
            innerPaintColor: char.traceShapeOptions.innerPaintColor,
            outerPaintColor: char.traceShapeOptions.outerPaintColor,
            indexColor: char.traceShapeOptions.indexColor,
            dottedColor: char.traceShapeOptions.dottedColor,
          ));
        } else if (_isTeluguCharacter(letters)) {
          tracingDataList
              .addAll(_getTracingDataTelugu(letter: letters).map((e)=>e.copyWith(
                    innerPaintColor: char.traceShapeOptions.innerPaintColor,
                    outerPaintColor: char.traceShapeOptions.outerPaintColor,
                    indexColor: char.traceShapeOptions.indexColor,
                    dottedColor: char.traceShapeOptions.dottedColor,
                  )));
        } else {
          throw Exception('Unsupported character type for tracing.');
        }
      }
    } else {
      throw Exception('Unknown StateOfTracing value');
    }

    return tracingDataList; // Return the combined tracing data list
  }

// Helper functions to detect the type of letter

  bool _isArabicCharacter(String letter) {
    // Check if the letter is an Arabic character (Unicode range)
    return RegExp(r'[\u0600-\u06FF]').hasMatch(letter);
  }

  bool _isNumber(String letter) {
    // Check if the letter is a number
    return RegExp(r'^(10|[0-9])$').hasMatch(letter);
  }

  bool _isPhonicsCharacter(String letter) {
    // Check if the letter is a valid phonics character (assuming it's A-Z or a-z)
    return RegExp(r'^[a-z]$').hasMatch(letter);
  }

  bool _isUpperCasePhonicsCharacter(String letter) {
    // Check if the letter is an uppercase phonics character
    return RegExp(r'^[A-Z]$').hasMatch(letter);
  }

  bool _isTeluguCharacter(String letter) {
    // Check if the letter is a Telugu character (Unicode range: 0C00-0C7F)
    return RegExp(r'[\u0C00-\u0C7F]').hasMatch(letter);
  }

  List<TraceModel> _getTracingDataNumbers({required String number}) {
    List<TraceModel> listOfTraceModel = [];

    switch (number) {
      case '1':
        listOfTraceModel.add(TraceModel(
            positionIndexPath: const Size(-12, -85),
            positionDottedPath: const Size(-31, 10),
            scaledottedPath: .8,
            scaleIndexPath: .1,
            dottedPath: NumberSvgs.shapeNumber1Dotted,
            indexPath: NumberSvgs.shapeNumber1Index,
            letterPath: NumberSvgs.shapeNumber1,
            indexPathPaintStyle: PaintingStyle.fill,
            dottedPathPaintStyle: PaintingStyle.stroke,
            pointsJsonFile: ShapePointsManger.number1,
            dottedColor: AppColorPhonetics.grey,
            indexColor: AppColorPhonetics.white,
            innerPaintColor: AppColorPhonetics.lightBlueColor6,
            outerPaintColor: AppColorPhonetics.lightBlueColor5));
        break;

      case '2':
        listOfTraceModel.add(TraceModel(
            positionIndexPath: const Size(-50, 20),
            positionDottedPath: const Size(0, -5),
            indexPathPaintStyle: PaintingStyle.fill,
            dottedPathPaintStyle: PaintingStyle.stroke,
            scaleIndexPath: .8,
            scaledottedPath: 1,
            dottedColor: AppColorPhonetics.grey,
            indexColor: AppColorPhonetics.white,
            dottedPath: NumberSvgs.shapeNumber2Dotted,
            indexPath: NumberSvgs.shapeNumber2Index,
            letterPath: NumberSvgs.shapeNumber2,
            pointsJsonFile: ShapePointsManger.number2,
            innerPaintColor: AppColorPhonetics.lightBlueColor6,
            outerPaintColor: AppColorPhonetics.lightBlueColor5));
        break;
      case '3':
        listOfTraceModel.add(TraceModel(
            positionIndexPath: const Size(-25, -30),
            positionDottedPath: const Size(-5, 0),
            indexPathPaintStyle: PaintingStyle.fill,
            dottedPathPaintStyle: PaintingStyle.stroke,
            scaleIndexPath: .4,
            scaledottedPath: .9,
            dottedColor: AppColorPhonetics.grey,
            indexColor: AppColorPhonetics.white,
            dottedPath: NumberSvgs.shapeNumber3Dotted,
            indexPath: NumberSvgs.shapeNumber3Index,
            letterPath: NumberSvgs.shapeNumber3,
            pointsJsonFile: ShapePointsManger.number3,
            innerPaintColor: AppColorPhonetics.lightBlueColor6,
            outerPaintColor: AppColorPhonetics.lightBlueColor5));
        break;
      case '4':
        listOfTraceModel.add(TraceModel(
            positionIndexPath: const Size(-10, -33),
            positionDottedPath: const Size(-3, -10),
            scaledottedPath: .85,
            disableDividedStrokes: true,
            scaleIndexPath: .66,
            dottedColor: AppColorPhonetics.grey,
            indexColor: AppColorPhonetics.white,
            dottedPath: NumberSvgs.shapeNumber4Dotted,
            indexPath: NumberSvgs.shapeNumber4Index,
            letterPath: NumberSvgs.shapeNumber4,
            indexPathPaintStyle: PaintingStyle.fill,
            dottedPathPaintStyle: PaintingStyle.stroke,
            strokeWidth: 35,
            // distanceToCheck: 10,
            pointsJsonFile: ShapePointsManger.number4,
            innerPaintColor: AppColorPhonetics.lightBlueColor6,
            outerPaintColor: AppColorPhonetics.lightBlueColor5));
        break;
      case '5':
        listOfTraceModel.add(TraceModel(
            positionIndexPath: const Size(-30, -50),
            positionDottedPath: const Size(-5, 0),
            indexPathPaintStyle: PaintingStyle.fill,
            dottedPathPaintStyle: PaintingStyle.stroke,
            scaleIndexPath: .5,
            scaledottedPath: .95,
            dottedColor: AppColorPhonetics.grey,
            indexColor: AppColorPhonetics.white,
            dottedPath: NumberSvgs.shapeNumber5Dotted,
            indexPath: NumberSvgs.shapeNumber5Index,
            letterPath: NumberSvgs.shapeNumber5,
            pointsJsonFile: ShapePointsManger.number5,
            innerPaintColor: AppColorPhonetics.lightBlueColor6,
            outerPaintColor: AppColorPhonetics.lightBlueColor5));
        break;
      case '6':
        listOfTraceModel.add(TraceModel(
            positionIndexPath: const Size(5, -90),
            positionDottedPath: const Size(-5, 0),
            indexPathPaintStyle: PaintingStyle.fill,
            dottedPathPaintStyle: PaintingStyle.stroke,
            scaleIndexPath: .1,
            scaledottedPath: .9,
            dottedColor: AppColorPhonetics.grey,
            indexColor: AppColorPhonetics.white,
            dottedPath: NumberSvgs.shapeNumber6Dotted,
            indexPath: NumberSvgs.shapeNumber6Index,
            letterPath: NumberSvgs.shapeNumber6,
            pointsJsonFile: ShapePointsManger.number6,
            innerPaintColor: AppColorPhonetics.lightBlueColor6,
            outerPaintColor: AppColorPhonetics.lightBlueColor5));
        break;
      case '7':
        listOfTraceModel.add(TraceModel(
            positionIndexPath: const Size(0, -90),
            positionDottedPath: const Size(0, -5),
            scaledottedPath: .9,
            scaleIndexPath: .6,
            dottedColor: AppColorPhonetics.grey,
            indexColor: AppColorPhonetics.white,
            dottedPath: NumberSvgs.shapeNumber7Dotted,
            indexPathPaintStyle: PaintingStyle.fill,
            dottedPathPaintStyle: PaintingStyle.stroke,
            indexPath: NumberSvgs.shapeNumber7Index,
            letterPath: NumberSvgs.shapeNumber7,
            strokeWidth: 45,
            pointsJsonFile: ShapePointsManger.number7,
            innerPaintColor: AppColorPhonetics.lightBlueColor6,
            outerPaintColor: AppColorPhonetics.lightBlueColor5));
        break;
      case '8':
        listOfTraceModel.add(TraceModel(
            positionIndexPath: const Size(50, -50),
            positionDottedPath: const Size(5, 0),
            indexPathPaintStyle: PaintingStyle.fill,
            dottedPathPaintStyle: PaintingStyle.stroke,
            scaleIndexPath: .07,
            scaledottedPath: 1,
            strokeWidth: 40,
            dottedColor: AppColorPhonetics.grey,
            indexColor: AppColorPhonetics.white,
            dottedPath: NumberSvgs.shapeNumber8Dotted,
            indexPath: NumberSvgs.shapeNumber8Index,
            letterPath: NumberSvgs.shapeNumber8,
            pointsJsonFile: ShapePointsManger.number8,
            innerPaintColor: AppColorPhonetics.lightBlueColor6,
            outerPaintColor: AppColorPhonetics.lightBlueColor5));
        break;
      case '9':
        listOfTraceModel.add(TraceModel(
            positionIndexPath: const Size(55, -30),
            positionDottedPath: const Size(0, -5),
            indexPathPaintStyle: PaintingStyle.fill,
            dottedPathPaintStyle: PaintingStyle.stroke,
            scaleIndexPath: .18,
            scaledottedPath: .9,
            strokeWidth: 45,
            dottedColor: AppColorPhonetics.grey,
            indexColor: AppColorPhonetics.white,
            dottedPath: NumberSvgs.shapeNumber9Dotted,
            indexPath: NumberSvgs.shapeNumber9Index,
            letterPath: NumberSvgs.shapeNumber9,
            pointsJsonFile: ShapePointsManger.number9,
            innerPaintColor: AppColorPhonetics.lightBlueColor6,
            outerPaintColor: AppColorPhonetics.lightBlueColor5));
        break;
      case '10':
        listOfTraceModel.add(
          TraceModel(
              positionIndexPath: const Size(-28, -90),
              positionDottedPath: const Size(-3, 0),
              scaledottedPath: .9,
              scaleIndexPath: .55,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              dottedPath: NumberSvgs.shapeNumber10Dotted,
              indexPath: NumberSvgs.shapeNumber10Index,
              letterPath: NumberSvgs.shapeNumber10,
              indexPathPaintStyle: PaintingStyle.fill,
              strokeWidth: 45,
              pointsJsonFile: ShapePointsManger.number10,
              innerPaintColor: AppColorPhonetics.lightBlueColor6,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        );
        break;
      case '0':
        listOfTraceModel.add(TraceModel(
            positionIndexPath: const Size(-10, -90),
            positionDottedPath: const Size(-5, -5),
            scaledottedPath: .9,
            scaleIndexPath: .08,
            indexPathPaintStyle: PaintingStyle.fill,
            dottedColor: AppColorPhonetics.grey,
            indexColor: AppColorPhonetics.white,
            dottedPath: NumberSvgs.shapeNumber0Dotted,
            indexPath: NumberSvgs.shapeNumber0Index,
            letterPath: NumberSvgs.shapeNumber0,
            pointsJsonFile: ShapePointsManger.number0,
            innerPaintColor: AppColorPhonetics.lightBlueColor6,
            outerPaintColor: AppColorPhonetics.lightBlueColor5));
        break;
    }

    return listOfTraceModel;
  }

  List<TraceModel> getListOfTracingDataMathShapes(
      {required List<MathShapeWithOption> shapes}) {
    List<TraceModel> traceModels = [];

    // Iterate over each MathShapes enum and generate a TraceModel for it
    for (var sh in shapes) {
      traceModels
          .add(getTracingDataMathShapes(currentLetter: sh.shape).first.copyWith(
                innerPaintColor: sh.traceShapeOptions.innerPaintColor,
                outerPaintColor: sh.traceShapeOptions.outerPaintColor,
                indexColor: sh.traceShapeOptions.indexColor,
                dottedColor: sh.traceShapeOptions.dottedColor,
              ));
    }

    return traceModels; // Return the list of enums
  }

  List<TraceModel> getTracingDataMathShapes(
      {required MathShapes currentLetter}) {
    switch (currentLetter) {
      case MathShapes.circle:
        final circ = TraceModel(
            letterViewSize: const Size(200, 200),
            positionIndexPath: const Size(100, -60),
            positionDottedPath: const Size(0, 0),
            scaledottedPath: .9,
            scaleIndexPath: .4,
            indexPathPaintStyle: PaintingStyle.stroke,
            dottedPath: MathTraceShapePaths.circleDottedPath,
            dottedColor: Colors.black,
            indexColor: AppColorPhonetics.grey,
            indexPath: MathTraceShapePaths.circleIndexPath,
            letterPath: MathTraceShapePaths.circleShapePath,
            strokeWidth: 30,
            strokeIndex: 1,
            pointsJsonFile: ShapePointsManger.mathCircleShape,
            innerPaintColor: AppColorPhonetics.lightBlueColor5,
            outerPaintColor: Colors.transparent);
        return [
          circ.copyWith(
            letterViewSize: const Size(200, 200),
          ),
        ];

      case MathShapes.rectangle:
        final rect = TraceModel(
            letterViewSize: const Size(200, 200),
            positionIndexPath: const Size(0, 15),
            positionDottedPath: const Size(10, -7),
            scaledottedPath: .95,
            scaleIndexPath: 1.4,
            indexPathPaintStyle: PaintingStyle.stroke,
            dottedPath: MathTraceShapePaths.rectangleDottedPath,
            dottedColor: Colors.black,
            indexColor: AppColorPhonetics.grey,
            indexPath: MathTraceShapePaths.rectangleIndexPath,
            letterPath: MathTraceShapePaths.rectangleShapePath,
            strokeWidth: 30,
            strokeIndex: 1,
            pointsJsonFile: ShapePointsManger.rectangleShape,
            innerPaintColor: AppColorPhonetics.lightBlueColor5,
            outerPaintColor: Colors.transparent);
        return [
          rect.copyWith(
            letterViewSize: const Size(160, 160),
          ),
        ];

      case MathShapes.triangle1:
        return [
          TraceModel(
              letterViewSize: const Size(150, 150),
              positionIndexPath: const Size(-5, 10),
              positionDottedPath: const Size(0, 3),
              scaledottedPath: .9,
              scaleIndexPath: 1.14,
              indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: MathTraceShapePaths.triangle1DottedPath,
              dottedColor: Colors.black,
              indexColor: AppColorPhonetics.grey,
              indexPath: MathTraceShapePaths.triangle1IndexPath,
              letterPath: MathTraceShapePaths.triangle1ShapePath,
              strokeWidth: 30,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.triangle1Shape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: Colors.transparent),
        ];

      case MathShapes.triangle2:
        return [
          TraceModel(
              letterViewSize: const Size(160, 160),
              positionIndexPath: const Size(5, 0),
              positionDottedPath: const Size(-5, 3),
              scaledottedPath: .85,
              scaleIndexPath: 1.1,
              indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: MathTraceShapePaths.triangle2DottedPath,
              dottedColor: Colors.black,
              indexColor: AppColorPhonetics.grey,
              indexPath: MathTraceShapePaths.triangle2IndexPath,
              letterPath: MathTraceShapePaths.triangle2ShapePath,
              strokeWidth: 30,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.triangle2Shape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: Colors.transparent),
        ];

      case MathShapes.triangle3:
        return [
          TraceModel(
              letterViewSize: const Size(180, 180),
              positionIndexPath: const Size(-8, 10),
              positionDottedPath: const Size(0, 3),
              scaledottedPath: .9,
              scaleIndexPath: 1.17,
              indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: MathTraceShapePaths.triangle3DottedPath,
              dottedColor: Colors.black,
              indexColor: AppColorPhonetics.grey,
              indexPath: MathTraceShapePaths.triangle3Index,
              letterPath: MathTraceShapePaths.triangle3ShapePath,
              strokeWidth: 40,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.triangle3Shape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: Colors.transparent),
        ];
      case MathShapes.triangle4:
        return [
          TraceModel(
              letterViewSize: const Size(150, 150),
              positionIndexPath: const Size(-10, 10),
              positionDottedPath: const Size(-5, 3),
              scaledottedPath: .85,
              scaleIndexPath: 1.25,
              indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: MathTraceShapePaths.triangle4DottedPath,
              dottedColor: Colors.black,
              indexColor: AppColorPhonetics.grey,
              indexPath: MathTraceShapePaths.triangle4IndexPath,
              letterPath: MathTraceShapePaths.triangle4ShapePath,
              strokeWidth: 35,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.triangle4Shape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: Colors.transparent),
        ];
    }
  }

  List<TraceModel> getTraceWords({
    required TraceWordModel wordWithOption,
    Size sizeOfLetter = const Size(500, 500),
  }) {
    List<TraceModel> letters = [];
    int i = 0;
    final word = wordWithOption.word;
    while (i < word.length) {
      if (word[i] == '1' && i + 1 < word.length && word[i + 1] == '0') {
        // Check if current character is '1' and next is '0' (treat it as 10)
        if (word[i] == '1' && word[i + 1] == '0') {
          letters.add(_getTracingDataNumbers(number: '10').first.copyWith(
                isSpace: (i + 2 < word.length &&
                    word[i + 2] == ' '), // Check if next character is a space
              ));
          i += 2; // Skip the next character (i + 1) since we've handled '10'
          continue;
        }
      }

      bool isNextSpace = (i + 1 < word.length) &&
          word[i + 1] == ' '; // Check if the next character is a space

      if (_isArabicCharacter(word[i])) {
        letters.add(_getTracingDataArabic(letter: word[i]).first.copyWith(
              isSpace: isNextSpace,
            ));
      } else if (_isNumber(word[i])) {
        letters.add(_getTracingDataNumbers(number: word[i]).first.copyWith(
              isSpace: isNextSpace,
            ));
      } else if (_isPhonicsCharacter(word[i])) {
        letters.add(_getTracingDataPhonics(letter: word[i].toLowerCase())
            .first
            .copyWith(
              isSpace: isNextSpace,
            ));
      } else if (_isUpperCasePhonicsCharacter(word[i])) {
        final uppers = _getTracingDataPhonicsUp(letter: word[i].toLowerCase());
        final newBigSizedUppers = uppers
            .map((up) => up.copyWith(letterViewSize: const Size(300, 300)))
            .first;
        letters.add(newBigSizedUppers.copyWith(isSpace: isNextSpace));
      }

      i++; // Move to the next character
    }

    return letters
        .map((e) => e.copyWith(
              innerPaintColor: wordWithOption.traceShapeOptions.innerPaintColor,
              outerPaintColor: wordWithOption.traceShapeOptions.outerPaintColor,
              indexColor: wordWithOption.traceShapeOptions.indexColor,
              dottedColor: wordWithOption.traceShapeOptions.dottedColor,
            ))
        .toList();
  }

  List<TraceModel> _getTracingDataArabic({required String letter}) {
    ArabicLetters currentLetter = _detectTheCurrentEnum(letter: letter);

    switch (currentLetter) {
      case ArabicLetters.heh2:
// heh 2
        return [
          TraceModel(
              positionIndexPath: const Size(5, 0),
              positionDottedPath: const Size(0, 15),
              scaledottedPath: .75,
              scaleIndexPath: 1.2,
              indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: ArabicShapePathBluUnit.heh3Dotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePathBluUnit.heh3Index,
              letterPath: ArabicShapePathBluUnit.heh3Shape,
              strokeWidth: 60,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.heh3,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(-5, -15),
              positionDottedPath: const Size(0, 0),
              scaledottedPath: .75,
              scaleIndexPath: 1.2,
              strokeIndex: 1,
              disableDividedStrokes: true,
              strokeWidth: 50,
              dottedPath: ArabicShapePathBluUnit.heh4Dotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePathBluUnit.heh4Index,
              letterPath: ArabicShapePathBluUnit.heh4Shape,
              pointsJsonFile: ShapePointsManger.heh4,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.heh1:
        return [
          TraceModel(
              positionIndexPath: const Size(10, 0),
              positionDottedPath: const Size(-5, 7),
              scaledottedPath: .85,
              scaleIndexPath: 1.2,
              strokeIndex: 1,
              disableDividedStrokes: true,
              strokeWidth: 45,
              dottedPath: ArabicShapePathBluUnit.heh1Dotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePathBluUnit.heh1Index,
              letterPath: ArabicShapePathBluUnit.heh1Shape,
              pointsJsonFile: ShapePointsManger.heh1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(10, -10),
              positionDottedPath: const Size(10, 0),
              scaledottedPath: .85,
              scaleIndexPath: 1.05,
              strokeIndex: 1,
              disableDividedStrokes: true,
              strokeWidth: 45,
              dottedPath: ArabicShapePathBluUnit.heh2Dotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePathBluUnit.heh2Index,
              letterPath: ArabicShapePathBluUnit.heh2Shape,
              pointsJsonFile: ShapePointsManger.heh2,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.non:
        return [
          TraceModel(
              positionIndexPath: const Size(5, 25),
              positionDottedPath: const Size(0, 15),
              scaledottedPath: .67,
              scaleIndexPath: 1,
              indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: ArabicShapePathBluUnit.nonBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePathBluUnit.nonBigShapeIndex,
              letterPath: ArabicShapePathBluUnit.nonBigShape,
              strokeWidth: 40,
              strokeIndex: 1,
              disableDividedStrokes: true,
              pointsJsonFile: ShapePointsManger.nonBigShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              disableDividedStrokes: true,
              positionIndexPath: const Size(20, 40),
              positionDottedPath: const Size(-5, 38),
              scaledottedPath: .65,
              scaleIndexPath: .8,
              strokeIndex: 1,
              strokeWidth: 45,
              dottedPath: ArabicShapePathBluUnit.nonSmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePathBluUnit.nonSmallIndex,
              letterPath: ArabicShapePathBluUnit.nonSmallShape,
              pointsJsonFile: ShapePointsManger.nonSmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.qaf:
        return [
          TraceModel(
              positionIndexPath: const Size(0, 20),
              positionDottedPath: const Size(0, 20),
              scaledottedPath: .67,
              scaleIndexPath: .9,
              strokeWidth: 35,
              disableDividedStrokes: true,
              distanceToCheck: 20,
              dottedPath: ArabicShapePathBluUnit.qaaaafBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePathBluUnit.qaaaafBigIndex,
              letterPath: ArabicShapePathBluUnit.qaaaafBigShape,
              pointsJsonFile: ShapePointsManger.qafBigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(20, 30),
              positionDottedPath: const Size(0, 30),
              scaledottedPath: .6,
              scaleIndexPath: .9,
              strokeWidth: 40,
              disableDividedStrokes: true,
              distanceToCheck: 20,
              dottedPath: ArabicShapePathBluUnit.qaafSmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePathBluUnit.qaaaafSmallIndex,
              letterPath: ArabicShapePathBluUnit.qaaaafSmallShape,
              pointsJsonFile: ShapePointsManger.qafSmallShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.shen:
        return [
          TraceModel(
              positionIndexPath: const Size(0, 25),
              positionDottedPath: const Size(0, 25),
              scaledottedPath: .95,
              scaleIndexPath: 1.2,
              disableDividedStrokes: true,
              strokeWidth: 28,
              distanceToCheck: 15,
              dottedPath: ArabicShapePaths.shenBigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.shenBigIndex,
              letterPath: ArabicShapePaths.shenBigShape,
              pointsJsonFile: ShapePointsManger.shenBigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(5, 25),
              positionDottedPath: const Size(0, 25),
              scaledottedPath: .95,
              scaleIndexPath: 1.1,
              strokeWidth: 30,
              distanceToCheck: 15,
              dottedPath: ArabicShapePaths.shenSmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.shenSmallIndex,
              strokeIndex: 1,
              disableDividedStrokes: true,
              letterPath: ArabicShapePaths.shenSmallShape,
              pointsJsonFile: ShapePointsManger.shenSmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.zen:
        return [
          TraceModel(
              strokeIndex: 1,
              dottedPath: ArabicShapePaths.zenDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.zenIndex,
              letterPath: ArabicShapePaths.zenBig,
              positionIndexPath: const Size(50, 40),
              positionDottedPath: const Size(15, 40),
              scaleIndexPath: .8,
              scaledottedPath: .55,
              pointsJsonFile: ShapePointsManger.zenBigShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.zal:
        return [
          TraceModel(
              positionIndexPath: const Size(30, 30),
              positionDottedPath: const Size(5, 25),
              scaledottedPath: .57,
              scaleIndexPath: .9,
              strokeWidth: 50,
              disableDividedStrokes: true,
              distanceToCheck: 40,
              dottedPath: ArabicShapePaths.zalDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.zalIndex,
              letterPath: ArabicShapePaths.zalBigShape,
              pointsJsonFile: ShapePointsManger.zalBigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.dad:
        return [
          TraceModel(
              dottedPath: ArabicShapePaths.dadBigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.dadBigIndex,
              letterPath: ArabicShapePaths.dadBigShape,
              strokeIndex: 1,
              strokeWidth: 30,
              positionIndexPath: const Size(5, 10),
              positionDottedPath: const Size(0, 15),
              scaleIndexPath: 1.1,
              scaledottedPath: .92,
              pointsJsonFile: ShapePointsManger.dadBigShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              dottedPath: ArabicShapePaths.dadSmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.dadSmallIndex,
              letterPath: ArabicShapePaths.dadSmallShape,
              positionIndexPath: const Size(15, 10),
              strokeIndex: 1,
              strokeWidth: 30,
              positionDottedPath: const Size(0, 15),
              scaleIndexPath: 1.1,
              scaledottedPath: .95,
              pointsJsonFile: ShapePointsManger.dadsmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.ghen:
        return [
          TraceModel(
              positionIndexPath: const Size(-18, 10),
              positionDottedPath: const Size(0, 15),
              scaledottedPath: .75,
              scaleIndexPath: .85,
              strokeWidth: 33,
              dottedPath: ArabicShapePaths.ghenBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.ghenBigIndex,
              letterPath: ArabicShapePaths.ghenBigShape,
              pointsJsonFile: ShapePointsManger.ghenbigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(30, 35),
              positionDottedPath: const Size(5, 30),
              scaledottedPath: .75,
              scaleIndexPath: .9,
              strokeWidth: 45,
              dottedPath: ArabicShapePaths.ghenSmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.ghenSmallIndex,
              letterPath: ArabicShapePaths.ghenSmallShape,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.ghensmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.ta2:
        return [
          TraceModel(
              positionIndexPath: const Size(10, 25),
              positionDottedPath: const Size(5, 15),
              scaledottedPath: .93,
              scaleIndexPath: 1.1,
              indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: ArabicShapePaths.ta2BigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.ta2BigIndex,
              letterPath: ArabicShapePaths.ta2BigShape,
              strokeWidth: 35,
              strokeIndex: 1,
              disableDividedStrokes: true,
              pointsJsonFile: ShapePointsManger.ta2BigShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              disableDividedStrokes: true,
              positionIndexPath: const Size(50, 40),
              positionDottedPath: const Size(5, 30),
              scaledottedPath: .82,
              scaleIndexPath: .8,
              strokeIndex: 1,
              strokeWidth: 45,
              dottedPath: ArabicShapePaths.ta2SmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.ta2SmallIndex,
              letterPath: ArabicShapePaths.ta2SmalShape,
              pointsJsonFile: ShapePointsManger.ta2SmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.gem:
        return [
          TraceModel(
              positionIndexPath: const Size(-10, -18),
              positionDottedPath: const Size(0, -5),
              scaledottedPath: .9,
              scaleIndexPath: .92,
              indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: ArabicShapePaths.gemDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.gemIndex,
              letterPath: ArabicShapePaths.gemmm,
              strokeWidth: 40,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.gemShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(0, -30),
              positionDottedPath: const Size(-5, -15),
              scaledottedPath: .8,
              scaleIndexPath: .9,
              strokeIndex: 1,

              // strokeWidth: ,
              dottedPath: ArabicShapePaths.gemsmallDoottedPath,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.gemSmallIndexPath,
              letterPath: ArabicShapePaths.gemSmall2,
              pointsJsonFile: ShapePointsManger.gemSmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.kaf:
        return [
          TraceModel(
              positionIndexPath: const Size(0, 20),
              positionDottedPath: const Size(8, 20),
              scaledottedPath: .8,
              scaleIndexPath: 1.05,
              strokeWidth: 45,
              disableDividedStrokes: true,
              distanceToCheck: 20,
              dottedPath: ArabicShapePaths.kafBigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.kafBigIndex,
              letterPath: ArabicShapePaths.kafBigshape,
              pointsJsonFile: ShapePointsManger.kafBigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(0, 0),
              positionDottedPath: const Size(-10, 0),
              scaledottedPath: .9,
              scaleIndexPath: 1.15,
              strokeWidth: 40,
              disableDividedStrokes: true,
              distanceToCheck: 20,
              dottedPath: ArabicShapePaths.kafSmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.kafSmallIndex,
              letterPath: ArabicShapePaths.kafSmallshape,
              pointsJsonFile: ShapePointsManger.kafSmallShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.waw:
        return [
          TraceModel(
              positionIndexPath: const Size(15, -5),
              positionDottedPath: const Size(5, 5),
              scaledottedPath: .9,
              scaleIndexPath: 1.15,
              strokeWidth: 40,
              disableDividedStrokes: true,
              distanceToCheck: 40,
              dottedPath: ArabicShapePaths.wawDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.wawIndex,
              letterPath: ArabicShapePaths.wawBigShape,
              pointsJsonFile: ShapePointsManger.wawBigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.tha2:
        return [
          TraceModel(
              positionIndexPath: const Size(20, 20),
              positionDottedPath: const Size(20, 15),
              scaledottedPath: .75,
              scaleIndexPath: .9,
              strokeWidth: 40,
              disableDividedStrokes: true,
              distanceToCheck: 40,
              dottedPath: ArabicShapePaths.tha2Dotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.tha2Index,
              letterPath: ArabicShapePaths.tha2BigShape,
              pointsJsonFile: ShapePointsManger.tha2BigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.dal:
        return [
          TraceModel(
              positionIndexPath: const Size(40, 0),
              positionDottedPath: const Size(5, 10),
              scaledottedPath: .85,
              scaleIndexPath: 1.1,
              strokeWidth: 50,
              disableDividedStrokes: true,
              distanceToCheck: 45,
              dottedPath: ArabicShapePaths.dalDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.dalBigIndex,
              letterPath: ArabicShapePaths.dalBigshape,
              pointsJsonFile: ShapePointsManger.dalBigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.ha2:
        return [
          TraceModel(
              positionIndexPath: const Size(-10, -20),
              positionDottedPath: const Size(-10, -2),
              scaledottedPath: .87,
              scaleIndexPath: .9,
              strokeWidth: 35,
              disableDividedStrokes: true,
              distanceToCheck: 20,
              dottedPath: ArabicShapePaths.ha2Dotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.ha2Index,
              letterPath: ArabicShapePaths.ha2Bigshape,
              pointsJsonFile: ShapePointsManger.ha2BigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(0, 0),
              positionDottedPath: const Size(0, 5),
              scaledottedPath: .87,
              scaleIndexPath: .9,
              strokeWidth: 35,
              disableDividedStrokes: true,
              distanceToCheck: 20,
              dottedPath: ArabicShapePaths.ha2SmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.ha2SmallIndex,
              letterPath: ArabicShapePaths.ha2SmallShape,
              pointsJsonFile: ShapePointsManger.ha2SmallShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.ya2:
        return [
          TraceModel(
              positionIndexPath: const Size(25, -28),
              positionDottedPath: const Size(0, -24),
              scaledottedPath: .67,
              scaleIndexPath: .92,
              strokeWidth: 40,
              distanceToCheck: 20,
              dottedPath: ArabicShapePaths.ya2BigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.ya2BigIndex,
              letterPath: ArabicShapePaths.ya2Big,
              pointsJsonFile: ShapePointsManger.ya2bigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              distanceToCheck: 30,
              positionIndexPath: const Size(33, -40),
              positionDottedPath: const Size(10, -40),
              scaledottedPath: .67,
              scaleIndexPath: .8,
              strokeWidth: 50,
              dottedPath: ArabicShapePaths.ya2SmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.ya2SmallIndex,
              strokeIndex: 1,
              letterPath: ArabicShapePaths.ya2Small,
              pointsJsonFile: ShapePointsManger.ya2smallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.sad:
        return [
          TraceModel(
              positionIndexPath: const Size(0, 0),
              positionDottedPath: const Size(0, 2),
              scaledottedPath: .92,
              scaleIndexPath: 1.1,
              strokeWidth: 28,
              dottedPath: ArabicShapePaths.sadBigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.sadBigIndex,
              letterPath: ArabicShapePaths.sadBigShape,
              pointsJsonFile: ShapePointsManger.sadBigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(15, -10),
              positionDottedPath: const Size(0, 2),
              scaledottedPath: .92,
              scaleIndexPath: 1,
              strokeWidth: 22,
              dottedPath: ArabicShapePaths.sadSmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.sadSmallIndex,
              strokeIndex: 1,
              disableDividedStrokes: true,
              letterPath: ArabicShapePaths.sadSmallShape,
              pointsJsonFile: ShapePointsManger.sadSmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.theh:
        return [
          TraceModel(
              positionIndexPath: const Size(8, 30),
              positionDottedPath: const Size(-2, 30),
              scaledottedPath: .9,
              scaleIndexPath: 1.1,
              distanceToCheck: 15,
              strokeWidth: 35,
              disableDividedStrokes: true,
              // indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: ArabicShapePaths.thehBigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.thehBigIndex,
              strokeIndex: 1,
              letterPath: ArabicShapePaths.thehBigShape,
              pointsJsonFile: ShapePointsManger.thehBigShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              disableDividedStrokes: true,
              positionIndexPath: const Size(40, 45),
              positionDottedPath: const Size(5, 45),
              scaledottedPath: .7,
              scaleIndexPath: .72,
              distanceToCheck: 15,
              strokeWidth: 42,

              // indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: ArabicShapePaths.thehSmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.thehSmallIndex,
              letterPath: ArabicShapePaths.thehSmall,
              pointsJsonFile: ShapePointsManger.thehSmallShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.kha2:
        return [
          TraceModel(
              positionIndexPath: const Size(-5, 5),
              positionDottedPath: const Size(-3, 20),
              scaledottedPath: .68,
              scaleIndexPath: .72,
              distanceToCheck: 40,
              strokeWidth: 40,
              // indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: ArabicShapePaths.khahBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.khahBigIndex,
              letterPath: ArabicShapePaths.khahBigShape,
              pointsJsonFile: ShapePointsManger.khahBigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(30, 20),
              positionDottedPath: const Size(20, 35),
              scaledottedPath: .75,
              scaleIndexPath: .72,
              distanceToCheck: 40,
              strokeWidth: 40,
              // indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: ArabicShapePaths.khahSmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              strokeIndex: 1.1,
              indexPath: ArabicShapePaths.khahSmallIndex,
              letterPath: ArabicShapePaths.khahSmallShape,
              pointsJsonFile: ShapePointsManger.khahSmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.alf:
        return [
          TraceModel(
              positionIndexPath: const Size(12, -10),
              positionDottedPath: const Size(16, -5),
              scaledottedPath: .9,
              scaleIndexPath: 1.05,
              strokeWidth: 30,
              distanceToCheck: 20,
              dottedPath: ArabicShapePaths.alefDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.alefIndex,
              letterPath: ArabicShapePaths.alefBig,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.alefBigShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.tah:
        return [
          TraceModel(
              disableDividedStrokes: true,
              positionIndexPath: const Size(25, 25),
              positionDottedPath: const Size(16, 15),
              scaledottedPath: .75,
              scaleIndexPath: .9,
              strokeWidth: 45,
              dottedPath: ArabicShapePaths.tahBigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.tahBigIndex,
              letterPath: ArabicShapePaths.tahBig,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.tahBigShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.ein:
        return [
          TraceModel(
              positionIndexPath: const Size(-25, -10),
              positionDottedPath: const Size(-3, 0),
              scaledottedPath: .9,
              scaleIndexPath: 1.05,
              strokeWidth: 33,
              dottedPath: ArabicShapePaths.einBigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.einBigIndex,
              letterPath: ArabicShapePaths.enBigShape,
              pointsJsonFile: ShapePointsManger.einbigShape,
              strokeIndex: 1,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(10, 0),
              positionDottedPath: const Size(0, 0),
              scaledottedPath: .8,
              scaleIndexPath: .9,
              strokeWidth: 45,
              dottedPath: ArabicShapePaths.einSmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.einSmallIndex,
              letterPath: ArabicShapePaths.enSmall,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.einsmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.mem:
        return [
          TraceModel(
              positionIndexPath: const Size(10, 0),
              positionDottedPath: const Size(0, -5),
              scaledottedPath: .85,
              strokeWidth: 35,
              scaleIndexPath: 1.1,
              dottedPath: ArabicShapePaths.memBigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.memBigIndex,
              letterPath: ArabicShapePaths.memBig,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.membigShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(5, 0),
              positionDottedPath: const Size(5, 0),
              scaledottedPath: .8,
              scaleIndexPath: 1,
              dottedPath: ArabicShapePaths.memSmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.memsmallIndex,
              letterPath: ArabicShapePaths.memSmall,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.memsmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case ArabicLetters.fa2:
        return [
          TraceModel(
              positionIndexPath: const Size(50, 30),
              positionDottedPath: const Size(-2, 27),
              scaledottedPath: .9,
              scaleIndexPath: .8,
              strokeWidth: 40,
              dottedPath: ArabicShapePaths.fa2BigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.fa2BigIndex,
              letterPath: ArabicShapePaths.fa2Big,
              pointsJsonFile: ShapePointsManger.fa2bigShape,
              strokeIndex: 1,
              disableDividedStrokes: true,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              positionIndexPath: const Size(10, 30),
              positionDottedPath: const Size(-2, 27),
              scaledottedPath: .6,
              scaleIndexPath: .85,
              strokeWidth: 50,
              dottedPath: ArabicShapePaths.fa2smallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.fa2SmallIndex,
              letterPath: ArabicShapePaths.fa2Small,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.fa2smallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.lam:
        return [
          TraceModel(
              strokeIndex: 1,
              dottedPath: ArabicShapePaths.lamBigDottted2,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.lamBigIndex2,
              positionIndexPath: const Size(20, 10),
              positionDottedPath: const Size(15, 20),
              // scaleIndexPath: ,
              scaledottedPath: .75,
              letterPath: ArabicShapePaths.lambig2,
              pointsJsonFile: ShapePointsManger.lamBigShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              strokeIndex: 1,
              dottedPath: ArabicShapePaths.lamSmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.lamSmallIndex,
              indexPathPaintStyle: PaintingStyle.stroke,
              letterPath: ArabicShapePaths.lamsmall,
              positionIndexPath: const Size(20, 25),
              positionDottedPath: const Size(5, 15),
              scaledottedPath: .7,
              pointsJsonFile: ShapePointsManger.lamsmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.ra2:
        return [
          TraceModel(
              strokeIndex: 1,
              dottedPath: ArabicShapePaths.ra2Dotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.ra2Index,
              letterPath: ArabicShapePaths.ra2,
              positionIndexPath: const Size(45, 10),
              positionDottedPath: const Size(5, 5),
              scaleIndexPath: 1.1,
              scaledottedPath: .8,
              pointsJsonFile: ShapePointsManger.ra2Shape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.ba2:
        return [
          TraceModel(
              strokeIndex: 1,
              dottedPath: ArabicShapePaths.ba2BigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.ba2BigIndex,
              letterPath: ArabicShapePaths.ba2BigShape,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPathPaintStyle: PaintingStyle.stroke,
              positionIndexPath: const Size(5, -30),
              positionDottedPath: const Size(5, -30),
              scaleIndexPath: 1,
              scaledottedPath: .75,
              pointsJsonFile: ShapePointsManger.ba2BigShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              strokeIndex: 1,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: ArabicShapePaths.ba2SmallDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.ba2SmallIndex,
              letterPath: ArabicShapePaths.smallBa2Shape,
              positionIndexPath: const Size(35, -34),
              positionDottedPath: const Size(5, -30),
              scaleIndexPath: .85,
              scaledottedPath: .7,
              pointsJsonFile: ShapePointsManger.ba2SmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case ArabicLetters.sen:
        return [
          TraceModel(
              dottedPath: ArabicShapePaths.senBigDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.senBigIndex,
              letterPath: ArabicShapePaths.senBig,
              strokeIndex: 1,
              positionIndexPath: const Size(5, 5),
              positionDottedPath: const Size(0, 5),
              scaleIndexPath: 1.1,
              scaledottedPath: .92,
              pointsJsonFile: ShapePointsManger.senBigShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
          TraceModel(
              dottedPath: ArabicShapePaths.senDotted3,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ArabicShapePaths.senIndex2,
              letterPath: ArabicShapePaths.sen2Small,
              positionIndexPath: const Size(5, 0),
              strokeIndex: 1,
              positionDottedPath: const Size(0, 5),
              scaleIndexPath: 1.1,
              scaledottedPath: .95,
              pointsJsonFile: ShapePointsManger.sensmallShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
    }
  }

  List<TraceModel> _getTracingDataPhonics(
      {required String letter, Size sizeOfLetter = const Size(200, 200)}) {
    PhonicsLetters currentLetter =
        _detectTheCurrentEnumFromPhonics(letter: letter);

    switch (currentLetter) {
      case PhonicsLetters.n:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              dottedPath: EnglishShapePaths2.nlowerShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.nlowerShapeIndex,
              strokeWidth: 70,
              disableDividedStrokes: true,
              scaleIndexPath: .3,
              positionDottedPath: const Size(0, 0),
              positionIndexPath: const Size(-50, -65),
              scaledottedPath: .75,
              letterPath: EnglishShapePaths2.nlowerShape,
              pointsJsonFile: ShapePointsManger.nLowerShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.e:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              dottedPath: EnglishShapePaths2.eLowerShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.eLowerShapeIndex,
              strokeWidth: 70,
              disableDividedStrokes: true,
              scaleIndexPath: .12,
              positionDottedPath: const Size(0, 0),
              positionIndexPath: const Size(-20, -5),
              scaledottedPath: .75,
              letterPath: EnglishShapePaths2.eLowerShape,
              pointsJsonFile: ShapePointsManger.eLowerShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.w:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.fill,
              dottedPath: EnglishShapePaths2.wBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.wBigShapeIndex,
              strokeWidth: 68,
              disableDividedStrokes: true,
              scaleIndexPath: .65,
              positionDottedPath: const Size(0, 10),
              positionIndexPath: const Size(-20, 5),
              scaledottedPath: .75,
              letterPath: EnglishShapePaths2.wBigShape,
              pointsJsonFile: ShapePointsManger.wUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.d:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              dottedPath: EnglishShapePaths2.dLowerShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.dLowerShapeIndex,
              strokeWidth: 65,
              scaleIndexPath: .35,
              positionDottedPath: const Size(0, 10),
              positionIndexPath: const Size(30, -60),
              scaledottedPath: .85,
              letterPath: EnglishShapePaths2.dLowerShape,
              pointsJsonFile: ShapePointsManger.dlowerShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case PhonicsLetters.o:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.fill,
              dottedPath: EnglishShapePaths2.oShapeBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.oShapeBigShapeIndex,
              strokeWidth: 60,
              scaleIndexPath: .15,
              positionDottedPath: const Size(5, 0),
              positionIndexPath: const Size(-10, -70),
              scaledottedPath: .85,
              letterPath: EnglishShapePaths2.oShapeBigShape,
              pointsJsonFile: ShapePointsManger.oUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.g:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              dottedPath: EnglishShapePaths2.gLowrShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.gLowrShapeIndex,
              strokeWidth: 60,
              scaleIndexPath: .2,
              positionIndexPath: const Size(40, -75),
              positionDottedPath: const Size(0, 0),
              scaledottedPath: .8,
              letterPath: EnglishShapePaths2.gLowrShape,
              pointsJsonFile: ShapePointsManger.glowerShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.f:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              dottedPath: EnglishShapePaths2.fLowerShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.fLowerShapeIndex,
              strokeWidth: 45,
              scaleIndexPath: .4,
              positionIndexPath: const Size(10, -55),
              positionDottedPath: const Size(10, 0),
              scaledottedPath: .8,
              letterPath: EnglishShapePaths2.fLowerShape,
              pointsJsonFile: ShapePointsManger.flowerShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.b:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              dottedPath: EnglishShapePaths2.blowerShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.blowerShapeIndex,
              strokeWidth: 50,
              scaleIndexPath: .4,
              positionIndexPath: const Size(-30, -55),
              positionDottedPath: const Size(0, 10),
              scaledottedPath: .8,
              letterPath: EnglishShapePaths2.blowerShape,
              pointsJsonFile: ShapePointsManger.blowerShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.l:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: EnglishShapePaths2.lLowerShapeDotted,
              strokeWidth: 90,
              disableDividedStrokes: true,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.fill,
              indexPath: EnglishShapePaths2.lLowerShapeIndex,
              scaleIndexPath: .1,
              scaledottedPath: .93,
              positionIndexPath: const Size(0, -55),
              positionDottedPath: const Size(5, 0),
              letterPath: EnglishShapePaths2.lLowerShape,
              pointsJsonFile: ShapePointsManger.llowerShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5)
        ];

      case PhonicsLetters.u:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: EnglishShapePaths2.uLowerShapeDotted,
              strokeWidth: 80,
              disableDividedStrokes: true,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPath: EnglishShapePaths2.uLowerShapeIndex,
              scaleIndexPath: .7,
              scaledottedPath: .8,
              positionIndexPath: const Size(0, -70),
              positionDottedPath: const Size(0, 10),
              letterPath: EnglishShapePaths2.uLowerShape,
              pointsJsonFile: ShapePointsManger.ulowerShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case PhonicsLetters.j:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: EnglishShapePaths2.jlowerShapeDotetd,
              strokeWidth: 50,
              disableDividedStrokes: true,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPath: EnglishShapePaths2.jlowerShapeIndex,
              scaleIndexPath: .3,
              scaledottedPath: .65,
              positionIndexPath: const Size(22, -65),
              positionDottedPath: const Size(0, 25),
              letterPath: EnglishShapePaths2.jlowerShape,
              pointsJsonFile: ShapePointsManger.jlowerShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case PhonicsLetters.h:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: EnglishShapePaths2.hLowerShapeDotted,
              strokeWidth: 50,
              disableDividedStrokes: true,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPath: EnglishShapePaths2.hlowerShapeIndex,
              scaleIndexPath: .45,
              scaledottedPath: .85,
              positionIndexPath: const Size(-40, -45),
              positionDottedPath: const Size(0, 10),
              letterPath: EnglishShapePaths2.hLoweCaseShape,
              pointsJsonFile: ShapePointsManger.hlowerShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case PhonicsLetters.s:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.fill,
              dottedPath: ShapePaths.sDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ShapePaths.sIndex,
              strokeWidth: 75,
              scaleIndexPath: .65,
              positionIndexPath: const Size(-10, 0),
              scaledottedPath: .8,
              letterPath: ShapePaths.s3,
              pointsJsonFile: ShapePointsManger.sShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5)
        ];
      case PhonicsLetters.a:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: ShapePaths.aDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ShapePaths.aIndex,
              dottedPathPaintStyle: PaintingStyle.fill,
              indexPathPaintStyle: PaintingStyle.fill,
              scaleIndexPath: .3,
              positionIndexPath: const Size(50, -60),
              scaledottedPath: .8,
              letterPath: ShapePaths.aShape,
              strokeWidth: 67,
              pointsJsonFile: ShapePointsManger.aShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5)
        ];
      case PhonicsLetters.m:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: ShapePaths.mDotted,
              strokeWidth: 65,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ShapePaths.mIndex,
              indexPathPaintStyle: PaintingStyle.fill,
              scaleIndexPath: .6,
              scaledottedPath: .8,
              positionIndexPath: const Size(-30, -50),
              letterPath: ShapePaths.mshape,
              pointsJsonFile: ShapePointsManger.mShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.k:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: ShapePaths.kshapeDotted,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              positionIndexPath: const Size(-25, -30),
              positionDottedPath: const Size(-10, 10),
              strokeWidth: 70,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: ShapePaths.kshapeIndex,
              scaleIndexPath: .6,
              scaledottedPath: .8,
              letterPath: ShapePaths.kshape,
              pointsJsonFile: ShapePointsManger.kShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.q:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: ShapePaths.qshapeDotted,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPathPaintStyle: PaintingStyle.fill,
              positionIndexPath: const Size(40, -80),
              strokeWidth: 50,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: ShapePaths.qshapeIndex,
              scaleIndexPath: .2,
              scaledottedPath: .8,
              letterPath: ShapePaths.qshape,
              pointsJsonFile: ShapePointsManger.qShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.v:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: ShapePaths.vShapeDotted,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.fill,
              positionIndexPath: const Size(-30, -0),
              strokeWidth: 52,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: ShapePaths.vShapeIndex,
              scaleIndexPath: .9,
              scaledottedPath: .8,
              letterPath: ShapePaths.vshape,
              pointsJsonFile: ShapePointsManger.vShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.x:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: ShapePaths.xDotted,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.fill,
              positionIndexPath: const Size(-0, -75),
              strokeWidth: 57,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: ShapePaths.xIndex,
              scaleIndexPath: .7,
              scaledottedPath: .8,
              disableDividedStrokes: true,
              letterPath: ShapePaths.xShape,
              pointsJsonFile: ShapePointsManger.xShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.y:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: ShapePaths.yshapeDotted,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.fill,
              positionIndexPath: const Size(-0, -65),
              strokeWidth: 60,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: ShapePaths.yShapeIndex,
              scaleIndexPath: .6,
              scaledottedPath: .75,
              letterPath: ShapePaths.yshape,
              pointsJsonFile: ShapePointsManger.yShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.z:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: ShapePaths.zShapeDotted,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.fill,
              positionIndexPath: const Size(0, 0),
              strokeWidth: 75,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: ShapePaths.zShapeIndex,
              scaleIndexPath: .7,
              scaledottedPath: .8,
              letterPath: ShapePaths.zShape,
              pointsJsonFile: ShapePointsManger.zShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.t:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: ShapePaths.tshapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: ShapePaths.tshapeIndex,
              letterPath: ShapePaths.tShape,
              strokeWidth: 50,
              scaledottedPath: .8,
              scaleIndexPath: .33,
              positionDottedPath: const Size(2, 10),
              positionIndexPath: const Size(-30, -60),
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPathPaintStyle: PaintingStyle.fill,
              pointsJsonFile: ShapePointsManger.tShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.c:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.fill,
              dottedPath: ShapePaths.cshapeDoted,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: ShapePaths.cshapeIndex,
              strokeWidth: 50,
              scaleIndexPath: .1,
              positionIndexPath: const Size(140, -25),
              positionDottedPath: const Size(5, 0),
              scaledottedPath: .9,
              letterPath: ShapePaths.cshaped,
              pointsJsonFile: ShapePointsManger.cShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.r:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: ShapePaths.rShapeDotted,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.fill,
              strokeWidth: 70,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: ShapePaths.rshapeIndex,
              scaleIndexPath: .5,
              positionIndexPath: const Size(-10, -50),
              scaledottedPath: .8,
              letterPath: ShapePaths.rshape,
              pointsJsonFile: ShapePointsManger.rShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.i:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: ShapePaths.iShapeDotetd,
              dottedPathPaintStyle: PaintingStyle.fill,
              indexPathPaintStyle: PaintingStyle.fill,
              positionDottedPath: const Size(12, 20),
              positionIndexPath: const Size(-15, -35),
              strokeWidth: 45,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: ShapePaths.iShapeIndex,
              scaleIndexPath: .5,
              scaledottedPath: .5,
              letterPath: ShapePaths.iShape,
              pointsJsonFile: ShapePointsManger.iShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.p:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: ShapePaths.pShapeDotted,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPathPaintStyle: PaintingStyle.fill,
              positionDottedPath: const Size(0, 5),
              positionIndexPath: const Size(-46, -70),
              strokeWidth: 40,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: ShapePaths.pShapeIndex,
              scaleIndexPath: .2,
              scaledottedPath: .9,
              letterPath: ShapePaths.pShape,
              pointsJsonFile: ShapePointsManger.pShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
    
    }
  }

  List<TraceModel> _getTracingDataPhonicsUp(
      {required String letter, Size sizeOfLetter = const Size(200, 200)}) {
    PhonicsLetters currentLetter =
        _detectTheCurrentEnumFromPhonics(letter: letter);

    switch (currentLetter) {
      case PhonicsLetters.l:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: EnglishShapePaths2.lBigShapeDotted,
              strokeWidth: 75,
              disableDividedStrokes: true,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.fill,
              indexPath: EnglishShapePaths2.lBigShapeIndex,
              scaleIndexPath: .85,
              scaledottedPath: .8,
              positionIndexPath: const Size(-45, 0),
              positionDottedPath: const Size(0, 10),
              letterPath: EnglishShapePaths2.lBigShape,
              pointsJsonFile: ShapePointsManger.lUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.u:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: EnglishShapePaths2.uBigShapeDotted,
              strokeWidth: 70,
              disableDividedStrokes: true,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPath: EnglishShapePaths2.uBigShapeIndex,
              scaleIndexPath: .15,
              scaledottedPath: .93,
              positionIndexPath: const Size(-50, -70),
              positionDottedPath: const Size(5, 0),
              letterPath: EnglishShapePaths2.uBigShape,
              pointsJsonFile: ShapePointsManger.uUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.j:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: EnglishShapePaths2.jBigShapeDotted,
              strokeWidth: 40,
              disableDividedStrokes: true,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPath: EnglishShapePaths2.jBigShapeIndex,
              scaleIndexPath: .28,
              scaledottedPath: .93,
              positionIndexPath: const Size(-22, -70),
              positionDottedPath: const Size(0, 0),
              letterPath: EnglishShapePaths2.jBigShape,
              pointsJsonFile: ShapePointsManger.jUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case PhonicsLetters.h:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: EnglishShapePaths2.hBigShapeDotted,
              strokeWidth: 50,
              disableDividedStrokes: true,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPath: EnglishShapePaths2.hBigShapeIndex,
              scaleIndexPath: .75,
              scaledottedPath: .8,
              positionIndexPath: const Size(0, -45),
              positionDottedPath: const Size(0, 10),
              letterPath: EnglishShapePaths2.hBigShape,
              pointsJsonFile: ShapePointsManger.hUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case PhonicsLetters.o:
        return [
          _getTracingDataPhonics(
                  letter: 'o', sizeOfLetter: const Size(200, 200))
              .first,
        ];

      case PhonicsLetters.g:
        return [
          TraceModel(
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              dottedPath: EnglishShapePaths2.gShapeBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.gShapeBigShapeIndex,
              strokeWidth: 60,
              scaleIndexPath: .4,
              positionIndexPath: const Size(40, -30),
              scaledottedPath: .85,
              letterPath: EnglishShapePaths2.gShapeBigShape,
              pointsJsonFile: ShapePointsManger.gUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case PhonicsLetters.f:
        return [
          TraceModel(
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              dottedPath: EnglishShapePaths2.fShapeBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.fShapeBigShapeIndex,
              strokeWidth: 60,
              scaleIndexPath: .5,
              positionIndexPath: const Size(-45, -40),
              scaledottedPath: .85,
              letterPath: EnglishShapePaths2.fShapeBigShape,
              pointsJsonFile: ShapePointsManger.fUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case PhonicsLetters.d:
        return [
          TraceModel(
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              dottedPath: EnglishShapePaths2.dBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.dBigShapeIndex,
              strokeWidth: 75,
              scaleIndexPath: .3,
              positionIndexPath: const Size(-45, -80),
              scaledottedPath: .85,
              letterPath: EnglishShapePaths2.dBigShape,
              pointsJsonFile: ShapePointsManger.dUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.w:
        return [
          _getTracingDataPhonics(
                  letter: 'w', sizeOfLetter: const Size(200, 200))
              .first,
        ];
      case PhonicsLetters.e:
        return [
          TraceModel(
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              dottedPath: EnglishShapePaths2.eBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.eBigShapeIndex,
              strokeWidth: 75,
              scaleIndexPath: .8,
              positionIndexPath: const Size(-20, 0),
              scaledottedPath: .85,
              letterPath: EnglishShapePaths2.eBigShape,
              pointsJsonFile: ShapePointsManger.eUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.n:
        return [
          TraceModel(
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              dottedPath: EnglishShapePaths2.nBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.nBigShapeIndex,
              strokeWidth: 63,
              scaleIndexPath: .94,
              distanceToCheck: 25,
              disableDividedStrokes: true,
              positionIndexPath: const Size(0, 0),
              scaledottedPath: .87,
              letterPath: EnglishShapePaths2.nBigShape,
              pointsJsonFile: ShapePointsManger.nUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.b:
        return [
          TraceModel(
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              dottedPath: EnglishShapePaths2.bShapeBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.bShapeBigShapeIndex,
              strokeWidth: 60,
              scaleIndexPath: .25,
              positionIndexPath: const Size(-30, -80),
              scaledottedPath: .85,
              letterPath: EnglishShapePaths2.bShapeBigShape,
              pointsJsonFile: ShapePointsManger.bUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];

      case PhonicsLetters.s:
        // s phone
        return [
          _getTracingDataPhonics(
                  letter: 's', sizeOfLetter: const Size(200, 200))
              .first,
        ];
      case PhonicsLetters.a:
        return [
          TraceModel(
              dottedPath: EnglishShapePaths2.aShapeBigDotted,
              dottedColor: AppColorPhonetics.white,
              disableDividedStrokes: true,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.aShapeBigShapeIndex,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPathPaintStyle: PaintingStyle.fill,
              scaleIndexPath: .67,
              positionIndexPath: const Size(-15, -20),
              scaledottedPath: .8,
              letterPath: EnglishShapePaths2.aShapeBigShape,
              strokeWidth: 65,
              pointsJsonFile: ShapePointsManger.aUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.m:
        return [
          TraceModel(
              letterViewSize: sizeOfLetter,
              dottedPath: EnglishShapePaths2.mSHapeBigDoted,
              strokeWidth: 60,
              disableDividedStrokes: true,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPath: EnglishShapePaths2.mShapeBigIndex,
              scaleIndexPath: .9,
              scaledottedPath: .9,
              positionIndexPath: const Size(0, 2),
              letterPath: EnglishShapePaths2.mShapeBigShape,
              pointsJsonFile: ShapePointsManger.mUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.k:
        return [
          _getTracingDataPhonics(
                  letter: 'k', sizeOfLetter: const Size(200, 200))
              .first,
        ];
      case PhonicsLetters.q:
        return [
          TraceModel(
              dottedPath: EnglishShapePaths2.qBigShapeDotted,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPathPaintStyle: PaintingStyle.fill,
              positionIndexPath: const Size(10, 55),
              strokeWidth: 40,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: EnglishShapePaths2.qBigShapesIndex,
              scaleIndexPath: .3,
              scaledottedPath: .9,
              letterPath: EnglishShapePaths2.qBigShapes,
              pointsJsonFile: ShapePointsManger.qUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.v:
        return [
          _getTracingDataPhonics(
                  letter: 'v', sizeOfLetter: const Size(200, 200))
              .first,
        ];
      case PhonicsLetters.x:
        return [
          _getTracingDataPhonics(
                  letter: 'x', sizeOfLetter: const Size(200, 200))
              .first,
        ];
      case PhonicsLetters.y:
        return [
          _getTracingDataPhonics(
                  letter: 'y', sizeOfLetter: const Size(200, 200))
              .first,
        ];
      case PhonicsLetters.z:
        return [
          _getTracingDataPhonics(
                  letter: 'z', sizeOfLetter: const Size(200, 200))
              .first,
        ];
      case PhonicsLetters.t:
        return [
          TraceModel(
              dottedPath: EnglishShapePaths2.tShapeBigShapeDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: EnglishShapePaths2.tShapeBigShapeIndex,
              letterPath: EnglishShapePaths2.tShapeBigShape,
              strokeWidth: 50,
              scaledottedPath: .8,
              scaleIndexPath: .35,
              disableDividedStrokes: true,
              positionDottedPath: const Size(5, -5),
              positionIndexPath: const Size(-30, -70),
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPathPaintStyle: PaintingStyle.fill,
              pointsJsonFile: ShapePointsManger.tUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.c:
        return [
          _getTracingDataPhonics(letter: 'c').first,
        ];
      case PhonicsLetters.r:
        return [
          TraceModel(
              dottedPath: EnglishShapePaths2.rShapeBigShapeDotted,
              indexPathPaintStyle: PaintingStyle.fill,
              dottedPathPaintStyle: PaintingStyle.fill,
              strokeWidth: 60,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: EnglishShapePaths2.rShapeBigShapeIndex,
              scaleIndexPath: .5,
              positionIndexPath: const Size(-20, -40),
              scaledottedPath: .9,
              letterPath: EnglishShapePaths2.rShapeBigShape,
              pointsJsonFile: ShapePointsManger.rUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.i:
        return [
          TraceModel(
              dottedPath: EnglishShapePaths2.iShapeBigShapeDotted,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPathPaintStyle: PaintingStyle.fill,
              positionDottedPath: const Size(10, 0),
              positionIndexPath: const Size(-22, 0),
              strokeWidth: 60,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: EnglishShapePaths2.iShapeBigShapeIndex,
              scaleIndexPath: .95,
              scaledottedPath: .9,
              letterPath: EnglishShapePaths2.iShapeBigShape,
              pointsJsonFile: ShapePointsManger.iUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case PhonicsLetters.p:
        return [
          TraceModel(
              dottedPath: EnglishShapePaths2.pBigShapeDotted,
              dottedPathPaintStyle: PaintingStyle.stroke,
              indexPathPaintStyle: PaintingStyle.fill,
              positionDottedPath: const Size(-5, 5),
              positionIndexPath: const Size(-40, -80),
              strokeWidth: 40,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.white,
              indexPath: EnglishShapePaths2.pBigShapeIndex,
              scaleIndexPath: .25,
              scaledottedPath: .92,
              letterPath: EnglishShapePaths2.pBigShape,
              pointsJsonFile: ShapePointsManger.pUpperShape,
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
    }
  }

  List<TraceModel> _getTracingDataTelugu({required String letter}) {
    TeluguLetters currentLetter = _detectTheCurrentEnumFromTelugu(letter: letter);

    switch (currentLetter) {
      case TeluguLetters.a:
        return [
          TraceModel(
              positionIndexPath: const Size(0, 0),
              positionDottedPath: const Size(0, 0),
              scaledottedPath: 1.0,
              scaleIndexPath: 1.0,
              indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: TeluguShapePaths.aDotted,
              dottedColor: AppColorPhonetics.grey,
              indexColor: AppColorPhonetics.grey,
              indexPath: TeluguShapePaths.aIndex,
              letterPath: TeluguShapePaths.aShape,
              strokeWidth: 40,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.teluguAShape,
              letterViewSize: const Size(300, 300),
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
      case TeluguLetters.aa:
        return [
          TraceModel(
              positionIndexPath: const Size(0, 0),
              positionDottedPath: const Size(0, 0),
              scaledottedPath: 1.0,
              scaleIndexPath: 1.0,
              indexPathPaintStyle: PaintingStyle.stroke,
              dottedPath: TeluguShapePaths.aaDotted,
              dottedColor: AppColorPhonetics.white,
              indexColor: AppColorPhonetics.grey,
              indexPath: TeluguShapePaths.aaIndex,
              letterPath: TeluguShapePaths.aaShape,
              strokeWidth: 40,
              strokeIndex: 1,
              pointsJsonFile: ShapePointsManger.teluguAAShape,
              letterViewSize: const Size(300, 300),
              innerPaintColor: AppColorPhonetics.lightBlueColor5,
              outerPaintColor: AppColorPhonetics.lightBlueColor5),
        ];
    }
  }
}
