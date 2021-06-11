ArrayList<Link> links = new ArrayList<Link>(); 
ArrayList<PointMass> pointMasses = new ArrayList<PointMass>();

void setup() {
  size(600, 600);
  for (int i = 0; i<20; i++) {
    pointMasses.add(new PointMass(300, 100+i*10));
    if (i!=0) {
      pointMasses.get(i).createLink(pointMasses.get(i-1));
    }
  }
  pointMasses.get(19).mass = 100;

  pointMasses.get(0).mass = 100000;
  pointMasses.get(0).drawThis = false;
}

void draw() {
  background(100);
  strokeWeight(1);

  //for (int i = 0; i<1; i++) {
  //  for (PointMass pM : pointMasses) {
  //    pM.velX = pM.x-pM.lastX;
  //    pM.velY = pM.y-pM.lastY;
  //  }
  //}
  for (int i = 0; i<1000; i++) {
    for (Link link : links) {
      link.solve();
    }
  }
  for (PointMass pM : pointMasses) {
    pM.update();
    pM.draw();
  }
  for (Link link : links) {
    link.draw();
  }

  PointMass top = pointMasses.get(0);
  if (mousePressed && mouseButton==LEFT) {
    top.mass = 100000;
    top.x = mouseX;
    top.y = mouseY;
    top.velX = 0;
    top.velY = 0;
  } else {
    top.mass = 1;
  }

  text("Links: "+links.size(), 0, 10);
}

class PointMass {
  float x;
  float y;
  float lastX;
  float lastY;
  float nextX;
  float nextY;
  float velX;
  float velY;
  float accX;
  float accY = 1;
  float mass = 1;
  boolean drawThis = true;
  PointMass(float x, float y) {
    this.x = x;
    this.y = y;
    this.lastX = x;
    this.lastY = y;
  }
  void update() {
    // Inertia: objects in motion stay in motion.
    velX = x - lastX;
    velY = y - lastY;

    nextX = x + velX + accX;
    nextY = y + velY + accY;

    lastX = x;
    lastY = y;

    x = nextX;
    y = nextY;
  }
  Link createLink(PointMass pM) {
    Link newLink = new Link(this, pM);
    links.add(newLink);
    return newLink;
  }
  void draw() {
    fill(255, 100);
    if (this==pointMasses.get(0)) fill(255, 0, 0);
    if (drawThis) circle(x, y, pow(mass*10, 0.5));
  }
}

class Link {
  float restingDist = 10;
  PointMass pM1;
  PointMass pM2;

  Link(PointMass pM1, PointMass pM2) {
    this.pM1 = pM1;
    this.pM2 = pM2;
  }
  void solve() {
    PVector diff = new PVector(pM2.x-pM1.x, pM2.y-pM1.y);
    float correctionAmount = (restingDist - diff.mag());
    float massDistribution = pM2.mass/(pM1.mass+pM2.mass);
    PVector correction = diff.copy().normalize().mult(correctionAmount);
    pM1.x += -correction.x*massDistribution;
    pM1.y += -correction.y*massDistribution;
    pM2.x += correction.x*(1-massDistribution);
    pM2.y += correction.y*(1-massDistribution);
  }
  void draw() {
    stroke(0);
    strokeWeight(5);
    line(pM1.x, pM1.y, pM2.x, pM2.y);
  }
}
