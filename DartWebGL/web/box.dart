part of objectviewer;

class Box extends Shapes {
  WebGL.Buffer indexBuffer;
  WebGL.Buffer vertexBuffer;
  WebGL.Buffer verticesColorBuffer;
  int _vertexCount=36;  //this is becuse of the box data
  int _vertexStride=0; //this is becuse of the box data
  int _positionAttributeIndex;
  int _colorAttributeIndex;
  
  Box(WebGL.RenderingContext gl, WebGL.Program p) : super(gl, p){
  }

  void setupBuffers() {
    assert(_gl != null);

    var vertices = [
      // Front face
      -1.0, -1.0,  1.0,
      1.0, -1.0,  1.0,
      1.0,  1.0,  1.0,
      -1.0,  1.0,  1.0,
      
      // Back face
      -1.0, -1.0, -1.0,
      -1.0,  1.0, -1.0,
      1.0,  1.0, -1.0,
      1.0, -1.0, -1.0,
      
      // Top face
      -1.0,  1.0, -1.0,
      -1.0,  1.0,  1.0,
      1.0,  1.0,  1.0,
      1.0,  1.0, -1.0,
      
      // Bottom face
      -1.0, -1.0, -1.0,
      1.0, -1.0, -1.0,
      1.0, -1.0,  1.0,
      -1.0, -1.0,  1.0,
      
      // Right face
      1.0, -1.0, -1.0,
      1.0,  1.0, -1.0,
      1.0,  1.0,  1.0,
      1.0, -1.0,  1.0,
      
      // Left face
      -1.0, -1.0, -1.0,
      -1.0, -1.0,  1.0,
      -1.0,  1.0,  1.0,
      -1.0,  1.0, -1.0
      ];
    
    //Create WebGL Buffer to store vertices data.
    vertexBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    //cover the arry to Float32List
    var vertexArray = new Float32List.fromList(vertices);
    //fill the buff using the data in Float32List
    _gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
                  vertexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
    
    
    // Convert the array of colors into a table for all the vertices.
    var colors = [
                  [1.0,  1.0,  1.0,  1.0],    // Front face: white
                  [1.0,  0.0,  0.0,  1.0],    // Back face: red
                  [0.0,  1.0,  0.0,  1.0],    // Top face: green
                  [0.0,  0.0,  1.0,  1.0],    // Bottom face: blue
                  [1.0,  1.0,  0.0,  1.0],    // Right face: yellow
                  [1.0,  0.0,  1.0,  1.0]     // Left face: purple
                  ];
    
    var generatedColors = new List<double>();
    for (var j=0; j<6; j++) {
      var c = colors[j];
      // Repeat each color four times for the four vertices of the face
      for (var i=0; i<4; i++) {
        generatedColors.addAll(c);
      }
    }
    var colorArray = new Float32List.fromList(generatedColors);
    verticesColorBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, verticesColorBuffer);
    _gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER, colorArray,
        WebGL.RenderingContext.STATIC_DRAW);
    
    
    // Index for the cube
    var vertexIndices = [
           0,  1,  2,      0,  2,  3,    // front
           4,  5,  6,      4,  6,  7,    // back
           8,  9,  10,     8,  10, 11,   // top
           12, 13, 14,     12, 14, 15,   // bottom
           16, 17, 18,     16, 18, 19,   // right
           20, 21, 22,     20, 22, 23    // left
           ];
    var indexArray = new Uint16List.fromList(vertexIndices);
    indexBuffer = _gl.createBuffer();
    _gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    _gl.bufferDataTyped(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER,
                  indexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
  }
  
  void bindToProgram() {
    _positionAttributeIndex = _gl.getAttribLocation(_program, 'aVertexPosition');
    _gl.enableVertexAttribArray(_positionAttributeIndex);
    _colorAttributeIndex = _gl.getAttribLocation(_program, 'aVertexColor');
    _gl.enableVertexAttribArray(_colorAttributeIndex);
  }

  void prerender() {
    //bind the vertex buff to shader   
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    _gl.vertexAttribPointer(_positionAttributeIndex,
                           3, WebGL.RenderingContext.FLOAT, // 3 floats
                           false, 0,
                           0); // 0 offset
    
    //bind the color buff to shader
    _gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, verticesColorBuffer);
    _gl.vertexAttribPointer(_colorAttributeIndex,
                           4, WebGL.RenderingContext.FLOAT,
                           false, 0,
                           0);
  }
  

  void render() {
    _gl.viewport(0, 0, 500, 500);
    _gl.clear(WebGL.RenderingContext.COLOR_BUFFER_BIT | WebGL.RenderingContext.DEPTH_BUFFER_BIT);
    
    
    //draw the cube according to the index buffer
    _gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    _gl.drawElements(WebGL.RenderingContext.TRIANGLES, 36,
                    WebGL.RenderingContext.UNSIGNED_SHORT, 0);
  }
}