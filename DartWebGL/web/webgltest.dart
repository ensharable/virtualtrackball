
library objectviewer;

import 'dart:async';
import 'dart:html';
import 'dart:math' as Math;
import 'dart:web_gl' as WebGL;
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

part 'objectviewer.dart';
part 'objectviewer_shader.dart';
part 'sphere_controller.dart';
part 'camera.dart';
part 'shader.dart';
part 'box.dart';

Objectviewer application = new Objectviewer();

void main() {
  querySelector("#sample_text_id")
    ..text = "What up!"
    ..onClick.listen(reverseText);
  
  application.startup('#webgl_container');
  
}

void reverseText(MouseEvent event) {
  var text = querySelector("#sample_text_id").text;
  var buffer = new StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    buffer.write(text[i]);
  }
  querySelector("#sample_text_id").text = buffer.toString();
}


void printLog(String log) {
  if (VERBOSE && log != null && !log.isEmpty) {
    print(log);
  }
}