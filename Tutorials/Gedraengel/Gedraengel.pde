import java.util.List;

List<Obstacle> obstacles = new ArrayList<Obstacle>();

void setup() {
  size(800, 600);
  for (int i = 0; i<360/20; i++) {
    obstacles.add(new Obstacle(10 + i*20, 210, 10, true));
  }
  for (int i = 0; i<360/20; i++) {
    obstacles.add(new Obstacle(450 + i*20, 210, 10, true));
  }
  obstacles.add(new Obstacle(400, 400, 50, true));
}

void draw() {
  background(100);

  int n = 0;
  while (n<obstacles.size()) {
    int prevSize = obstacles.size();
    obstacles.get(n).update();
    if (prevSize==obstacles.size()) n++;
  }

  for (int iterations = 0; iterations<5; iterations++) { 
    for (int i = 0; i<obstacles.size(); i++) {
      for (int j = i+1; j<obstacles.size(); j++) {
        obstacles.get(i).collide(obstacles.get(j));
      }
    }
  }


  for (Obstacle o : obstacles) {
    o.drawThis();
  }

  fill(255);
  rect(0, 200, 360, 20);
  rect(440, 200, 360, 20);
}

class Obstacle {
  float x;
  float y;
  float r;
  boolean isFixed;
  Obstacle(float x, float y, float r, boolean isFixed) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.isFixed = isFixed;
  }
  void update() {}
  void drawThis() {
    if (isFixed) {
      fill(255);
    } else {
      fill(30);
    }
    circle(x, y, 2*r);
  }
  void collide(Obstacle o) {
    if (!isFixed || !o.isFixed) {
      if (dist(o.x, o.y, x, y) < o.r+r) {
        if (!o.isFixed && !isFixed) {
          PVector v = new PVector(o.x-x, o.y-y);
          PVector center = new PVector((o.x+x)/2, (o.y+y)/2);
          v.normalize();
          v.mult((o.r + r)/2);
          x = center.x - v.x;
          y = center.y - v.y;
          o.x = center.x + v.x;
          o.y = center.y + v.y;
        } else {
          Obstacle fixed = o.isFixed ? o : this;
          Obstacle loose = o.isFixed ? this : o;
          PVector v = new PVector(loose.x-fixed.x, loose.y-fixed.y);
          v.normalize();
          v.mult(fixed.r + loose.r);
          loose.x = fixed.x + v.x;
          loose.y = fixed.y + v.y;
        }
      }
    }
  }
}

class Person extends Obstacle {
  float speed = random(3, 5);
  float xSpeed = 0;
  float ySpeed = 0;
  Person(float x, float y) {
    super(x, y, 20, false);
  }
  void update() {
    if (mousePressed && mouseButton!=LEFT) {
      if(dist(mouseX,mouseY,x,y)<r*1.2) {
        // remove when reached mouse
        obstacles.remove(this);
      }
      PVector dir = new PVector(mouseX-x, mouseY-y).normalize();
      if (mouseButton==RIGHT) {
        x += dir.x * speed;
        y += dir.y * speed;
      } 
      if (mouseButton==CENTER) {
        x -= dir.x * speed;
        y -= dir.y * speed;
      }
    } else {
      xSpeed = constrain(xSpeed + random(-0.1, 0.1), -1, 1);
      ySpeed = constrain(ySpeed + random(-0.1, 0.1), -1, 1);
      x += xSpeed;
      y += ySpeed;
    }
  }
}

void mousePressed() {
  if (mouseButton==LEFT) {
    obstacles.add(new Person(mouseX, mouseY));
  }
}
