part of objectviewer;

class MotionEngine{
  Matrix4 _tranMatrix = new Matrix4.identity();
  Box abox;
  Hexagon hexagon;
  Strip strip;
  ObjectViewerShader shader;
  WebGL.RenderingContext glContext;
  Camera cam = new Camera();
  var speed = 0.1; 
  Matrix2 counterClockWiseM = new Matrix2(0.0, 1.0, -1.0, 0.0);
  Matrix2 clockWiseM = new Matrix2(0.0, -1.0, 1.0, 0.0);
  
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
    var projectionMatrix = cam.projectionMatrix;
    var viewMatrix = cam.lookAtMatrixWithDirection;
    projectionMatrix.multiply(viewMatrix);
    shader.pUniform = projectionMatrix;
    
    //move();
    //moveCamForward();
    //moveCamBackward();
    //moveCamLeft();
    //moveCamRight();
    
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
  
  void moveCamForward(){
    Vector2 v = cam.lookAtPosition.xz;
    v.normalize();
    cam.eyePosition.x += v.x * speed;
    cam.eyePosition.z += v.y * speed;
  }
  
  void moveCamBackward(){
    Vector2 v = cam.lookAtPosition.xz;
    v.normalize();
    cam.eyePosition.x -= v.x * speed;
    cam.eyePosition.z -= v.y * speed;
  }
  
  /**
   * http://mathworld.wolfram.com/PerpendicularVector.html
   */
  void moveCamLeft(){
    Vector2 v = cam.lookAtPosition.xz;
    v.normalize();
    v.postmultiply(counterClockWiseM);
    cam.eyePosition.x -= v.x * speed;
    cam.eyePosition.z -= v.y * speed;
  }
  void moveCamRight(){
    Vector2 v = cam.lookAtPosition.xz;
    v.normalize();
    v.postmultiply(clockWiseM);
    cam.eyePosition.x -= v.x * speed;
    cam.eyePosition.z -= v.y * speed;
  }
  
}