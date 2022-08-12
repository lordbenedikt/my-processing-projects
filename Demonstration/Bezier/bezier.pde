PVector a = new PVector(400, 100);
PVector b = new PVector(700, 500);
PVector ab = new PVector(a.x-300, b.y);
PVector[] points = new PVector[]{a, b, ab};

int iterations = 20;
PVector lastMousePos = new PVector(0, 0);
float selectRadius = 25;

void keyPressed() {
  if (keyCode==UP) {
    iterations++;
  }
  if (keyCode==DOWN) {
    iterations--;
  }
}

void setup() {
  size(800, 600);
}

void draw() {
  background(255);

  noStroke();
  for (var v : points) {
    fill(0);
    circle(v.x, v.y, 20);
    if (dist(mouseX, mouseY, v.x, v.y) < selectRadius) {
      fill(0, 100);
      circle(v.x, v.y, selectRadius*2);
    }
  }

  stroke(0);
  strokeWeight(1);
  line(a.x, a.y, ab.x, ab.y);
  line(ab.x, ab.y, b.x, b.y);

  var step = 1f / (iterations-1);

  for (int i = 0; i<iterations; i++) {
    var x = i * step;
    var v1 = getPointBetween(a, ab, x);
    var v2 = getPointBetween(ab, b, x);

    stroke(0);
    strokeWeight(1);
    line(v1.x, v1.y, v2.x, v2.y);
  }

  for (int i = 0; i<iterations; i++) {
    var x = i * step;
    var v1 = getPointBetween(a, ab, x);
    var v2 = getPointBetween(ab, b, x);
    noStroke();
    fill(255, 0, 0);
    var v = getPointBetween(v1, v2, x);
    circle(v.x, v.y, 10);
  }

  dragPoint();
  lastMousePos.x = mouseX;
  lastMousePos.y = mouseY;
}

void dragPoint() {
  if (mousePressed) {
    for (var p : points) {
      if (dist(lastMousePos.x, lastMousePos.y, p.x,p.y) < selectRadius) {
        p.x += mouseX - lastMousePos.x;
        p.y += mouseY - lastMousePos.y;
      }
    }
  }
}

PVector getPointBetween(PVector a, PVector b, float x) {
  return a.copy().mult(1-x).add(b.copy().mult(x));
}
