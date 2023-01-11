class UFO {
  PVector pos;
  PVector revolveCenter;
  PVector speed;
  float startingAngle;

  UFO(float x, float y, float xSpeed, float ySpeed) {
    revolveCenter = new PVector(x, y);
    pos = new PVector(x, y);
    speed = new PVector(xSpeed, ySpeed);
    startingAngle = random(TWO_PI);
  }
  void update() {
    if (pos.x < -500 || pos.x > viewWidth+500 || pos.y < -500 || pos.y > viewHeight+500)
      rockets.remove(this);
    revolveCenter.add(speed);
    pos = revolveCenter.copy();
    pos.x += 200*sin(startingAngle+frameCount/30f);
    if (collWithPlayer()) {
      hp -= 20;
      spawnExplosion(pos.x, pos.y, 50);
      UFOs.remove(this);
    }
  }
  void draw() {
    draw(g);
  }
  void draw(PGraphics pG) {
    pG.pushMatrix();
    pG.translate(pos.x, pos.y);
    pG.imageMode(CENTER);
    pG.image(UFOIMG, 0, 0);
    pG.popMatrix();
  }
  boolean collWithPlayer() {
    if (dist(pos.x, pos.y, jens_x, jens_y) > UFOIMG.width/2 + jens.width/2)
      return false;
    pC.beginDraw();
    pC.clear();
    pC.tint(0, 255, 0, 200);
    drawJens(pC);
    pC.tint(255, 0, 0, 200);
    draw(pC);
    pC.endDraw();

    int xMin = (int)(pos.x-UFOIMG.width/2);
    int xMax = (int)(pos.x+UFOIMG.width/2);
    int yMin = (int)(pos.y-UFOIMG.height/2);
    int yMax = (int)(pos.y+UFOIMG.height/2);
    for (int y = yMin; y<yMax; y++) {
      if (y<0 || y>=viewHeight) continue;
      for (int x = xMin; x<xMax; x++) {
        if (x<0 || x>=viewWidth) continue;
        color c = pC.pixels[y*width+x];
        if ((red(c)>0)&&(green(c)>0))
          return true;
      }
    }
    pC.updatePixels();  

    return false;
  }
}

void spawnUFO() {
  float[] pos = posTopOrBottom();
  UFOs.add(new UFO(pos[0], pos[1], 0, pos[1]<0?3:-3));
}
void drawUFOs() {
  for (UFO u : UFOs) {
    u.draw();
  }
}

void moveUFOs() {
  int i = 0;
  while (i<UFOs.size()) {
    int prevSize = UFOs.size();
    UFOs.get(i).update();
    if (UFOs.size()==prevSize) {
      i++;
    }
  }
}
