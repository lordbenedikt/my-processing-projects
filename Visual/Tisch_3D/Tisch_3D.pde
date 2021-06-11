void setup() {
  size(800,600,P3D);
}

void draw() {
  translate(400,300,-400);
  rotateX(-PI/7);
  rotateY(PI/5);
  table();
}

void table() {
  box(500,50,300);
  pushMatrix();
  translate(-240,175,140);
  box(20,300,20);
  popMatrix();
  pushMatrix();
  translate(240,175,140);
  box(20,300,20);
  popMatrix();
  pushMatrix();
  translate(-240,175,-140);
  box(20,300,20);
  popMatrix();
  pushMatrix();
  translate(240,175,-140);
  box(20,300,20);
  popMatrix();
}
