class Apple {
  int pos;
  int maxPos;
  Apple(int maxPos) {
    this.maxPos = maxPos;
    pos = r.nextInt(maxPos);
  }
  void eat() {
    pos = r.nextInt(maxPos);
  }
  void draw() {
    fill(255,0,0);
    ellipse((pos%screen.cols+0.5)*(screen.w/screen.cols), (pos/screen.cols+0.5)*screen.h/screen.rows, screen.w/screen.cols+0.2, screen.h/screen.rows+0.2);
  }
}
