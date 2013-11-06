part of objectviewer;

class Hexagon extends Shapes {
  WebGL.Buffer vertexBuffer;
  int _itemSize=0;
  int _numberOfItems;
  int _positionAttributeIndex;
  
  Hexagon(WebGL.RenderingContext gl, WebGL.Program p) : super(gl, p){
  }
  
  void setupBuffers(){
    var vertices = [
                           -0.3,  0.6,  0.0, //v0
                           -0.4,  0.8,  0.0, //v1
                           -0.6,  0.8,  0.0, //v2
                           -0.7,  0.6,  0.0, //v3
                           -0.6,  0.4,  0.0, //v4
                           -0.4,  0.4,  0.0, //v5
                           -0.3,  0.6,  0.0, //v6
                           ];
    _itemSize=3;
    _numberOfItems=7;
    

    //Create WebGL Buffer to store vertices data.
    vertexBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    //cover the arry to Float32List
    var vertexArray = new Float32List.fromList(vertices);
    //fill the buff using the data in Float32List
    _gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
                  vertexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
    
  }
  
  void modifyShaderAttributes() {
    _positionAttributeIndex = _gl.getAttribLocation(_program, 'aVertexPosition');
    _gl.enableVertexAttribArray(_positionAttributeIndex);
  }

  void prerender() {
    //bind the vertex buff to shader   
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    _gl.vertexAttribPointer(_positionAttributeIndex,
                           _itemSize, WebGL.RenderingContext.FLOAT, // 3 floats
                           false, 0,
                           0); // 0 offset
  }
  

  void render() {
    //draw the cube according to the index buffer
    _gl.drawArrays(WebGL.RenderingContext.LINE_STRIP, 0,
                    _numberOfItems);
  }
}