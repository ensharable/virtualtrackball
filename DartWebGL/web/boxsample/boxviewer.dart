part of objectviewer;

class Boxviewer{
  
    WebGL.RenderingContext glContext;
    CanvasElement canvas;
    Math.Random random = new Math.Random();
    Camera camera = new Camera();
    int get width => canvas.width;
    int get height => canvas.height;
    Box abox;
    ObjectViewerShader shader;
    Matrix4 mvMatrix;
    Matrix4 _tranMatrix = new Matrix4.identity();
    Matrix4 get tranMatrix => _tranMatrix;

    void startup(String canvasId) {
      canvas = querySelector(canvasId);
      glContext = canvas.getContext('experimental-webgl');
      if (glContext == null) {
        canvas.parent.text = ">>> Browser does not support WebGL <<<";
        return;
      }
      canvas.width = canvas.parent.client.width;
      canvas.height = canvas.parent.client.height;
      
      camera.aspectRatio = canvas.width / canvas.height;
      
      this.glContext = glContext;
      shader = new ObjectViewerShader(glContext);
      shader.prepare();
      shader.enable();
      
      Vector3 v = new Vector3(0.0, 0.0, -6.0);
      _tranMatrix = new Matrix4.translation(v);
      
      abox = new Box(glContext, shader.program);
      abox.setupBuffers();
      
      start();
    }
    
    
    void start(){
      requestRedraw();
    }
    
    void move(){
      Matrix4 temp = new Matrix4.translationValues(0.01, 0.0, 0.0);
      _tranMatrix = _tranMatrix*temp;
    }
    
    void update(double time){
      glContext.viewport(0, 0, 500, 500);
      glContext.clear(WebGL.RenderingContext.COLOR_BUFFER_BIT | WebGL.RenderingContext.DEPTH_BUFFER_BIT);
      
      //set the matrix:
      Camera cam = new Camera();
      shader.pUniform = cam.projectionMatrix;
      
      //uncomment the following to see moving animation
      //move();
      shader.mvUniform = _tranMatrix;
      
      abox.modifyShaderAttributes();
      abox.prerender();
      abox.render();
      
      requestRedraw();
    }
    
    
    void requestRedraw() {
      window.animationFrame.then(update);
    }
}