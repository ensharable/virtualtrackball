part of objectviewer;

class Objectviewer{
  
    WebGL.RenderingContext glContext;
    CanvasElement canvas;
    Math.Random random = new Math.Random();
    Camera camera = new Camera();
    int get width => canvas.width;
    int get height => canvas.height;
    MouseSphereCameraController controller = new MouseSphereCameraController();
    bool ownMouse = false;
    Box abox;
    ObjectViewerShader shader;

    void startup(String canvasId) {
      canvas = querySelector(canvasId);
      glContext = canvas.getContext('experimental-webgl');
      if (glContext == null) {
        canvas.parent.text = ">>> Browser does not support WebGL <<<";
        return;
      }
      abox = new Box();
      
      canvas.width = (canvas.parent as Element).client.width;
      canvas.height = canvas.parent.client.height;
      
      camera.aspectRatio = canvas.width / canvas.height;
      
      bind();
      
      ObjectViewerShader shader = new ObjectViewerShader(glContext);
      shader.prepare();
      shader.enable();

      Box.setup(glContext);
      Box.bindToProgram(glContext, shader.program);
      
      Box.prerender(glContext);
      Box.render(glContext);
  }

  

  bool get _fullScreened => canvas == document.fullscreenElement;

  void clicked(Event event) {
    canvas.requestPointerLock();
  }

  /* Returns true if the pointer is owned by our canvas element */
  bool get _pointerLocked => canvas == document.pointerLockElement;

  void pointerLockChange(Event event) {
    // Check if we own the mouse.
    ownMouse = _pointerLocked;
  }

  void toggleFullscreen() {
    if (_fullScreened) {
      document.cancelFullScreen();
    } else {
      canvas.requestFullscreen();
    }
  }

  var keyCodeLeft = 37;
  var keyCodeRight = 39;

  var keyCodeE = 69;
  var keyCodeF = 70;
  var keyCodeJ = 74;
  var keyCodeS = 83;

  void keydown(KeyboardEvent event) {
    if (!ownMouse) {
      // We don't respond to keyboard commands if we don't own the mouse
      return;
    }
  }

  void keyup(KeyboardEvent event) {
    if (!ownMouse) {
      // We don't respond to keyboard commands if we don't own the mouse
      return;
    }
    if (event.keyCode == keyCodeLeft) {
      //solarSystem.selectPreviousPlanet();
    }
    if (event.keyCode == keyCodeRight) {
      //solarSystem.selectNextPlanet();
    }
    if (event.keyCode == keyCodeJ) {
      //solarSystem.selectPlanet('Jupiter');
    }
    if (event.keyCode == keyCodeS) {
      //solarSystem.selectPlanet('Sun');
    }
    if (event.keyCode == keyCodeF) {
      //toggleFullscreen();
    }
    if (event.keyCode == keyCodeE) {
      //solarSystem.selectPlanet('Earth');
    }
  }

  void mouseMove(MouseEvent event) {
    if (!ownMouse) {
      // We don't rotate the view if we don't own the mouse
      return;
    }
    controller.accumScroll += event.movement.y;
    event.preventDefault();
  }

  void mouseWheel(MouseEvent event) {
    if (!ownMouse) {
      // We don't rotate the view if we don't own the mouse
      return;
    }
    if (event is WheelEvent) {
      WheelEvent e = event;
      controller.mouseSensitivity = 720.0;
      controller.accumDX -= e.deltaX;
      controller.accumDY += e.deltaY;
    }
    event.preventDefault();
  }

 
  // Bind input event callbacks
  void bind() {
    document.onPointerLockChange.listen(pointerLockChange);
    canvas.onClick.listen(clicked);
    document.onKeyDown.listen(keydown);
    document.onKeyUp.listen(keyup);
    document.onMouseMove.listen(mouseMove);
    window.onMouseWheel.listen(mouseWheel);
  }
}