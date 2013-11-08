part of objectviewer;

Matrix4 makeViewMatrixWithDirection(Vector3 cameraPosition, Vector3 cameraFocusDirection,
                    Vector3 upDirection) {
  Matrix4 r = new Matrix4.zero();
  setViewMatrixWithDirection(r, cameraPosition, cameraFocusDirection, upDirection);
  return r;
}

void setViewMatrixWithDirection(Matrix4 viewMatrix, Vector3 cameraPosition,
                   Vector3 cameraFocusDirection, Vector3 upDirection) {
  Vector3 z = cameraFocusDirection;
  negOfVec3(z);
  z.normalize();
  print(z.toString());
  
  Vector3 x = upDirection.cross(z);
  x.normalize();
  Vector3 y = z.cross(x);
  y.normalize();
  viewMatrix.setZero();
  viewMatrix.setEntry(3, 3, 1.0);
  viewMatrix.setEntry(0, 0, x.x);
  viewMatrix.setEntry(1, 0, x.y);
  viewMatrix.setEntry(2, 0, x.z);
  viewMatrix.setEntry(0, 1, y.x);
  viewMatrix.setEntry(1, 1, y.y);
  viewMatrix.setEntry(2, 1, y.z);
  viewMatrix.setEntry(0, 2, z.x);
  viewMatrix.setEntry(1, 2, z.y);
  viewMatrix.setEntry(2, 2, z.z);
  viewMatrix.transpose();
  Vector3 rotatedEye = viewMatrix * -cameraPosition;
  viewMatrix.setEntry(0, 3, rotatedEye.x);
  viewMatrix.setEntry(1, 3, rotatedEye.y);
  viewMatrix.setEntry(2, 3, rotatedEye.z);
}

void negOfVec3(Vector3 v){
  v.x = (v.x == 0)?v.x : 0.0-v.x;
  v.y = (v.y == 0)?v.y : 0.0-v.y;
  v.z = (v.z == 0)?v.z : 0.0-v.z;
}

/*
void setViewMatrix(Matrix4 viewMatrix, Vector3 cameraPosition,
                   Vector3 cameraFocusPosition, Vector3 upDirection) {
  Vector3 z = cameraPosition - cameraFocusPosition;
  z.normalize();
  Vector3 x = upDirection.cross(z);
  x.normalize();
  Vector3 y = z.cross(x);
  y.normalize();
  viewMatrix.setZero();
  viewMatrix.setEntry(3, 3, 1.0);
  viewMatrix.setEntry(0, 0, x.x);
  viewMatrix.setEntry(1, 0, x.y);
  viewMatrix.setEntry(2, 0, x.z);
  viewMatrix.setEntry(0, 1, y.x);
  viewMatrix.setEntry(1, 1, y.y);
  viewMatrix.setEntry(2, 1, y.z);
  viewMatrix.setEntry(0, 2, z.x);
  viewMatrix.setEntry(1, 2, z.y);
  viewMatrix.setEntry(2, 2, z.z);
  viewMatrix.transpose();
  Vector3 rotatedEye = viewMatrix * -cameraPosition;
  viewMatrix.setEntry(0, 3, rotatedEye.x);
  viewMatrix.setEntry(1, 3, rotatedEye.y);
  viewMatrix.setEntry(2, 3, rotatedEye.z);
}
*/