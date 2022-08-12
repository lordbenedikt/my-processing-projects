class Line {
  PVector a;
  PVector b;
  Line(PVector a, PVector b) {
    this.a = a;
    this.b = b;
  }
  float mag() {
    return dist(a.x,a.y,b.x,b.y);
  }
}
