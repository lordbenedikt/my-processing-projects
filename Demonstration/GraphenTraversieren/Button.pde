class Button {
  String label;
  float w;
  float h;
  float x;
  float y;
  Button(float x, float y, float w, float h, String label) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  void drawThis() {
    press();
    button(x, y, w, h, algorithm.equals(label), 2);
    fill(0);
    textAlign(CENTER, CENTER);
    text(label, x+w/2, y+h/2);
  }
  void press() {
    if (mouseWasPressed==0) {
      if (insideRect(mouseX, mouseY, x, y, x+w, y+h)) {
        algorithm = label;
      }
    }
  }
}
