part of WebGLUtils;

class ObjectViewerLightShader {
  Shader shader;
  WebGL.Program get program => shader.program;
  WebGL.RenderingContext gl;
  WebGL.UniformLocation mvUniformLocation;
  WebGL.UniformLocation pUniformLocation;
  Float32List _mvUniform;
  Float32List _pUniform;
  

  ObjectViewerLightShader(WebGL.RenderingContext gl) {
    this.gl = gl;
    shader = new Shader(_vertexShader, _fragmentShader);
    _mvUniform = new Float32List(16);
    _pUniform = new Float32List(16);
    
  }

  void prepare() {
    shader.compile(gl);
    shader.link(gl);
    mvUniformLocation  = gl.getUniformLocation(program, 'uMVMatrix');
    pUniformLocation = gl.getUniformLocation(program, 'uPMatrix');
  }

  void enable() {
    gl.useProgram(program);
  }

  set mvUniform(Matrix4 m) {
    m.copyIntoArray(_mvUniform);
    gl.uniformMatrix4fv(mvUniformLocation, false, _mvUniform);
  }

  set pUniform(Matrix4 m) {
    m.copyIntoArray(_pUniform);
    gl.uniformMatrix4fv(pUniformLocation, false, _pUniform);
  }
  
 


  final String _vertexShader = '''
      attribute highp vec3 aVertexNormal;
      attribute highp vec3 aVertexPosition;
      
      uniform highp mat4 uMVMatrix;
      uniform highp mat4 uPMatrix;
      
      varying highp vec3 vLighting;
      
      void main(void) {
        gl_Position = uPMatrix * uMVMatrix * vec4(aVertexPosition, 1.0);

  
        highp vec3 materialDiffuseColor=vec3(0.1, 0.0, 0.0);
        highp vec3 uLightPos = vec3(3.0, 3.0, 3.0);        

        
        // Apply lighting effect
        highp vec3 modelViewVertex = vec3(uMVMatrix * vec4(aVertexPosition, 1.0)); 
        highp vec3 modelViewNormal = vec3(uMVMatrix * vec4(aVertexNormal, 0.0));
        highp float distance = length(uLightPos - modelViewVertex);
  
        highp vec3 lightVector = normalize(uLightPos - modelViewVertex); 
        highp float diffuse = max(dot(modelViewNormal, lightVector), 0.1);
        diffuse = diffuse * (1.0 / (1.0 + (0.25 * distance * distance)));
        vLighting = materialDiffuseColor * diffuse;
 
      }
  ''';

  final String _fragmentShader = '''
    varying highp vec3 vLighting;
    
    void main(void) {
      gl_FragColor = vec4(vLighting, 0);
    }
  ''';
  
}