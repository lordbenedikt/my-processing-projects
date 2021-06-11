class Rocket {
  PVector pos;
  PVector speed;
  Rocket(float x, float y, float xSpeed, float ySpeed) {
    pos = new PVector(x, y);
    speed = new PVector(xSpeed, ySpeed);
  }
  void update() {
    pos.add(speed);
    if(isCollidingPixels(this)) {
      hp -= 20;
      spawnExplosion(pos.x,pos.y,50);
      rockets.remove(this);
    }
  }
  void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(speed.x<0 ? PI : 0);
    imageMode(CENTER);
    image(rocketIMG, 0, 0);
    popMatrix();
  }
}

void spawnRocket() {
  if (0.1 > random(0, 1)) {
    float[] pos = posOutsideRoom();
    rockets.add(new Rocket(pos[0], pos[1], pos[0]<0?10:-10, 0));
  }
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
