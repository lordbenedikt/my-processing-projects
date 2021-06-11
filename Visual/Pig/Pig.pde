void setup() {
  size(600,600);
}

void draw() {
  background(color(#d5fff6));
  stroke(0);
  fill(255,255,0);
  translate(300,300);
  pig();
}

void pig() {
  fill(color(#ffccaa));
  strokeWeight(3);
  ellipse(0,0,170,144); 
  earLeft(-55,-62);
  earRight(55,-62);
  noseMouth(0,33);
  eye(-30,-15);
  eye(30,-15);
}

void noseMouth(float x, float y) {
  stroke(0);
  strokeWeight(2);
  ellipse(x,y-8,60,45);
  ellipse(x,y,60,45);
  fill(0);
  ellipse(x-10,y,10,15);
  ellipse(x+10,y,10,15);
  line(x-46,y-7,x-30,y);
  line(x+46,y-7,x+30,y);
}

void eye(float x,float y) {
  noStroke();
  fill(0);
  ellipse(x,y,26,26);
  fill(255);
  ellipse(x+6,y-4,10,10);
  ellipse(x-8,y+4,7,7);
}

void earLeft(float x,float y) {
  triangle(x-25,y-25,x-20,y+25,x+25,y-5);
}

void earRight(float x,float y) {
  triangle(x+25,y-25,x+20,y+25,x-25,y-5);
}
