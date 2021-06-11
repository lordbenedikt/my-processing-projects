class Asteroid {
  int x;
  int y;
  int r;
  int xSpeed;
  int ySpeed;
  Asteroid(int x, int y, int r, int xSpeed, int ySpeed) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.xSpeed = xSpeed;
    this.ySpeed = ySpeed;
  }
}

void spawnAsteroid() {
  float[] pos = posOutsideRoom();
  asteroids.add(new Asteroid( (int)pos[0], (int)pos[1], (int) random(10, 20), (int) random(-3, 3), (int) random(-3, 3)));
}
void drawAsteroids() {
  for (Asteroid a : asteroids) {
    //fill(200, 106, 68);
    //ellipse(a.x, a.y, a.r*2, a.r*2);
    imageMode(CENTER);
    image(asteroid, a.x, a.y, a.r*2, a.r*2);
  }
}
void moveAsteroids() {
  for (Asteroid a : asteroids) {
    a.x = a.x + a.xSpeed; 
    a.y = a.y + a.ySpeed;
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
    if (a.x < -50  || a.x > 850 || a.y < -50 || a.y > 650) {
      asteroids.remove(i);
      score++;
      continue;
    }
    i++;
  }

  if (asteroids.size() >= 100) {
    for (int j = 0; j < 25; j++) {
      asteroids.remove(j);
      continue;
    }
  }
}

float[] posOutsideRoom() {
  float[] pos = {0, 0};
  int side = r.nextInt(2);

  if (side==0) {
    if (r.nextInt(2)==0) {
      pos[0] = -30;
    } else {
      pos[0] = width+30;
    }
    pos[1] = random(0, height);
  } else {
    if (r.nextInt(2)==0) {
      pos[1] = -30;
    } else {
      pos[1] = height+30;
    }
    pos[0] = random(0, width);
  }

  return pos;
}

float getDistance(float x1, float y1, int x2, int y2 ) {
  return (float) Math.sqrt( (Math.pow( x1-x2, 2)) + (Math.pow( y1-y2, 2)) );
}

boolean collisionDetector(Asteroid a, float jens_x, float jens_y) {
  float distance = getDistance(jens_x, jens_y, a.x, a.y);
  if (distance < 40 + a.r)
    return true;
  else 
  return false;
}
