PVector center;

float r = 200;
int n = 2;

void setup() {
  size(800, 600);
  center = new PVector(width/2, height/2);
}

PVector rotZ(PVector pos, float angle) {
  float x = pos.x * cos(angle) + pos.y * sin(angle);
  float y = pos.x * -sin(angle) + pos.y * cos(angle);
  return new PVector(x, y);
}

void draw() {
  n = mouseX / (width/30) + 2;
  //n++;
  
  background(0);
  noFill();
  stroke(255);
  strokeWeight(4);

  pushMatrix();
  translate(center.x, center.y);
  circle(0, 0, 2*r);
  PVector p = new PVector(0, -r);
  for (int i = 0; i<n; i++) {
    stroke(255);
    line(0, 0, p.x, p.y);
    PVector pPrev = p;
    p = rotZ(p, TWO_PI/n);
    stroke(255,0,0);
    line(pPrev.x, pPrev.y, p.x, p.y);
  }
  popMatrix();
  
  float alpha = TWO_PI/(2*n);
  float opposite = sin(alpha)*r;
  float circumference = opposite * 2*n;
  float pi = circumference / (2*r);
  textSize(100);
  text(pi, 0, 100);
  print(pi + "\n");
}
