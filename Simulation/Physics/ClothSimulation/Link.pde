class Link {
  float restingDist = distance;
  float tearDistance;
  PointMass pM1;
  PointMass pM2;

  Link(PointMass pM1, PointMass pM2) {
    this.pM1 = pM1;
    this.pM2 = pM2;
    this.restingDist = dist(pM1.x,pM1.y,pM2.x,pM2.y);
    this.tearDistance = 5*restingDist;
  }
  void solve() {
    PVector diff = new PVector(pM2.x-pM1.x, pM2.y-pM1.y);
    if (diff.mag()>tearDistance) {
      links.remove(this);
      return;
    }
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
    strokeWeight(2);
    line(pM1.x, pM1.y, pM2.x, pM2.y);
  }
}
