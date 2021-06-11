class Laser implements Configurable {
  PVector pos;
  PVector target;
  PVector dir;
  float directionOrigin;
  float direction;
  float interval = 100;
  float countdown;
  float countdown2;
  float onTime = 50;
  float delay = 0;
  KeyPos[] keyPositions = {new KeyPos(0,-1)};
  int keyPhase = 0;
  boolean on = false;
  Laser(float x, float y, float directionOrigin, float interval, float onTime, float delay) {
    pos = new PVector(x, y);
    target = new PVector(x, y);
    dir = PVector.fromAngle(TWO_PI*directionOrigin/360);
    this.directionOrigin = directionOrigin;
    direction = directionOrigin;
    this.interval = interval;
    this.onTime = onTime;
    this.delay = delay;
    countdown = interval*onTime/100 + delay;
  }
  Laser(float x, float y, float directionOrigin, float interval, float onTime, float delay, KeyPos[] keyPositions) {
    this(x, y, directionOrigin, interval, onTime, delay);
    this.keyPositions = keyPositions;
    countdown2 = keyPositions[0].time;
  }
  Laser(float x, float y, float directionOrigin, float interval, float onTime, float delay, int keyPosNum) {
    this(x, y, directionOrigin, interval, onTime, delay);
    keyPositions = new KeyPos[keyPosNum];
    for(int i = 0; i<keyPosNum; i++) {
      keyPositions[i] = new KeyPos(0,50);
    }
  }
  Laser(float x, float y, int direction) {
    this(x, y, direction, 100, 50, 0);
  }
  void drawSelection() {
    fill(0, 0);
    stroke(255, 255, 255);
    ellipse(pos.x, pos.y, 20, 20);
    stroke(0);
  }
  void update() {
    //ON/OFF
    if (countdown>1) {
      countdown--;
    } else {
      if (on) {
        countdown = (100-onTime)/100*interval;
        on = false;
      } else {
        countdown = onTime/100*interval;
        on = true;
      }
    }

    //ROTATE Laser
    if (keyPositions[0].time!=-1) {
      float lastAngle = directionOrigin + keyPositions[keyPhase].dir;
      float nextAngle = directionOrigin + keyPositions[(keyPhase+1)%keyPositions.length].dir;
      direction = lastAngle + (nextAngle-lastAngle)*(keyPositions[keyPhase].time-countdown2)/keyPositions[keyPhase].time;
      if (countdown2>1) countdown2--;
      else {
        keyPhase = (keyPhase+1) % keyPositions.length;
        countdown2 = keyPositions[keyPhase].time;
      }
    }

    //Draw when on
    if (on) {
      //shoot and draw laser
      laser(pos.x, pos.y, direction, false);
    }

    //DRAW METAL
    strokeWeight(2);
    pushMatrix();
    translate(pos.x, pos.y,1);
    rotate(direction/360*TWO_PI);
    strokeWeight(1);
    stroke(0);
    fill(groundColor);
    rect(5, -3, 10, 6);
    ellipse(0, 0, 10, 10);
    popMatrix();
    strokeWeight(1);
  }
  boolean isColliding(float x, float y) {
    return insideCircle(pos.x, pos.y, 12, mouseX+cam.pos.x, mouseY+cam.pos.y);
  }
  void remove() {
    lasers.remove(this);
  }
  public void setValue(int num, float value) {
    if (num==0) interval = (int)value;
    if (num==1) {
      directionOrigin = (int)value;
      direction = (int)value;
      dir = PVector.fromAngle(TWO_PI*directionOrigin/360);
    }
    if (num==2) onTime = (int)value;
    if (num==3) delay = (int)value;
    if (num>=4) keyPositions[num-4].dir = value;
    if (num>=10 && num<20) keyPositions[num%10].dir = value;
    if (num>=20 && num<30) keyPositions[num%10].time = value;
  }
  public float getValue(int num) {
    if (num==0) return interval;
    if (num==1) return directionOrigin;
    if (num==2) return onTime;
    if (num==3) return delay;
    if (num>=4) return keyPositions[num-4].dir;
    if (num>=10 && num<20) return keyPositions[num%10].dir;
    if (num>=20 && num<30) return keyPositions[num%10].time;
    return -1;
  }
}

class KeyPos implements Savable {
  float dir;
  float time;
  KeyPos(float dir, float time) {
    this.dir = dir;
    this.time = time;
  }
}
