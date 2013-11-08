part of objectviewer;

class InputController {
  CanvasElement canvas;
  bool ownMouse = false;
  MouseSphereCameraController controller = new MouseSphereCameraController();
  MotionEngine engine;
  
  InputController(CanvasElement canvas, MotionEngine engine){
    this.canvas = canvas;
    this.engine = engine;
    inputBind();
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


  void keydown(KeyboardEvent event) {
    if (!ownMouse) {
      // We don't respond to keyboard commands if we don't own the mouse
      return;
    }
    
    if (event.keyCode == KeyCode.LEFT) {
      //solarSystem.selectPreviousPlanet();
    }
    if (event.keyCode == KeyCode.LEFT) {
      //solarSystem.selectNextPlanet();
    }
    if (event.keyCode == KeyCode.W) {
      engine.moveCamForward();
    }
    if (event.keyCode == KeyCode.S) {
      engine.moveCamBackward();
    }
    if (event.keyCode == KeyCode.A) {
      engine.moveCamLeft();
    }
    if (event.keyCode == KeyCode.D) {
      engine.moveCamRight();
    }
  }

  void keyup(KeyboardEvent event) {
    if (!ownMouse) {
      // We don't respond to keyboard commands if we don't own the mouse
      return;
    }
    if (event.keyCode == KeyCode.LEFT) {
      //solarSystem.selectPreviousPlanet();
    }
    if (event.keyCode == KeyCode.LEFT) {
      //solarSystem.selectNextPlanet();
    }
    if (event.keyCode == KeyCode.W) {
      engine.moveCamForward();
    }
    if (event.keyCode == KeyCode.S) {
      engine.moveCamBackward();
    }
    if (event.keyCode == KeyCode.A) {
      engine.moveCamLeft();
    }
    if (event.keyCode == KeyCode.D) {
      engine.moveCamRight();
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
  void inputBind() {
    document.onPointerLockChange.listen(pointerLockChange);
    canvas.onClick.listen(clicked);
    document.onKeyDown.listen(keydown);
    document.onKeyUp.listen(keyup);
    document.onMouseMove.listen(mouseMove);
    window.onMouseWheel.listen(mouseWheel);
  }
  
}