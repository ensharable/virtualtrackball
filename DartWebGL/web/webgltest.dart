
library objectviewer;

import 'dart:async';
import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl' as WebGL;
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

import 'utilities/webgl_utils.dart';

part 'objectviewer.dart';


part 'utilities/sphere_controller.dart';
part 'objects/shapes.dart';
part 'objects/box.dart';
part 'objects/hexagon.dart';
part 'objects/strip.dart';
part 'MotionEngine.dart';
part 'utilities/InputController.dart';
part 'objects/boxwithtexture.dart';


Objectviewer application = new Objectviewer();

void main() {
  application.startup('#webgl_container');
}

