Point points[] = new Point[80];

void setup () {
  size(800, 600);
  for (int i = 0; i<points.length; i++) {
    points[i] = new Point(random(-200, width+200), random(-200, height+200), 0, 0);
    points[i].randomizeSpeed();
  }
}

void draw () {
  background(0);
  for (Point p : points) {
    p.update();
  }
  for (int i = 0; i<points.length; i++) {
    for (int j = i+1; j<points.length; j++) {
      float distance = dist(points[i].x, points[i].y, points[j].x, points[j].y);
      if (distance<200) {
        stroke(255, map(distance, 0, 200, 255, 0));
        line(points[i].x,points[i].y,points[j].x,points[j].y);
        noFill();
        //circle((points[i].x+points[j].x)/2, (points[i].y+points[j].y)/2, distance);
        //circle(points[i].x,points[i].y,10);
        //circle(points[j].x,points[j].y,10);
      }
    }
  }
}

class Point {
  float x;
  float y;
  float xSpeed;
  float ySpeed;
  float maxSpeed = 2f;
  float minSpeed = 1f;
  Point(float x, float y, float xSpeed, float ySpeed) {
    this.x = x;
    this.y = y;
    this.xSpeed = xSpeed;
    this.ySpeed = ySpeed;
  }
  void resetPos() {
    int side = (int)random(4);
    switch(side) {
      // left
    case 0:
      x = -100-random(100);
      y = random(-100, height+100);
      break;
      // right
    case 1:
      x = width+100+random(100);
      y = random(-100, height+100);
      break;
      // top
    case 2:
      x = random(-100, width+100);
      y = -100-random(100);
      break;
      // bottom
    default:
      x = random(-100, width+100);
      y = height+100+random(100);
    }
  }
  void randomizeSpeed() {
    float direction = random(TWO_PI);
    PVector speed = PVector.fromAngle(direction);
    xSpeed = speed.x * random(minSpeed, maxSpeed);
    ySpeed = speed.y * random(minSpeed, maxSpeed);
  }
  void update() {
    if (x<-200 || x>width+200 || y<-200 || y>height+200) {
      resetPos();
      randomizeSpeed();
    }
    x += xSpeed;
    y += ySpeed;
    noStroke();
    fill(255);
    circle(x, y, 5);
  }
}
