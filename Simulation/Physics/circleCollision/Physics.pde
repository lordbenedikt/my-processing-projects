class Physics {
  ArrayList<Circle> circles = new ArrayList<Circle>();
}

class Circle {
  float x;
  float y;
  float velX = 0;
  float velY = 0;
  float lastX;
  float lastY;
  
  float radius;
  
  Circle(float x, float y, float r) {
    this.x = x;
    this.y = y;
    lastX = x;
    lastY = y;
    radius = r;
  }
  
  void update() {
    velY = velY+1;
    
    x = x + velX;
    y = y + velY;
    velX = x-lastX;
    velY = y-lastY;
    //velX = constrain(velX,-30,30);
    //velY = constrain(velY,-30,30);
    velX *= 0.98;
    velY *= 0.98;
    
    solve();
    
    lastX = x;
    lastY = y;
    
    circle(x,y,radius*2);
    circle(300,300,80);
  }
  
  void solve() {
    if (x < radius) {
      x = radius;
      if (velX < 0) {
        velX *= -1;
      }
    }
    if (x > width-radius) {
      x = width-radius;
      if (velX > 0) {
        velX *= -1;
      }
    }
    if (y < radius) {
      y = radius;
      if (velY < 0) {
        velY *= -1;
      }
    }
    if (y > height-radius) {
      y = height-radius;
      if (velY > 0) {
        velY *= -1;
      }
    }
    
    if (sqrt(pow(300-x,2)+pow(300-y,2))<radius+40) {
      PVector diff = new PVector(x-300,y-300);
      PVector vel = new PVector(-velX,-velY);
      diff.normalize();
      diff.mult(40+radius);
      vel.rotate(((diff.heading()-vel.heading())*2));
      x = 300+diff.x;
      y = 300+diff.y;
      velX = vel.x;
      velY = vel.y;
    }
  }
}
