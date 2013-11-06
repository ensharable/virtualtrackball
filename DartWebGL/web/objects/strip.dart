part of objectviewer;

class Strip extends Shapes {
	WebGL.Buffer vertexBuffer;
	WebGL.Buffer indexBuffer;
  int _itemSize=0;
  int _numOfItems=0;
  int _indexBufferItemSize=0;
  int _indexBufferNumOfItems=0;

  int _positionAttributeIndex;
  int _colorAttributeIndex;
  
  Strip(WebGL.RenderingContext gl, WebGL.Program p) : super(gl, p){
  }
  
  void setupBuffers(){
    var vertices = [
        -0.5,  0.2,  0.0, //v0
        -0.4,  0.0,  0.0, //v1
        -0.3,  0.2,  0.0, //v2
        -0.2,  0.0,  0.0, //v3
        -0.1,  0.2,  0.0, //v4
         0.0,  0.0,  0.0, //v5
         0.1,  0.2,  0.0, //v6
         0.2,  0.0,  0.0, //v7
         0.3,  0.2,  0.0, //v8
         0.4,  0.0,  0.0, //v9
         0.5,  0.2,  0.0, //v10
         // start second strip
        -0.5, -0.3,  0.0, //v11
        -0.4, -0.5,  0.0, //v12
        -0.3, -0.3,  0.0, //v13
        -0.2, -0.5,  0.0, //v14
        -0.1, -0.3,  0.0, //v15
         0.0, -0.5,  0.0, //v16
         0.1, -0.3,  0.0, //v17
         0.2, -0.5,  0.0, //v18
         0.3, -0.3,  0.0, //v19
         0.4, -0.5,  0.0, //v20
         0.5, -0.3,  0.0  //v21
                           ];
    _itemSize=3;
    _numOfItems=22;
    

    //Create WebGL Buffer to store vertices data.
    vertexBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    //cover the arry to Float32List
    var vertexArray = new Float32List.fromList(vertices);
    //fill the buff using the data in Float32List
    _gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
                  vertexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
    
    var vertexIndices = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                   10, 10, 11, // 3 extra indices for the degenerate triangles
                   11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21];
    _indexBufferItemSize=1;
    _indexBufferNumOfItems = 25;
    
    var indexArray = new Uint16List.fromList(vertexIndices);
    indexBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    _gl.bufferDataTyped(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER,
                  indexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
    
    

  }
  
  void modifyShaderAttributes() {
    _positionAttributeIndex = _gl.getAttribLocation(_program, 'aVertexPosition');
    _gl.enableVertexAttribArray(_positionAttributeIndex);

    _colorAttributeIndex = _gl.getAttribLocation(_program, 'aVertexColor');
    _gl.disableVertexAttribArray(_colorAttributeIndex);
  }

  void prerender() {
    //bind the vertex buff to shader  
    
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    _gl.vertexAttribPointer(_positionAttributeIndex,
                           _itemSize, WebGL.RenderingContext.FLOAT, // 3 floats
                           false, 0, 0); // 0 offset
    
    _gl.vertexAttrib4f(_colorAttributeIndex, 1.0, 1.0, 0.0, 1.0);

    //bind the index buffer to shader
    _gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);

  }
  

  void render() {
    //draw the object according to the index buffer
    _gl.drawElements(WebGL.RenderingContext.TRIANGLE_STRIP, _indexBufferNumOfItems, WebGL.RenderingContext.UNSIGNED_SHORT, 0);
    
    _gl.vertexAttrib4f(_colorAttributeIndex, 0.0, 0.0, 0.0, 1.0);
    
    // Draw help lines to easier see the triangles
    // that build up the triangle-strip
    _gl.drawArrays(WebGL.RenderingContext.LINE_STRIP, 0, 11);
    _gl.drawArrays(WebGL.RenderingContext.LINE_STRIP, 11, 11);
  }
}