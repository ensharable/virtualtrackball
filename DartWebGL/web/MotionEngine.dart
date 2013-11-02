part of objectviewer;

class MotionEngine{
  Matrix4 _tranMatrix = new Matrix4.identity();
  Box _b;
  ObjectViewerShader shader;
  WebGL.RenderingContext glContext;
  
  MotionEngine(Box b, WebGL.RenderingContext glContext){
    this._b = b;
    this.glContext = glContext;
    shader = new ObjectViewerShader(glContext);
    shader.prepare();
    shader.enable();
    
    Vector3 v = new Vector3(0.0, 0.0, -6.0);
    _tranMatrix = new Matrix4.translation(v);
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
    
    //set the matrix:
    Camera cam = new Camera();
    shader.pUniform = cam.projectionMatrix;
    
    move();
    
    shader.mvUniform = _tranMatrix;

    Box.setup(glContext);
    Box.bindToProgram(glContext, shader.program);
    
    Box.prerender(glContext);
    Box.render(glContext);
    
    requestRedraw();
  }
  
  
  void requestRedraw() {
    window.animationFrame.then(update);
  }
  
}