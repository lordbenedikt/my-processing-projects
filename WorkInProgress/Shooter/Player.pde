class Bullet implements Drawable {
  float x;
  float y;
  float xSpeed;
  float ySpeed;
  Bullet(float x, float y, PVector dir, float speed) {
    this.x = x;
    this.y = y;
    this.xSpeed = dir.x * speed;
    this.ySpeed = dir.y * speed;
  }
  void update() {
    x += xSpeed;
    y += ySpeed;
    drawThis(g);
  }
  PVector getPos() {
    return new PVector(x,y);
  }
  PImage getImage() {
    return createGraphics(5,5);
  }
  void drawThis(PGraphics graphics) {
    graphics.noStroke();
    graphics.fill(100);
    graphics.pushMatrix();
    graphics.translate(x, y);
    graphics.circle(x, y, 5);
    graphics.popMatrix();
  }
}

class Player implements Drawable {
  float x;
  float y;
  float rot;
  float speed = 4;
  int reloadTime = 10;
  int reload = reloadTime;
  Player(float x, float y) {
    this.x = x;
    this.y = y;
  }
  PImage getImage() {
    return image_rocket;
  }
  PVector getPos() {
    return new PVector(x, y);
  }
  void shoot() {
    bullets.add(new Bullet(x, y, new PVector(mouseX-x, mouseY-y).normalize(), 10));
    reload = reloadTime;
  }
  void update() {

    if (reload!=0) {
      reload--;
    }
    if (mousePressed && mouseButton==LEFT) {
      if (reload==0) {
        shoot();
      }
    }

    PVector dir = new PVector(0, 0);
    if (keyIsDown('W')) {
      dir.y -= 1;
    }
    if (keyIsDown('S')) {
      dir.y += 1;
    }
    if (keyIsDown('A')) {
      dir.x -= 1;
    }
    if (keyIsDown('D')) {
      dir.x += 1;
    }
    dir.normalize().mult(speed);
    x += dir.x;
    y += dir.y;
    drawThis(g);
  }
  void drawThis(PGraphics graphics) {
    graphics.fill(255);
    graphics.noStroke();
    graphics.pushMatrix();
    graphics.translate(x, y);
    graphics.rotate(rot);
    graphics.circle(0, 0, 50);
    graphics.popMatrix();
  }
}
