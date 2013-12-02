part of WebGLUtils;

class RenderObject{
  WebGL.RenderingContext _gl;
  WebGL.Program _p;  
  ObjectModel _obj;
  WebGL.Buffer indexBuffer;
  WebGL.Buffer vertexBuffer;
  WebGL.Buffer verticesColorBuffer;
  int _vertexCount=36;  //this is becuse of the box data
  int _vertexStride=0; //this is becuse of the box data
  int _positionAttributeIndex;
  int _colorAttributeIndex;
  MaterialManager mm = new MaterialManager();
  
  RenderObject(WebGL.RenderingContext gl, WebGL.Program p, ObjectModel obj){
    this._gl = gl;
    this._p = p;
    this._obj = obj;
  }
  
  void setupBuffers(){
    //Create WebGL Buffer to store vertices data.
    vertexBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    //cover the arry to Float32List
    var vertexArray = new Float32List.fromList(_obj.vertics);
    
    //fill the buff using the data in Float32List
    _gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
                  vertexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
    
    
    var indexArray = new Uint16List.fromList(_obj.facesIndices);
    indexBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    _gl.bufferDataTyped(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER,
                  indexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
  }
  
  void setupMaterial(){
    var key = _obj.useMaterial;
    Material m = mm.getMaterial(key);
    
  }
  
  void modifyShaderAttributes() {
    _positionAttributeIndex = _gl.getAttribLocation(_p, 'aVertexPosition');
    _gl.enableVertexAttribArray(_positionAttributeIndex);
    
    _colorAttributeIndex = _gl.getAttribLocation(_p, 'aVertexColor');
    _gl.disableVertexAttribArray(_colorAttributeIndex);
  }

  void prerender() {
    //bind the vertex buff to shader  
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    _gl.vertexAttribPointer(_positionAttributeIndex,
                           3, WebGL.RenderingContext.FLOAT, // 3 floats
                           false, 0,
                           0); // 0 offset
    
    //bind the index buffer to shader
    _gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    
    _gl.vertexAttrib4f(_colorAttributeIndex, 1.0, 0.0, 0.0, 1.0);
  }

  void render() {
    //draw the cube according to the index buffer
    _gl.drawElements(WebGL.RenderingContext.TRIANGLES, _obj.facesIndices.length,
                    WebGL.RenderingContext.UNSIGNED_SHORT, 0);
  }
  
}