interface Prefab {
  void update();
}

class Table implements Prefab {
  float x;
  float y;
  PVector pivot = new PVector(50,48);
  SolidRect[] collisionBoxes;
  Table(float x, float y) {
    this.x = x;
    this.y = y;
    solidRects.add(new SolidRect(x-45, y-38, 90, 38, false));
  }
  void update() {
    image(tableIMG,x-pivot.x,y-pivot.y);
  }
}
