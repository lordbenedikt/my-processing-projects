class Rocket {
  PVector pos;
  PVector speed;
  Rocket(float x, float y, float xSpeed, float ySpeed) {
    pos = new PVector(x, y);
    speed = new PVector(xSpeed, ySpeed);
  }
  void update() {
    if (pos.x < -500 || pos.x > viewWidth+500 || pos.y < -500 || pos.y > viewHeight+500)
      rockets.remove(this);
    pos.add(speed);
    if (collWithPlayer()) {
      hp -= 20;
      spawnExplosion(pos.x, pos.y, 50);
      rockets.remove(this);
    }
  }
  void draw() {
    draw(g);
  }
  void draw(PGraphics pG) {
    pG.pushMatrix();
    pG.translate(pos.x, pos.y);
    pG.rotate(speed.x<0 ? PI : 0);
    pG.imageMode(CENTER);
    pG.image(rocketIMG, 0, 0);
    pG.popMatrix();
  }
  boolean collWithPlayer() {
    if (dist(pos.x,pos.y,jens_x,jens_y) > rocketIMG.width/2 + jens.width/2)
      return false;
    pC.beginDraw();
    pC.clear();
    pC.tint(0, 255, 0, 200);
    drawJens(pC);
    pC.tint(255, 0, 0, 200);
    draw(pC);
    pC.endDraw();

    int xMin = (int)(pos.x-rocketIMG.width/2);
    int xMax = (int)(pos.x+rocketIMG.width/2);
    int yMin = (int)(pos.y-rocketIMG.height/2);
    int yMax = (int)(pos.y+rocketIMG.height/2);
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

void spawnRocket() {
    float[] pos = posLeftOrRight();
    rockets.add(new Rocket(pos[0], pos[1], pos[0]<0?10:-10, 0));
}
void drawRockets() {
  for (Rocket r : rockets) {
    r.draw();
  }
}

void moveRockets() {
  int i = 0;
  while (i<rockets.size()) {
    int prevSize = rockets.size();
    rockets.get(i).update();
    if (rockets.size()==prevSize) {
      i++;
    }
  }
}
