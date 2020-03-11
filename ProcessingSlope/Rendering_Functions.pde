class Tower {
  PVector position = new PVector(0, 0, 0);
  int segmentsx;
  Tower(float x, float y, float z, int segments) {
    position.set(x, y, z);
    segmentsx = segments;
  }

  void render() {
    for (int i = 0; i < segmentsx; i++) {
      drawBox(speedx * (time % 125), towerSize * i - 3.2 * (time % 125));
    }
  }

  void drawBox(float move, float offset) {
    fill(38, 100, 100);
    pushMatrix();
    translate(position.x, position.y + offset, position.z + move);
    box(towerSize);
    popMatrix();
  }
  
}


void drawRoad() {
  for (int i = 0; i < roadSegments; i++) {
    drawSegment(speedx * time % segmentLength, -1 * segmentLength * (i - segmentOffset));
  } //drawing all the segements of the road here
}


void drawSegment(float move, float offset) {
  fill(38, 100, 100);
  pushMatrix();
  translate(rectPos.x, rectPos.y);
  rotateX(beginningSequence(doAnimation));
  rect(0, offset + move, 4 * width / 5, segmentLength);
  popMatrix();
}

void drawSphere() {
  pushMatrix();
  translate(masterP.x, masterP.y, masterP.z);
  rotateX(rotateX);
  rotateZ(rotateZ);
  //noFill();
  fill(23, 100, 100);
  sphereDetail(sphereDetail);
  sphere(sphereSize);
  popMatrix();
}



float beginningSequence(boolean animate) {
  if (time < 200 && animate) {
    return time/200 * 9 * PI/16;
  } else return 9 * PI/16;
}
