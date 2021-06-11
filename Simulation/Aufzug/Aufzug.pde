class Aufzug {
  float x;
  float y;
  float schachtHeight;
  float yCurrent;
  float h;
  Aufzug(float x, float y, float schachtHeight) {
    this.x = x;
    this.y = y;
    this.schachtHeight = schachtHeight;
    this.yCurrent = schachtHeight;
    this.h = schachtHeight/stockwerke;
  }
  void draw(float yCurrent) {
    fill(30);
    strokeWeight(3);
    rect(x, y, 50, schachtHeight);
    fill(60);
    line(x+20, y, x+20, y+yCurrent);
    line(x+30, y, x+30, y+yCurrent);
    rect(x, y+yCurrent, 50, h);
  }
}
