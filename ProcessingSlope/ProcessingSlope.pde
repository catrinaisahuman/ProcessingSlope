// SlopeV2 BY WILLDEPUE && ELIJAHSMITH
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
float fov = 1.7;
int segmentOffset = 1; //leave this at 1 for now
int roadSegments = 30;
int sphereDetail = 12;
boolean doAnimation = false;
int tickSpeed = 1;
float rotationControl = 30; //less means more control
//these are relative in comparison to a 500x500 screen but will be adjusted before running
float sphereControl = 0.2;
float sphereSize = 50;
float speedx = 8; // in units per second
float segmentLength = 200; //if you go too low you may need to change segment offset a bit
PVector startingPos = new PVector(250, 275, 120);
PVector rectPos = new PVector(50, 350);

void setup() {
  size(500, 500, P3D);
  frameRate(60);
  textSize(128);
  makeRelative();
}

void makeRelative() {
  camPos.set(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0));
  rectPos.set(width * 0.1, height * 0.7);
  startingPos.mult(0.002);
  startingPos.set(width * startingPos.x, height * startingPos.y, width * startingPos.z);
  masterP.set(startingPos);
  segmentLength = segmentLength/500 * width;
  sphereSize = sphereSize/500 * width;
  speedx = speedx/500 * width;
  sphereControl = sphereControl/500 * width;
}

void draw() {
  if (dead) {
    time += tickSpeed;
    
    text("DEAD", width/2 - 0.4 * width, height/2,  time - 400); 
    text("PRESS X", width/2 - 0.4 * width, height/2 - 0.2 * height, time - 400);
    
    if ( time > 1000 ) {
      tickSpeed = 0; //timeout to stop text movement
    }

    checkRestart();
    
    //this section only runs on death
  } else {



    time += tickSpeed;
    background(150);
    camera(camPos.x, camPos.y - 0.4 * height, camPos.z + 0.08 * width, width/2.0, height/2.0, 0, 0, 1, 0);

    for (int i = 0; i < roadSegments; i++) {
      drawSegment(speedx * time % segmentLength, -1 * segmentLength * (i - segmentOffset));
    } //drawing all the segements of the road here

    if (masterP.x > 0.886 * width || masterP.x < 0.116 * width) {
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

void drawSegment(float move, float offset) {
  fill(204, 102, 0);
  pushMatrix();
  translate(rectPos.x, rectPos.y);
  rotateX(beginningSequence(doAnimation));
  rect(0, offset + move, 4 * width / 5, segmentLength);
  popMatrix();
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
    score = 0;
  }
}
