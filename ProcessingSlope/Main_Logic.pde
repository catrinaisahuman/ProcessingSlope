void updatePos() {
  masterV.mult(friction);


  if (keys[1]) {
    masterV = masterV.add(new PVector(-sphereControl * hardness, 0, 0));
  }

  if (keys[3]) {
    masterV = masterV.add(new PVector(sphereControl * hardness, 0, 0));
  }

  masterP = masterP.add(masterV);
  camPos = camPos.add(masterV);

  if (doAnnoy) {
    countdown += -tickSpeedModified;
    println(countdown);
    if (countdown <= 0) {
      annoy();
    } else if (countdown > annoyWait && countdown - countdownStorage - annoyWait < 0) {
      masterV.add(randomMove.mult(hardness));
    }
  }
}

void checkRestart() {
  if (keys[2]) {
   restart();
   startingScore = 0;
   checkpointUsed = false;
  }
  if (keys[0]) {
   restart();
   startingScore = checkpoint;
   checkpointUsed = true;
  }
}

void restart() {
   time = 0;
    tickSpeedModified = tickSpeed;
    masterP.set(startingPos);
    masterV.set(0, 0, 0);
    dead = false;
    score = 0;
    countdown = 400;
    annoyWaitModified = 200;
    camPos.set(width/2.0, height/2.0 - 0.4 * height, (height/2.0) / tan(PI*30.0 / 180.0) + 0.08 * width);
}

void annoy() {
  float y = random(-1, 1);
  y = y/abs(y);
  float x = y * random(0.2, 0.42);
  randomMove.set(x, 0, 0);
  annoyWaitModified = annoyWait * tickSpeedModified;
  waitingTime = tickSpeedModified * int(random(-100, 100));
  countdownStorage = tickSpeedModified * int(random(100, 1000));
  countdown = waitingTime + annoyWaitModified + countdownStorage;
}


void fuckYouDie() {
  if (keys[1] || keys[3]) {
    keycounter += 1;
  } else keycounter = 0; genGracePeriod();

  if (keycounter >= keyHoldGracePeriod) { //because predictability is wrong
    randomMove.mult(-1); //reverse the direction of the drift
    keycounter = 0; //set counter back
  }
}


void checkDeath() {
  if (masterP.x > 0.886 * width || masterP.x < 0.116 * width) {
    dead = true;
    time = 0;
  }
}


void genGracePeriod() {
  keyHoldGracePeriod = int(random(20, 120));
}
