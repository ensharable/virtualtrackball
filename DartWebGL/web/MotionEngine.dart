part of objectviewer;

class MotionEngine{
  Matrix4 _tranMatrix = new Matrix4.identity();
  Box abox;
  BoxWithTexture boxWithTexture;
  Hexagon hexagon;
  Strip strip;
  ObjectViewerShader objectViewershader;
  TextureShader shader;
  TextureLightShader textureLightShader;
  
  WebGL.RenderingContext glContext;
  Camera cam;
  
  double angleSpeed = 0.002;
  
  
  MotionEngine(WebGL.RenderingContext glContext, Camera camera){
    this.glContext = glContext;
    
    objectViewershader = new ObjectViewerShader(glContext);
    objectViewershader.prepare();
    objectViewershader.enable();
    
    shader = new TextureShader(glContext);
    shader.prepare();
    shader.enable();
    
    textureLightShader =  new TextureLightShader(glContext);
    textureLightShader.prepare();
    textureLightShader.enable();

    cam = camera;
    
    Vector3 v = new Vector3(0.0, 0.0, -6.0);
    _tranMatrix = new Matrix4.translation(v);
    
    abox = new Box(glContext, objectViewershader.program);
    abox.setupBuffers();
    
    hexagon = new Hexagon(glContext, objectViewershader.program);
    hexagon.setupBuffers();
    
    strip = new Strip(glContext, objectViewershader.program);
    strip.setupBuffers();
    
    boxWithTexture = new BoxWithTexture(glContext, textureLightShader.program);
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
  
  void rotation(){
    Matrix4 temp = new Matrix4.rotationY(angleSpeed);
    _tranMatrix = _tranMatrix*temp;
  }
  
  
  Matrix4 get tranMatrix => _tranMatrix;
  
  void update(double time){
    
    glContext.viewport(0, 0, cam.screenWidth, cam.screenHeight);
    glContext.clear(WebGL.RenderingContext.COLOR_BUFFER_BIT | WebGL.RenderingContext.DEPTH_BUFFER_BIT);
    
    //glContext.enable(WebGL.RenderingContext.CULL_FACE);
    glContext.depthFunc(WebGL.RenderingContext.LEQUAL);  
    glContext.enable(WebGL.RenderingContext.DEPTH_TEST);
    
    //set the matrix:
    var projectionMatrix = cam.projectionMatrix;
    var viewMatrix = cam.lookAtMatrixWithDirection;
    projectionMatrix.multiply(viewMatrix);
    
    //move();
    rotation();
    
    //moveCamForward();
    //moveCamBackward();
    //moveCamLeft();
    //moveCamRight();
    
    /*
    //use texture shader
    shader.enable();
    shader.pUniform = projectionMatrix;
    shader.mvUniform = _tranMatrix;
    boxWithTexture.modifyShaderAttributes();
    boxWithTexture.prerender();
    boxWithTexture.render();    
    */
    
    textureLightShader.enable();
    textureLightShader.pUniform = projectionMatrix;
    textureLightShader.mvUniform = _tranMatrix;
    Matrix4 norM = _tranMatrix.clone();
    norM.invert();
    norM.transpose();
    textureLightShader.normalUniform = norM;
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