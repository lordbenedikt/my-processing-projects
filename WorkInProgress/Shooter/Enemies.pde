class Ufo implements Drawable {
  float x;
  float y;
  float rot;
  Ufo(float x, float y) {
    this.x = x;
    this.y = y;
  }
  PImage getImage() {
    return image_rocket;
  }
  PVector getPos() {
    return new PVector(x,y);
  }
  void update() {
    drawThis(g);
  }
  void drawThis(PGraphics graphics) {
    graphics.pushMatrix();
    graphics.translate(x, y);
    graphics.rotate(rot);
    graphics.image(image_ufo, 0, 0);
    graphics.popMatrix();
  }
}

class Rocket implements Drawable {
  float x;
  float y;
  float rot;
  Rocket(float x, float y) {
    this.x = x;
    this.y = y;
  }
  PImage getImage() {
    return image_rocket;
  }
  PVector getPos() {
    return new PVector(x,y);
  }
  void update() {
    drawThis(g);
  }
  void drawThis(PGraphics graphics) {
    graphics.pushMatrix();
    graphics.translate(x, y);
    graphics.rotate(rot);
    graphics.image(image_rocket, 0, 0);
    graphics.popMatrix();
  }
}
