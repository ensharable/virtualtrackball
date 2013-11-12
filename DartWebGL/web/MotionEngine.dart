part of objectviewer;

class MotionEngine{
  Matrix4 _tranMatrix = new Matrix4.identity();
  Box abox;
  BoxWithTexture boxWithTexture;
  Hexagon hexagon;
  Strip strip;
  ObjectViewerShader objectViewershader;
  TextureShader shader;
  WebGL.RenderingContext glContext;
  Camera cam;
  
  
  MotionEngine(WebGL.RenderingContext glContext, Camera camera){
    this.glContext = glContext;
    
    objectViewershader = new ObjectViewerShader(glContext);
    objectViewershader.prepare();
    objectViewershader.enable();
    
    shader = new TextureShader(glContext);
    shader.prepare();
    shader.enable();
    
    cam = camera;
    
    Vector3 v = new Vector3(0.0, 0.0, -6.0);
    _tranMatrix = new Matrix4.translation(v);
    
    abox = new Box(glContext, objectViewershader.program);
    abox.setupBuffers();
    
    hexagon = new Hexagon(glContext, objectViewershader.program);
    hexagon.setupBuffers();
    
    strip = new Strip(glContext, objectViewershader.program);
    strip.setupBuffers();
    
    boxWithTexture = new BoxWithTexture(glContext, shader.program);
    boxWithTexture.setupBuffers();
    boxWithTexture.setupTexture();
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
    
    //move();
    //moveCamForward();
    //moveCamBackward();
    //moveCamLeft();
    //moveCamRight();
    
    //use texture shader
    shader.enable();
    shader.pUniform = projectionMatrix;
    shader.mvUniform = _tranMatrix;
    boxWithTexture.modifyShaderAttributes();
    boxWithTexture.prerender();
    boxWithTexture.render();

    
    //use simple color shader
    objectViewershader.enable();
    objectViewershader.pUniform = projectionMatrix;
    objectViewershader.mvUniform = _tranMatrix;
    /*
    abox.modifyShaderAttributes();
    abox.prerender();
    abox.render();
    */
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