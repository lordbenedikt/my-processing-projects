class Person {
  float x, y, h;
  Person(float x, float y, float h) {
    this.x = x;
    this.y = y;
    this.h = h;
  }
  void draw() {
    float w = h/3;

    //body
    strokeWeight(3);
    line(x+w/2, y+w/4, x+w/2, y+h/2);

    //feet
    strokeWeight(3);
    line(x+w/2, y+h/2, x, y+h);
    line(x+w/2, y+h/2, x+w, y+h);

    //arms
    strokeWeight(3);
    line(x+w/2, y+h/8, x, y+h/2.5);
    line(x+w/2, y+h/8, x+w, y+h/2.5);

    //head
    strokeWeight(1);
    circle(x+w/2, y, w/1.5);
  }
}
