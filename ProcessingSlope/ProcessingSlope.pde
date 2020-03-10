// DESERTSLOPE BY WILLDEPUE && ELIJAHSMITH
//setup variables
PVector masterV = new PVector(0, 0, 0);
PVector masterP = new PVector();
PVector camPos = new PVector();
float time = 0;
boolean[] keys = new boolean[4];
boolean dead = false;
int score = 0;
//setup variables

//config variables
final float gravity = 9.8;
final float friction = 0.95;
final float bounce = 0.1;
//more config variables
PVector startingPos = new PVector(250, 275, 120);
PVector rectPos = new PVector(50, 350);
float fov = 1.7;
int segmentLength = 200; //if you go too low you may need to change segment offset a bit
int segmentOffset = 1; //leave this at 1 for now
float speedx = 8; // in units per second
int roadSegments = 30;
int sphereSize = 50;
int sphereDetail = 12;
boolean doAnimation = true;
float sphereControl = 0.2;
int tickSpeed = 2;
float rotationControl = 30; //less means more control

void setup() {
  size(500, 500, P3D);
  camPos.set(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0));
  frameRate(60);
  masterP.set(startingPos);
  textSize(128);
}

void draw() {
  if (dead) {
    time += tickSpeed;
    
    text("DEAD", width/2 - 200, height/2, -400 + time); 
    text("PRESS X", width/2 -200, height/2 - 100, -400 + time);
    
    if ( time > 1000 ) {
      tickSpeed = 0; //timeout to stop text movement
    }

    checkRestart();
    
    //this section only runs on death
  } else {



    time += tickSpeed;
    background(150);
    camera(camPos.x, camPos.y - 200, camPos.z + 40, width/2.0, height/2.0, 0, 0, 1, 0);

    for (int i = 0; i < roadSegments; i++) {
      drawSegment(speedx * time % segmentLength, -1 * segmentLength * (i - segmentOffset));
    } //drawing all the segements of the road here

    if (masterP.x > 443 || masterP.x < 58) {
      dead = true;
      time = 0;
    }
    println(score);

    drawSphere();
    updatePos();
    checkRestart();

    score = floor(time/200);
  }
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
  rotateX(speedx * time / sphereSize);
  rotateZ(masterV.x/rotationControl * time / sphereSize);
  //noFill();
  fill(23, 102, 0);
  sphereDetail(sphereDetail);
  sphere(sphereSize);
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
  if (key=='a' || keyCode == LEFT)
    keys[1]=true;
  if (key=='x')
    keys[2]=true;
  if (key=='d' || keyCode == RIGHT)
    keys[3]=true;
}

void keyReleased() {
  if (key=='w')
    keys[0]=false;
  if (key=='a' || keyCode == LEFT)
    keys[1]=false;
  if (key=='x')
    keys[2]=false;
  if (key=='d' || keyCode == RIGHT)
    keys[3]=false;
}

void updatePos() {
  masterV.mult(friction);

  if (keys[1]) {
    masterV = masterV.add(new PVector(-sphereControl, 0, 0));
  }

  if (keys[3]) {
    masterV = masterV.add(new PVector(sphereControl, 0, 0));
  }

  masterP = masterP.add(masterV);
}

void checkRestart() {
  if (keys[2]) {
    time = 0;
    tickSpeed = 1;
    masterP.set(startingPos);
    masterV.set(0, 0, 0);
    dead = false;
  }
}
