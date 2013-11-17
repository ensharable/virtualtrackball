
library objectviewer;

import 'dart:async';
import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl' as WebGL;
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

part 'objectviewer.dart';
part 'shaders/shader.dart';
part 'shaders/objectviewer_shader.dart';
part 'shaders/texture_shader.dart';
part 'shaders/texture_light_shader.dart';


part 'utilities/sphere_controller.dart';
part 'utilities/camera.dart';
part 'objects/shapes.dart';
part 'objects/box.dart';
part 'objects/hexagon.dart';
part 'objects/strip.dart';
part 'MotionEngine.dart';
part 'utilities/InputController.dart';
part 'utilities/openglextension.dart';
part 'objects/boxwithtexture.dart';

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

String getBaseUrl() {
  var location = window.location.href;
  return "${location.substring(0, location.length - "webgltest.html".length)}";
  //return "${location.substring(0, location.length - "webgltest.html".length - 4)}";
}