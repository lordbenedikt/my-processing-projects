void setup() {
  size(500, 500);
}

void draw() {
  background(255);
  
  stroke(150);
  for (int i = 1; i<width/50; i++) {
    line(i*50, 0, i*50, height);
    text(i*50, i*50, 20);
  }
  for (int i = 1; i<height/50; i++) {
    line(0, i*50, width, i*50);
    text(i*50, 20, i*50);
  }

  stroke(255,0,0);
  line(mouseX, 0, mouseX, mouseY+20);
  line(0, mouseY, mouseX+20, mouseY);
  fill(0);
  textAlign(CENTER, CENTER);
  text(mouseX, mouseX, mouseY+30);
  text(mouseY, mouseX+35, mouseY);
}
