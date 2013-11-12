part of objectviewer;

class Objectviewer{
  
    WebGL.RenderingContext glContext;
    CanvasElement canvas;
    Math.Random random = new Math.Random();
    Camera camera = new Camera();
    int get width => canvas.width;
    int get height => canvas.height;
    
    void startup(String canvasId) {
      canvas = querySelector(canvasId);
      glContext = canvas.getContext('experimental-webgl');
      if (glContext == null) {
        canvas.parent.text = ">>> Browser does not support WebGL <<<";
        return;
      }
      //canvas.width = canvas.parent.client.width;
      //canvas.height = canvas.parent.client.height;
      
      camera.aspectRatio = canvas.width / canvas.height;
      
      var me = new MotionEngine(glContext, camera);
      InputController contrller = new InputController(this.canvas, camera);
      me.start(); 
    }

    
    
  

 
}