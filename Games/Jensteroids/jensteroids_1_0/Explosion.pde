class Explosion {
  float x;
  float y;
  float r;

  Explosion(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
  }
}

void spawnExplosion(float x, float y, float r) {
  explosions.add(new Explosion( x, y, r));
}

void drawExplosions() {
  int i = 0;
  while ( i < explosions.size()) {
    Explosion expl = explosions.get(i);
    imageMode(CENTER);
    image(explosionpng, expl.x, expl.y, expl.r*2*2, expl.r*2*2);
    if (expl.r < 0) {
      explosions.remove(expl);
      continue;
    }
    expl.r = expl.r - 0.2;
    i++;
  }
}
