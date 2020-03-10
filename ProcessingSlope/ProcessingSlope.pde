// DESERTSLOPE BY WILLDEPUE && ELIJAHSMITH
//setup variables
PVector masterV = new PVector(0, 0, 0);
PVector masterP = new PVector();
PVector camPos = new PVector();
PVector randomMove = new PVector(0, 0, 0);
float time = 0;
boolean[] keys = new boolean[4];
boolean dead = false;
int score = 0;
float countdown = 400;
float countdownStorage = 0;
float waitingTime = 100;
int keycounter = 0; //basically what this does is track how long you've been holding a key down so we can mess with people
//config variables
final float gravity = 9.8;
final float friction = 0.95;
final float bounce = 0.1;
final int startingScore = 0;
final float tickSpeed = 1; //starter value of tickspeed
final float annoyWait = 200;
//more config variables
int segmentOffset = 1; //leave this at 1 for now
int roadSegments = 50;
int sphereDetail = 12;
boolean doAnimation = true;
float rotationRenderControl = 30; //less means more control
boolean doAnnoy = true;
//these are relative in comparison to a 500x500 screen but will be adjusted before running
float sphereControl = 0.2;
float sphereSize = 50;
float speedx = 8; // in units per second
float segmentLength = 200; //if you go too low you may need to change segment offset a bit
PVector startingPos = new PVector(250, 275, 120);
PVector rectPos = new PVector(50, 350);
PVector towerPosLeft = new PVector(50, 0, 0);
PVector towerPosRight = new PVector(950, 0, 0);
int towerSize = 100;
int towerSegments = 30;
boolean coolRenderMode = false;
float hardness = 1;
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
float rotateX, rotateZ;
float tickSpeedModified; //for modulating tickspeed inside draw()
Tower towerLeft1, towerLeft2, towerLeft3, towerLeft4, towerLeft5, towerLeft6, towerLeft7, towerLeft8, towerLeft9, towerLeft10;
Tower towerRight1, towerRight2, towerRight3, towerRight4, towerRight5, towerRight6, towerRight7, towerRight8, towerRight9, towerRight10;
float annoyWaitModified;
PFont font;

void setup() {
  font = createFont("Minecraft.otf", 32);
  size(1000, 1000, P3D);
  frameRate(60);
  textSize(128);
  makeRelative();
  smooth();
  if (coolRenderMode) {
    noStroke();
  }
  textFont(font);
  textAlign(CENTER);
  perspective(PI/3.0, width/height, camPos.z/10.0, camPos.z*200.0);
  initalizeTowers();
}



