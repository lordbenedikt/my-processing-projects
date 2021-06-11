class Screen {
  float x;
  float y;
  float w;
  float h;
  int rows;
  int cols;
  Player player;
  Apple apple;
  Screen(float w, float h, int rows, int cols) {
    this.w = w;
    this.h = h;
    this.rows = rows;
    this.cols = cols;
    player = new Player(rows, cols, w, h);
    apple = new Apple(rows*cols);
  }
  void update() {
    player.update();
  }
  void draw() {
    pushMatrix();
    translate(x, y);
    noStroke();
    fill(50);
    rect(0, 0, w, h);
    player.draw();
    apple.draw();
    popMatrix();
  }
}
