class Rocket {
  PVector pos;
  PVector speed;
  Rocket(float x, float y, float xSpeed, float ySpeed) {
    pos = new PVector(x, y);
    speed = new PVector(xSpeed, ySpeed);
  }
  void update() {
    pos.add(speed);

    //draw rocket
    image(rocket, pos.x, pos.y);
  }
}

void spawnRocket() {
  float[] pos = posOutsideRoom();
  rockets.add(new Rocket(pos[0], pos[1], pos[0]<0?10:-10, 0));
}

void drawRockets() {
  for (Rocket r : rockets) {
    //fill(200, 106, 68);
    //ellipse(a.x, a.y, a.r*2, a.r*2);
    imageMode(CENTER);
    image(rocket, r.pos.x, r.pos.y, 50, 30);
  }
}