void draw() {
  fill(23, 102, 0);
  if ((score % 100) < 20 && score > 20) {
    ambientLight(20, 0, 0, width/2, 0, 0);
  } else {
    pointLight(255, 255, 255, 15* width/16, 0, 600);
    ambientLight(20, 90, 20, width/2, 0, 0);
  }

  rotateX = speedx * time / sphereSize;
  rotateZ = masterV.x/rotationRenderControl * time / sphereSize;

  if (dead) {
    time += tickSpeedModified;

    textSize(90);
    text("DEAD", camPos.x, camPos.y + 600, time - 0.8 * width); 

    text("PRESS X", camPos.x, camPos.y + 800, time - 0.8 * width);
    textSize(32);

    if ( time > 1000 ) {
      tickSpeedModified = 0; //timeout to stop text movement
    }
    masterV.set(0, 0, 0);
    randomMove.set(0, 0, 0);

    checkRestart();

    //this section only runs on death
  } else {
    time += tickSpeedModified;
    score = startingScore + floor(time/200);
    hardness = 1 + score * 0.000005;
    tickSpeedModified = tickSpeed + 0.04 * score;

    background(150);
    camera(camPos.x, camPos.y, camPos.z, camPos.x, camPos.y + 0.4 * height, 0, 0, 1, 0);

    drawRoad();
    towerLeft1.render();
    towerLeft2.render();
    towerLeft3.render();
    towerLeft4.render();
    towerLeft5.render();   
    towerLeft6.render();
    towerLeft7.render();
    towerLeft8.render();
    towerLeft9.render();
    towerLeft10.render();  
    towerRight1.render();
    towerRight2.render();
    towerRight3.render();
    towerRight4.render();
    towerRight5.render();
    towerRight6.render();
    towerRight7.render();
    towerRight8.render();
    towerRight9.render();
    towerRight10.render();
    drawSphere();

    checkDeath();
    updatePos();
    checkRestart();
    fuckYouDie();

    //pushMatrix();
    //text(score, camPos.x, camPos.y + 400, -900);

    //text(keycounter, camPos.x, camPos.y + 200, -900);
    //text(int(time), camPos.x, camPos.y, -900);
    //text("DEBUG", width/2, height/2 - 600, -900);
    //popMatrix();
    pushMatrix(); //debug text
    fill(0, 0, 0);
    text(score, width/2, height/2 - 200, -900);
    if (doAnnoy) {
      text("ANNOY ON", width/2, height/2 - 550, -900);
    } else {
      text("ANNOY OFF", width/2, height/2 - 550, -900);
    }

    text(hardness, width/2, height/2 - 450, -900);
    text("TIME : " + int(time), width/2, height/2 - 500, -900);
    text("DEBUG", width/2, height/2 - 600, -900);
    popMatrix();



    //text(score, 17, 1200 - 3.2 * (time % 500), -4700 + speedx * (time % 500));
    //pushMatrix();
    //translate(width/2, height/2, -900);
    ////fill(0,0,0);
    //////text(score, -40, 40, 200);
    //fill(255,0,0);
    //box(100);
    //popMatrix();

    println(countdown);
  }
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



void makeRelative() {  // makes most variables relative to screen size
  camPos.set(width/2.0, height/2.0 - 0.4 * height, (height/2.0) / tan(PI*30.0 / 180.0) + 0.08 * width);
  rectPos.set(width * 0.1, height * 0.7);
  startingPos.mult(0.002);
  startingPos.set(width * startingPos.x, height * startingPos.y, width * startingPos.z);
  masterP.set(startingPos);
  segmentLength = segmentLength/500 * width;
  sphereSize = sphereSize/500 * width;
  speedx = speedx/500 * width;
  sphereControl = sphereControl/500 * width;
}

int towerOffset(int i) {
  return -900 - 2000 * (i - 1);
}

int towerHeight(int i) {
  return 400 * (i - 2);
}

void initalizeTowers() {
  towerLeft1 =  new Tower(towerPosLeft.x, towerHeight(1), towerOffset(1), towerSegments);
  towerLeft2 =  new Tower(towerPosLeft.x, towerHeight(2), towerOffset(2), towerSegments);
  towerLeft3 =  new Tower(towerPosLeft.x, towerHeight(3), towerOffset(3), towerSegments);
  towerLeft4 =  new Tower(towerPosLeft.x, towerHeight(4), towerOffset(4), towerSegments);
  towerLeft5 =  new Tower(towerPosLeft.x, towerHeight(5), towerOffset(5), towerSegments);
  towerLeft6 =  new Tower(towerPosLeft.x, towerHeight(6), towerOffset(6), towerSegments);
  towerLeft7 =  new Tower(towerPosLeft.x, towerHeight(7), towerOffset(7), towerSegments);
  towerLeft8 =  new Tower(towerPosLeft.x, towerHeight(8), towerOffset(8), towerSegments);
  towerLeft9 =  new Tower(towerPosLeft.x, towerHeight(9), towerOffset(9), towerSegments);
  towerLeft10 = new Tower(towerPosLeft.x, towerHeight(10), towerOffset(10), towerSegments);

  towerRight1 =  new Tower(towerPosRight.x, towerHeight(1), towerOffset(1), towerSegments);
  towerRight2 =  new Tower(towerPosRight.x, towerHeight(2), towerOffset(2), towerSegments);
  towerRight3 =  new Tower(towerPosRight.x, towerHeight(3), towerOffset(3), towerSegments);
  towerRight4 =  new Tower(towerPosRight.x, towerHeight(4), towerOffset(4), towerSegments);
  towerRight5 =  new Tower(towerPosRight.x, towerHeight(5), towerOffset(5), towerSegments);
  towerRight6 =  new Tower(towerPosRight.x, towerHeight(6), towerOffset(6), towerSegments);
  towerRight7 =  new Tower(towerPosRight.x, towerHeight(7), towerOffset(7), towerSegments);
  towerRight8 =  new Tower(towerPosRight.x, towerHeight(8), towerOffset(8), towerSegments);
  towerRight9 =  new Tower(towerPosRight.x, towerHeight(9), towerOffset(9), towerSegments);
  towerRight10 =  new Tower(towerPosRight.x, towerHeight(10), towerOffset(10), towerSegments);
}
