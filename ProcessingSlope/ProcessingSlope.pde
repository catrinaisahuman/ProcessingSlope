//spell wants something super simple very quickly so we can make a super shitty and non3d version
//just to show him early to get that over with

final float gravity = 9.8;
final float friction = 0.95;
final float bounce = 0.1;

float time = 1;
PVector masterV = new PVector(0, 0, 0);
PVector masterP = new PVector(250, 275, 120);
PVector camPos = new PVector();
PVector rectPos = new PVector(50, 350);
float fov = 1.7;
int segmentLength = 200; //if you go too low you may need to change segment offset a bit
int segmentOffset = 1; //leave this at 1 for now
float speedx = 8; // in units per second
float speedz = 1; // in units per second
float speedy = 0; // in units per second
int roadSegments = 15;
int spheResize = 50;
int spheRedetail = 12;
boolean doAnimation = false;
boolean[] keys = new boolean[4];

void setup() {
  size(500, 500, P3D);
  camPos.set(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0));
  frameRate(60);
}

void draw() {
  time += 1;
  background(150);
  camera(camPos.x, camPos.y - 200, camPos.z + 40, width/2.0, height/2.0, 0, 0, 1, 0);

  for (int i = 0; i < roadSegments; i++) {
    drawSegment(speedx * time % segmentLength, -1 * segmentLength * (i - segmentOffset));
  } //drawing all the segements of the road here

  drawSphere();
  updatePos();
}

void drawSegment(float move, int offset) {
  fill(204, 102, 0);
  pushMatrix();
  translate(rectPos.x, rectPos.y);
  rotateX(beginningSequence(doAnimation));
  rect(0, offset + move, 400, segmentLength);
  popMatrix();
  //speed += 0.0001;
  //println(time);
}

void drawSphere() {
  pushMatrix();
  translate(masterP.x, masterP.y, masterP.z);
  rotateX(speedx * time / spheResize);
  rotateZ(speedz * time / spheResize);
  rotateY(speedy * time / spheResize);
  //noFill();
  fill(23, 102, 0);
  sphereDetail(spheRedetail);
  sphere(spheResize);
  popMatrix();
}

float beginningSequence(boolean animate) {
  if (time < 200 && animate) {
    return time/200 * 9 * PI/16;
  } else return 9 * PI/16;
}



void keyPressed() {
  if (key=='w')
    keys[0]=true;
  if (key=='a')
    keys[1]=true;
  if (key=='s')
    keys[2]=true;
  if (key=='d')
    keys[3]=true;
}

void keyReleased() {
  if (key=='w')
    keys[0]=false;
  if (key=='a')
    keys[1]=false;
  if (key=='s')
    keys[2]=false;
  if (key=='d')
    keys[3]=false;
}

void updatePos() {
  masterV.mult(friction);
  
  
  if (keys[1]) {
    masterV = masterV.add(new PVector(-1, 0, 0));
  }

  if (keys[3]) {
    masterV = masterV.add(new PVector(1, 0, 0));
  }
  
  masterP = masterP.add(masterV);
}
