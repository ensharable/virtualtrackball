
part of WebGLUtils;

class ObjLoader{
  
  static Future<ObjectModel> parseObjectModelFromURL(String url){
    return HttpRequest.getString(url).then((String fileContents) {
      return readDataString(fileContents);
    });
  }
  
  static Future<Material> parseObjectTexureFromURL(String url){
    
    return HttpRequest.getString(url).then((String fileContents) {
      return readMaterialString(fileContents);
    });
  }
  
  static ObjectModel readDataString(String fileContents){
    List<String> linesContents = fileContents.split('\n');
    Iterator it = linesContents.iterator;
    
    String id;
    var vertices = new List();
    var facesIndices = new List();
    int verticesCount=0;
    int facesCount=0;
    String useMaterial;
    
    while(it.moveNext()){
      List<String> currentline = it.current.split(' ');
      if(currentline.elementAt(0)=='o'){
        id = currentline.elementAt(1);
      }else if(currentline.elementAt(0)=='usemtl'){
        useMaterial = currentline.elementAt(1);
      }else if(currentline.elementAt(0)=='v'){
        for(int i=1; i<currentline.length; i++){
          vertices.add(double.parse(currentline.elementAt(i)));
        }
        verticesCount++;
      }else if(currentline.elementAt(0)=='f'){
        for(int i=1; i<currentline.length; i++){
          //the WebGL index is zero base, but the obj file is 1 base
          facesIndices.add(int.parse(currentline.elementAt(i)) - 1);
        }
        facesCount++;
      }
    }
    
    print("vertces count: " + verticesCount.toString() + "\n" + vertices.toString());
    print("faces count: " + facesCount.toString() + "\n" + facesIndices.toString());
    
    return new ObjectModel(id, vertices, facesIndices, verticesCount, facesCount, useMaterial);
  }
  
  
  /*
   * 
   * Ka r g b
defines the ambient color of the material to be (r,g,b). The default is (0.2,0.2,0.2);
Kd r g b
defines the diffuse color of the material to be (r,g,b). The default is (0.8,0.8,0.8);
Ks r g b
defines the specular color of the material to be (r,g,b). This color shows up in highlights. The default is (1.0,1.0,1.0);
d alpha
defines the transparency of the material to be alpha. The default is 1.0 (not transparent at all) Some formats use Tr instead of d;
Tr alpha
defines the transparency of the material to be alpha. The default is 1.0 (not transparent at all). Some formats use d instead of Tr;
Ns s
defines the shininess of the material to be s. The default is 0.0;
illum n
denotes the illumination model used by the material. illum = 1 indicates a flat material with no specular highlights, so the value of Ks is not used. illum = 2 denotes the presence of specular highlights, and so a specification for Ks is required.
map_Ka filename
names a file containing a texture map, which should just be an ASCII dump of RGB values;
   */
  static Material readMaterialString(String fileContents){
    
    List<String> linesContents = fileContents.split('\n');
    Iterator it = linesContents.iterator;
    
    Material material = new Material();
    
    while(it.moveNext()){
      List<String> currentline = it.current.split(' ');
      if(currentline.elementAt(0)=='newmtl'){
        material.name=currentline.elementAt(1);
      }else if(currentline.elementAt(0)=='Ka'){
        material.ambient=[double.parse(currentline.elementAt(1)), double.parse(currentline.elementAt(3)), double.parse(currentline.elementAt(3))];
      }else if(currentline.elementAt(0)=='Ns'){
        material.shininessOfMateria = double.parse(currentline.elementAt(1));
      }else if(currentline.elementAt(0)=='Kd'){
        material.diffuse=[double.parse(currentline.elementAt(1)), double.parse(currentline.elementAt(3)), double.parse(currentline.elementAt(3))];
      }else if(currentline.elementAt(0)=='Ks'){
        material.specular=[double.parse(currentline.elementAt(1)), double.parse(currentline.elementAt(3)), double.parse(currentline.elementAt(3))];
      }else if(currentline.elementAt(0)=='d'){
        material.transparent=double.parse(currentline.elementAt(1));
      }else if(currentline.elementAt(0)=='illum'){
        material.illuminationMode=int.parse(currentline.elementAt(1));
      }else if(currentline.elementAt(0)=='map_Ka'){
        material.textureMap=currentline.elementAt(1);
      }
      
    }
    return material;
  }
}