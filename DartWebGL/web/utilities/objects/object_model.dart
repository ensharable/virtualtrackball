part of WebGLUtils;

class ObjectModel{
  String id;
  List<double> vertics;
  List<int> facesIndices;
  int verticsCount=0;
  int facesCount=0;
  
  int vertexStride=0;
  int positionAttributeIndex;
  int colorAttributeIndex;
  
  String useMaterial;
  
  ObjectModel(String id, List<double> vertics, List<int> facesIndices, int verticsCount, int facesCount, String useMaterial){
    this.id=id;
    this.vertics=vertics;
    this.facesIndices=facesIndices;
    
    this.verticsCount=verticsCount;
    this.facesCount=facesCount;
    this.useMaterial=useMaterial;
  }

}