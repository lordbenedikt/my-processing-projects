Player ply = new Player(500, 200);
ArrayList<Block> blocks = new ArrayList<Block>();
float gravity = 1;

void setup() {
  size(1000, 600);
  blocks.add(new Block(570, 100, 260, 50));
  blocks.add(new Block(170, 200, 260, 50));
  blocks.add(new Block(550, 300, 300, 50));
  blocks.add(new Block(150, 400, 300, 50));
  blocks.add(new Block(10, 500, width-20, 50));
}

void draw() {
  background(50);

  //draw Blocks
  for (Block b : blocks) {
    if (ply.onBlock(b)) {
      fill(255, 0, 0);
      rect(b.min.x, b.min.y, b.w, b.h);
      ply.groundVel = b.vel.x;
    }
    b.draw();

    if (b.max.x<0) {
      b.moveBy(1000 + b.w + random(300), 0);
    }
  }

  //draw Player
  ply.update();

  //draw Anleitung
  text("Pfeiltasten zum laufen und springen", 400, 20);
  text("R um Spieler zurückzusetzen", 400, 40);
}

class Player {
  PVector pos;
  PVector lastPos;
  PVector vel;
  PVector acc;
  float h = 80;
  float w = 40;
  float groundVel = 0;
  Player(float x, float y) {
    pos = new PVector(x, y);
    lastPos = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }
  void update() {
    // Inertia: objects in motion stay in motion.
    vel.x = pos.x - lastPos.x - groundVel;
    vel.y = pos.y - lastPos.y;
    vel.x *= 0.7; 
    vel.y *= 0.98;

    accelerate();

    float nextX = pos.x + vel.x + acc.x + groundVel;
    float nextY = pos.y + vel.y + acc.y;

    lastPos.x = pos.x;
    lastPos.y = pos.y;

    pos.x = nextX;
    pos.y = nextY;

    acc.x = 0;
    acc.y = gravity;

    solve();

    //draw Player
    fill(220);
    rect(pos.x-w/2, pos.y-h/2, w, h, 10, 10, 10, 10);
  }

  void accelerate() {
    //Run
    if (keyIsDown(LEFT)) acc.x -= 2;
    if (keyIsDown(RIGHT)) acc.x += 2;

    //Jump
    if (keyIsDown(UP) && vel.y==0 && onGround()) {
      acc.y -= 20;
    }
  }

  //Gibt true zurück, wenn der Spieler Boden unter den Füßen hat
  boolean onGround() {
    for (Block b : blocks) {
      if (onBlock(b)) {
        return true;
      }
    }
    return false;
  }
  boolean onBlock(Block b) {
    if (pos.x+w/2-5 < b.min.x || pos.x-w/2+5 > b.max.x) {
      return false;
    }
    float yBelowPlayer = pos.y+h/2+1;
    if (yBelowPlayer > b.min.y && yBelowPlayer < b.max.y) {
      return true;
    }
    return false;
  }

  //bei Kollision wird der Spieler auf die nächste freie Stelle gesetzt
  void solve() {
    for (Block b : blocks) {
      if (b.playerCollision()) {
        PVector cToC = centerToCenter(ply, b);
        PVector fixedPos = pos.copy();
        if (abs(cToC.x)-(w/2 + b.w/2) > abs(cToC.y)-(h/2 + b.h/2)) {
          if (cToC.x>0) {
            fixedPos.x = b.min.x - (ply.w/2);
          } else {
            fixedPos.x = b.max.x + (ply.w/2);
          }
        } else {
          if (cToC.y>0) {
            fixedPos.y = b.min.y - (ply.h/2);
          } else {
            fixedPos.y = b.max.y + (ply.h/2);
          }
        }
        pos = fixedPos;
      }
      if (pos.y+h > b.min.y) {
      }
    }
  }
}

class Block {
  PVector min;
  PVector max;
  PVector lastMin;
  PVector vel = new PVector(0, 0);
  float w;
  float h;
  Block(float x, float y, float w, float h) {
    min = new PVector(x, y);
    max = new PVector(x+w, y+h);
    lastMin = min.copy();
    this.w = w;
    this.h = h;
  }
  boolean playerCollision() {
    if (abs(ply.pos.x - (min.x+w/2)) > ply.w/2+w/2) {
      return false;
    }
    if (abs(ply.pos.y - (min.y+h/2)) > ply.h/2+h/2) {
      return false;
    }
    return true;
  }
  void moveBy(float x, float y) {
   lastMin = min.copy();
    min.x += x;
    min.y += y;
    max.x += x;
    max.y += y;
  }
  void draw() {
    fill(100);
    rect(min.x, min.y, w, h);
    vel = min.copy().sub(lastMin);
  }
}

PVector centerToCenter(Player ply, Block b) {
  float xVal = (b.min.x+b.w/2)- ply.pos.x;
  float yVal = (b.min.y+b.h/2)- ply.pos.y;
  return new PVector(xVal, yVal);
}
