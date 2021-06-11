class Ant {
  float x;
  float y;
  float dir = 0;
  float speed = 1;
  float progress = 0;
  int isAtNode = 0;
  Knoten v;
  Knoten u;
  Ant(Knoten v, Knoten u) {
    this.x = v.x;
    this.y = v.y;
    this.v = v;
    this.u = u;
    dir = PVector.angleBetween(new PVector(v.x,v.y),new PVector(u.x,u.y));
  }
  void update() {
    if (!knoten.contains(v) || !knoten.contains(u)) {
      ants.remove(this);
      return;
    }
    float distance = dist(v.x,v.y,u.x,u.y);
    progress += speed/distance;
    if (progress > 1) {
      progress = 0;
      isAtNode++;
      if (isAtNode >= path.size()-1) {
        ants.remove(this);
        return;
      }
      v = u;
      u = path.get(isAtNode+1);
    }
    dir = angle(u.x-v.x,u.y-v.y);
    x = v.x + (progress*(u.x-v.x));
    y = v.y + (progress*(u.y-v.y));
  }
  void draw() {
    pushMatrix();
    translate(x,y);
    rotate(dir);
    image(antIMG, 0, 0);
    popMatrix();
  }
}

float angle(float x, float y) {
  float res; 
  if (x>0) res = atan(y/x) + HALF_PI;
  else res = atan(y/x) + 3*HALF_PI;
  return res;
}
