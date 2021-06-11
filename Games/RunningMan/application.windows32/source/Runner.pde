class Runner {
  float x;
  float y;
  PVector pivot = new PVector(29, 65);
  PVector[] gunPoint = {
    new PVector(22, -34), 
    new PVector(22, -39.5), 
    new PVector(22, -39), 
    new PVector(22, -33.5), 
    new PVector(15, -36)};
  int h = 60;
  int w = 14;
  boolean running = false;
  boolean mirrored = false;
  float health = 100;
  int count = 0;
  int subimage = 0;
  PVector speed = new PVector(0, 0);
  Runner(float x, float y) {
    this.x = x;
    this.y = y;
  }
  void keyAction() {
    if (state!=GM.PLAY) return;
    if (keyUp) {
      if (collBoxWithRects(x-w/2, y-h+1, x+w/2, y+1)) {
        speed.y = -16;
      }
    }
    if (keyLeft) {
      if (speed.x>-plySpeed)
        speed.x--; // = -plySpeed;
      mirrored = false;
      running = true;
    } else if (keyRight) {
      if (speed.x<plySpeed)
        speed.x++; // = plySpeed;
      mirrored = true;
    } else {
      if (speed.x<0) speed.x++;
      else if (speed.x>0) speed.x--;
      else running = false;
    }
    if (keyShift) {
      int posNeg = mirrored?1:-1;
      if (running==true)
        laser(x+gunPoint[subimage%4].x*posNeg, y+gunPoint[subimage%4].y, mirrored?0:180, true);
      else
        laser(x+gunPoint[4].x*posNeg, y+gunPoint[4].y, mirrored?0:180, true);
    }
  }
  boolean isColliding(float x, float y) {
    return insideBox(this.x-w/2, this.y-h, w, h, x, y);
  }

  boolean isCollWithSolid(float Xrel, float Yrel) {
    for (SolidRect rect : solidRects) {
      //rect(x-w/2+Xrel, y-h+Yrel, w, h);
      if (rect.isBoxColliding(x-w/2+Xrel, y-h+Yrel, x+w/2+Xrel, y+Yrel)) 
        return true;
    }

    return false;
  }

  void update() {

    keyAction();
    
    //check wether running
    if (speed.x!=0) running = true;
    else {
      running = false;
      subimage = 0;
    }
    //chose correct frame
    PImage currentImage;
    if (running) {
      subimage = count/5 % 8;
      currentImage = runImage[subimage%4];
    } else currentImage = standImage[0];

    //draw
    pushMatrix();
    translate(runner.x, runner.y);
    scale(0.5, 0.5);
    if (!mirrored)
      image(currentImage, -pivot.x*2, -pivot.y*2);
    else
      imageMirrored(currentImage, -pivot.x*2, -pivot.y*2);
    popMatrix();

    if (state==GM.PLAY) {
      if (health<=0) {
        health = 0;
        state = GM.GAME_OVER;
      }
      //gravity
      speed.y += gravity;

      float posNeg = (speed.y<0) ? -1 : 1;
      //check for collision in y-direction to prevent moving into wall
      if (speed.y!=0 && isCollWithSolid(0, speed.y)) {
        posNeg = (speed.y<0) ? -1 : 1;
        for (float temp = 1; temp<=(speed.y*posNeg)+1; temp++) {
          if (temp!=1)
            System.out.println(temp);
          if (isCollWithSolid(speed.x, temp*posNeg)) {
            if (temp>1) speed.y = temp*posNeg - 1*posNeg;
            else {
              speed.y = 0;
            }
            break;
          }
        }
      }
      //check for collision in x-direction to prevent moving into wall
      posNeg = (speed.x<0) ? -1 : 1;
      if (speed.x!=0 && isCollWithSolid(speed.x, speed.y) && isCollWithSolid(speed.x, -20)) {     
        for (float temp = 1; temp<=(speed.x*posNeg)+1; temp++) {
          if (isCollWithSolid(temp*posNeg, 0)) {
            if (temp>1) speed.x = temp*posNeg - 1*posNeg;
            else speed.x = 0;
            break;
          }
        }
      }
      //move up when walking on stairs
      if (isCollWithSolid(speed.x, speed.y)) {
        if (!isCollWithSolid(speed.x, -20)) {
          System.out.println("Hi");
          float aboveGround = -20;
          while (Math.abs(aboveGround)>0.1f) {
            //System.out.println(aboveGround);
            y = y+aboveGround;
            aboveGround = (isCollWithSolid(speed.x, 0)) ? -Math.abs(aboveGround/2) : Math.abs(aboveGround/2);
          }
          if (aboveGround<0) y = y-aboveGround;
        }
      }

      //rect(x-15,y-120,30,120);  //draw collision box

      //update position
      x += speed.x;
      y += speed.y;
      count++;  //is used to choose right subimage
    }
  }
}
