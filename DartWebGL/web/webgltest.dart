
library objectviewer;

import 'dart:async';
import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl' as WebGL;
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

part 'objectviewer.dart';
part 'shader.dart';
part 'objectviewer_shader.dart';
part 'sphere_controller.dart';
part 'camera.dart';
part 'box.dart';

Objectviewer application = new Objectviewer();
final bool VERBOSE = false;

void main() {
  application.startup('#webgl_container');
}

void printLog(String log) {
  if (VERBOSE && log != null && !log.isEmpty) {
    print(log);
  }
}