float x;
float y;
float red = random(0, 255);
float green = random(0, 255);
float blue = random(0, 255);

void setup() {
  size(1200, 700);
  x = width/2;
  y = height/2;
}

void draw() {
  noStroke();
  float bottom = 100;
  float ceiling = 200;
  for (int i = 0; i<10000; i++) {
    red = constrain(red + random(-0.3, 0.3), bottom, ceiling);
    green = constrain(green + random(-0.3, 0.3), bottom, ceiling);
    blue = constrain(blue + random(-0.3, 0.3), bottom, ceiling);
    fill(red, green, blue, random(0, 255));
    circle(x + random(-1, 1), y + random(-1, 1), random(0,5));
    switch(floor(random(0, 4))) {
    case 0:
      if (x>0) x -= random(1,3);
      break;
    case 1:
      if (y>0) y -= random(1,3);
      break;
    case 2:
      if (x<width) x += random(1,3);
      break;
    case 3:
      if (y<height) y += random(1,3);
      break;
    }
  }
}
