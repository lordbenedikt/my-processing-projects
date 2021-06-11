class Asteroid {
  float x;
  float y;
  float r;
  float xSpeed;
  float ySpeed;
  Asteroid(float x, float y, float r, float xSpeed, float ySpeed) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.xSpeed = xSpeed;
    this.ySpeed = ySpeed;
  }
}

void spawnAsteroid() {
  float[] pos = posOutsideRoom();
  randomizer = pow(random(0, 1), 2);
  PVector speed = new PVector(random(0, viewWidth)-pos[0], random(0, viewHeight)-pos[1]).setMag(1+3*randomizer);
  randomizer = pow(random(0, 1), 7);
  float radius = 20 + random(0, 100)*randomizer;
  asteroids.add(new Asteroid( pos[0], pos[1], radius, speed.x, speed.y));
}
void drawAsteroids() {
  for (Asteroid a : asteroids) {
    imageMode(CENTER);
    image(asteroid, a.x, a.y, a.r*2, a.r*2);
  }
}
void moveAsteroids() {
  for (Asteroid a : asteroids) {
    a.x += a.xSpeed; 
    a.y += a.ySpeed;
  }
}

void removeCrashedAsteroids() {
  int i = 0;
  while (i < asteroids.size()) {
    Asteroid a = asteroids.get(i);
    if (collisionDetector( a, jens_x, jens_y )) {
      hp -= 10;
      //explosion.rewind();
      explosion.play(0);
      asteroids.remove(a);
      score++;
      spawnExplosion( a.x, a.y, a.r);
      continue;
    }
    i++;
  }
}

void removeAsteroids() {
  int i = 0;
  while (i < asteroids.size()) {
    Asteroid a = asteroids.get(i);
    if (a.x < -150  || a.x > viewWidth+150 || a.y < -150 || a.y > viewHeight+150) {
      asteroids.remove(i);
      score++;
      continue;
    }
    i++;
  }
}


float getDistance(float x1, float y1, float x2, float y2 ) {
  return (float) Math.sqrt( (Math.pow( x1-x2, 2)) + (Math.pow( y1-y2, 2)) );
}

boolean collisionDetector(Asteroid a, float jens_x, float jens_y) {
  float distance = getDistance(jens_x, jens_y, a.x, a.y);
  if (distance < 40 + a.r)
    return true;
  else 
  return false;
}
