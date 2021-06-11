PGraphics pgCollision;
boolean collDetected = false;

void setup() {
  size(600, 600);
  pgCollision = createGraphics(width, height);
}

void draw() {
  clear();

  pgCollision.beginDraw();
  pgCollision.clear();
  pgCollision.fill(255, 0, 0,200);
  pgCollision.pushMatrix();
  pgCollision.translate(200,200);
  pgCollision.rotate(PI/3);
  pgCollision.rect(0,0,100,50);
  pgCollision.popMatrix();
  pgCollision.fill(0,255,0,200);
  pgCollision.rect(mouseX,mouseY,50,100);
  noTint();
  
  //check all pixels for ones that contain both red and green
  pgCollision.loadPixels();
  boolean collDetected = false;
  for (int i = 0; i < width*height; i++) {
    color c = pgCollision.pixels[i];
    if ( red(c)>0 && green(c)>0 ) {
      collDetected = true;
      break;
    }
  }
  if (collDetected) {
    text("collision detected!",50,50);
  }
  pushMatrix();
  translate(200,200);
  rotate(PI/3);
  rect(0,0,100,50);
  popMatrix();
  rect(mouseX,mouseY,50,100);
}
