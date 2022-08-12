Line l1 = new Line(new PVector(120, 400), new PVector(500, 100));
Line l2 = new Line(new PVector(80, 100), new PVector(mouseX, mouseY));

void setup() {
  size(640, 480);
  strokeWeight(10);
}

void draw() {
  // Update p4 to mouse position
  l2.b.x = mouseX;
  l2.b.y = mouseY;

  // Draw lines
  background(200);
  line(l1.a.x, l1.a.y, l1.b.x, l1.b.y);
  line(l2.a.x, l2.a.y, l2.b.x, l2.b.y);
  float dot =
    PVector.dot(
    l1.b.copy().sub(l1.a),
    new PVector(mouseX, mouseY).sub(l1.a)
    ) / PVector.dot(
    l1.b.copy().sub(l1.a), l1.b.copy().sub(l1.a)) * pow(l1.mag(), 2);
  println(dot);
  
}

boolean pointCircle(PVector p, Circle c) {
  return dist(p.x, p.y, c.center.x, c.center.y) < c.r;
}

boolean circleLine(Circle c, Line l) {
  if (pointCircle(l.a, c) || pointCircle(l.b, c)) {
    return true;
  }
  return false;
}

boolean lineLine(Line l1, Line l2) {
  return false;
}
