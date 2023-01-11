ArrayList<Obstacle> obstacles = new ArrayList<>();

class Obstacle {
  PVector center;
  float r;
  Obstacle(PVector center, float r) {
    this.center = center;
    this.r = r;
  }
  void update() {
    drawThis();
  }
  void drawThis() {
    noStroke();
    fill(0);
    circle(center.x,center.y,r*2);
  }
}

void setup() {
  size(800,600);
  
  obstacles.add(new Obstacle(new PVector(200,200), 40));
}

void draw() {
  background(220);
  
  obstacles.forEach((el) -> el.update());
  laser(new PVector(30,30), new PVector(mouseX,mouseY));
}

void laser(PVector from, PVector to) {
  strokeWeight(5);
  stroke(255,0,0);
  PVector current_pos = from.copy();
  PVector dir_normalized = (to.copy().sub(from)).normalize();
  Obstacle o = obstacles.get(0);
  for (int i=0; i<PVector.dist(from,to);i++) {
    if (PVector.dist(current_pos,o.center) <= o.r) {
      line(from.x,from.y,current_pos.x,current_pos.y);
      return;
    }
    current_pos.add(dir_normalized);
  }
  line(from.x,from.y,to.x,to.y);
}
