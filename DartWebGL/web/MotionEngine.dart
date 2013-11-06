part of objectviewer;

class MotionEngine{
  Matrix4 _tranMatrix = new Matrix4.identity();
  Box abox;
  Hexagon hexagon;
  Strip strip;
  ObjectViewerShader shader;
  WebGL.RenderingContext glContext;
  
  MotionEngine(WebGL.RenderingContext glContext){
    this.glContext = glContext;
    shader = new ObjectViewerShader(glContext);
    shader.prepare();
    shader.enable();
    
    Vector3 v = new Vector3(0.0, 0.0, -6.0);
    _tranMatrix = new Matrix4.translation(v);
    
    abox = new Box(glContext, shader.program);
    abox.setupBuffers();
    
    hexagon = new Hexagon(glContext, shader.program);
    hexagon.setupBuffers();
    
    strip = new Strip(glContext, shader.program);
    strip.setupBuffers();
  }
  
  void start(){
    requestRedraw();
  }
  
  void move(){
    Matrix4 temp = new Matrix4.translationValues(0.01, 0.0, 0.0);
    _tranMatrix = _tranMatrix*temp;
  }
  
  Matrix4 get tranMatrix => _tranMatrix;
  
  void update(double time){
    glContext.viewport(0, 0, 500, 500);
    glContext.clear(WebGL.RenderingContext.COLOR_BUFFER_BIT | WebGL.RenderingContext.DEPTH_BUFFER_BIT);
    
    //set the matrix:
    Camera cam = new Camera();
    shader.pUniform = cam.projectionMatrix;
    move();
    shader.mvUniform = _tranMatrix;
    
    abox.modifyShaderAttributes();
    abox.prerender();
    abox.render();

    hexagon.modifyShaderAttributes();
    hexagon.prerender();
    hexagon.render();
    
    strip.modifyShaderAttributes();
    strip.prerender();
    strip.render();
    
    requestRedraw();
  }
  
  
  void requestRedraw() {
    window.animationFrame.then(update);
  }
  
}