part of objectviewer;

class Shapes{
  WebGL.RenderingContext _gl;
  WebGL.Program _program;
  
  Shapes(WebGL.RenderingContext gl, WebGL.Program p){
    this._gl=gl;
    this._program=p;
  }
}