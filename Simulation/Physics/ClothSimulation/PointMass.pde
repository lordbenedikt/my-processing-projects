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
  float accY;
  float mass = 1;
  float mouseGrabScalar;
  boolean drawThis = true;
  boolean pinned;
  float pinX;
  float pinY;
  PointMass(float x, float y, boolean pinned) {
    this.x = x;
    this.y = y;
    this.lastX = x;
    this.lastY = y;
    this.pinned = pinned;
    pinX = x;
    pinY = y;
  }
  PointMass(float x, float y) {
    this(x, y, false);
  }
  void update() {

    //move to pinned position
    if (pinned) {
      x = pinX;
      y = pinY;
    }

    // Inertia: objects in motion stay in motion.
    velX = x - lastX;
    velY = y - lastY;

    lastX = x;
    lastY = y;

    x = x + velX + accX;
    y = y + velY + accY;

    accX = 0;
    accY = gravity;
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
