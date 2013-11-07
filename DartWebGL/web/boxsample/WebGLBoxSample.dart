
library objectviewer;

import 'dart:async';
import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl' as WebGL;
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

part 'boxviewer.dart';
part '../shaders/shader.dart';
part '../shaders/objectviewer_shader.dart';
part '../camera.dart';
part '../objects/shapes.dart';
part '../objects/box.dart';


Boxviewer application = new Boxviewer();
final bool VERBOSE = false;

void main() {
  application.startup('#webgl_container');
}

void printLog(String log) {
  if (VERBOSE && log != null && !log.isEmpty) {
    print(log);
  }
}