//spell wants something super simple very quickly so we can make a super shitty and non3d version
//just to show him early to get that over with

final float gravity = 9.8;
final float friction = 0.1;
final float bounce = 0.1;

PVector camPos = new PVector(0, 0, 0);
float time = 0;
float fov = 1.7;
int segmentlength = 200; //if you go too low you may need to change segment offset a bit
int segmentoffset = 1; //leave this at 1 for now
float speed = 2;
int roadsegments = 15;
int spheresize = 50;


void setup() {
  size(500, 500, P3D);
  camPos.set(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0));
  frameRate(60);
}

void draw() {
  time += 1;
  background(150);
  camera(camPos.x, camPos.y, camPos.z, width/2.0, height/2.0, 0, 0, 1, 0);

  for (int i = 0; i < roadsegments; i++) {
    drawsegment(speed * time % segmentlength, -1 * segmentlength * (i - segmentoffset));
  } //drawing all the segements of the road here

  drawsphere();
}

void drawsegment(float move, int offset) {
  fill(204, 102, 0);
  pushMatrix();
  translate(50, 300);
  rotateX(beginningsequence());
  rect(0, offset + move, 400, segmentlength);
  popMatrix();

  //speed += 0.0001;
  //println(time);
}

void drawsphere() {
  pushMatrix();
  translate(250, 285, 120);
  rotateX(speed * time / spheresize);
  //noFill();
  fill(23, 102, 0);
  sphereDetail(12);
  sphere(spheresize);
  popMatrix();
}

float beginningsequence() {
  if (time < 200) {
    return time * PI/2.5 * 1/200;
  } else return PI/2.5;
}
