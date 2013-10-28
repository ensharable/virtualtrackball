part of objectviewer;

class Box{
  static WebGL.Buffer indexBuffer;
  static WebGL.Buffer vertexBuffer;
  static WebGL.Buffer verticesColorBuffer;
  static int _vertexCount=36;  //this is becuse of the box data
  static int _vertexStride=0; //this is becuse of the box data
  static int _positionAttributeIndex;
  static int _colorAttributeIndex;
  
  static void setup(WebGL.RenderingContext gl) {
    assert(gl != null);

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
    vertexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    //cover the arry to Float32List
    var vertexArray = new Float32List.fromList(vertices);
    //fill the buff using the data in Float32List
    gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER,
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
    verticesColorBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, verticesColorBuffer);
    gl.bufferDataTyped(WebGL.RenderingContext.ARRAY_BUFFER, colorArray,
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
    indexBuffer = gl.createBuffer();
    gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferDataTyped(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER,
                  indexArray,
                  WebGL.RenderingContext.STATIC_DRAW);
  }
  
  static void bindToProgram(WebGL.RenderingContext gl, WebGL.Program program) {
    _positionAttributeIndex = gl.getAttribLocation(program, 'aVertexPosition');
    gl.enableVertexAttribArray(_positionAttributeIndex);
    _colorAttributeIndex = gl.getAttribLocation(program, 'aVertexColor');
    gl.enableVertexAttribArray(_colorAttributeIndex);
  }

  static void prerender(WebGL.RenderingContext gl) {
    //bind the vertex buff to shader   
    //gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, vertexBuffer);
    gl.vertexAttribPointer(_positionAttributeIndex,
                           3, WebGL.RenderingContext.FLOAT, // 3 floats
                           false, 0,
                           0); // 0 offset
    
    //bind the color buff to shader
    //gl.bindBuffer(WebGL.RenderingContext.ARRAY_BUFFER, verticesColorBuffer);
    gl.vertexAttribPointer(_colorAttributeIndex,
                           4, WebGL.RenderingContext.FLOAT,
                           false, 0,
                           0);
  }

  static void render(WebGL.RenderingContext gl) {
    gl.clear(WebGL.RenderingContext.COLOR_BUFFER_BIT | WebGL.RenderingContext.DEPTH_BUFFER_BIT);
    //draw the cube according to the index buffer
    gl.bindBuffer(WebGL.RenderingContext.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.drawElements(WebGL.RenderingContext.TRIANGLES, 36,
                    WebGL.RenderingContext.UNSIGNED_SHORT, 0);
  }
}