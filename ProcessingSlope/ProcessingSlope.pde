int camPosX = 0;
int camPosY = 0;
int camPosZ = 1;
float d;
float fov = 1.7;

void setup() {
  size(500, 500);
  d = 1/tan(fov/2);
}

void draw() {
  background(0);

  loadPixels();
  for (int x=-50; x<50; x++) {
    for (int y=-50; y<50; y++) {
      for (int z=-50; z<50; z++) {
        if (x == 1) {
          float xProj = x*(d/z);
          float yProj = y*(d/z);
          float xScreen = (width/2) + (width/2)*xProj;
          float yScreen = (height/2) + (height/2)*yProj;
          if (xScreen < width && yScreen < height && xScreen > 0 && yScreen > 0) {
            pixels[int(yScreen*width + xScreen)] = color(255);
          }
        }
      }
    }
  }
  updatePixels();
}
