float camPosX;
float camPosY;
float camPosZ;
float time = 0;
final int gravity = 9.8;
final int friction = 0.1;
final int bounce = 0.1;

float d;
float fov = 1.7;

void setup() {
  size(500, 500, P3D);
  camPosX = width/2.0;
  camPosY = height/2.0;
  camPosZ = (height/2.0) / tan(PI*30.0 / 180.0);
}

void draw() {
  time++;
  background(255);

  camera(camPosX, camPosY, camPosZ, width/2.0, height/2.0, 0, 0, 1, 0);

  fill(0);
  pushMatrix();
  translate(50, 250);
  rotateX(PI/2.5);
  rect(0, 0, 400, 50);
  popMatrix();

  pushMatrix();
  translate(250, 200, 0);
  rotateX(time/50);
  noFill();
  sphereDetail(12);
  sphere(100);
  popMatrix();
}
