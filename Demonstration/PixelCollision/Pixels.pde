boolean isCollidingPixels(Rocket r) {
  //if (jens_x+jens.width/2 < (r.pos.x-rocketIMG.width/2)) {
  //  return false;
  //} else if (jens_y+jens.height/2 < (r.pos.y-rocketIMG.height/2)) {
  //  return false;
  //} else if (jens_x-jens.width/2 > (r.pos.x+rocketIMG.width/2)) {
  //  return false;
  //} else if (jens_y-jens.height/2 > (r.pos.y+rocketIMG.height/2)) {
  //  return false;
  //}
  ////else return true;

  int rX = (int) ((r.pos.x-rocketIMG.width/2) - (jens_x-jens.width/2));
  int rY = (int) ((r.pos.y-rocketIMG.height/2) - (jens_y-jens.height/2));

  //rX
  //int xLeft = (int) (r.pos.x-rocketIMG.width/2 - (jens_x - jens.width/2));
  //int xRight = (int) (r.pos.x+rocketIMG.width/2 - (jens_x - jens.width/2));
  //int yTop = (int) (r.pos.y-rocketIMG.height/2 - (jens_y - jens.height/2));
  //int yBottom = (int) (r.pos.y+rocketIMG.height/2 - (jens_y - jens.height/2));
  //if (xRight<0 || yBottom<0 || xLeft>jens.width || yTop>jens.height) {
  if (rX>jens.width || rX+rocketIMG.width<0 || rY>jens.height || rY+rocketIMG.height<0) {
    return false;
  }

  int rLeft = 0;
  int rRight = rocketIMG.width;
  int rTop = 0;
  int rBottom = rocketIMG.height;

  int jLeft = rX;
  int jRight = rX+rocketIMG.width;
  int jTop = rY;
  int jBottom = rY+rocketIMG.height;

  if (rX<0) {
    rLeft = -rX;
    jLeft = 0;
  }
  if (rX+rocketIMG.width>jens.width) {
    rRight = jens.width-rX;
    jRight = jens.width;
  }
  if (rY<0) {
    rTop = -rY;
    jTop = 0;
  }
  if (rY+rocketIMG.height>jens.height) {
    rBottom = jens.height-rY;
    jBottom = jens.height;
  }

  strokeWeight(3);
  noFill();
  rectMode(CORNER);
  //rect(jens_x-jens.width/2+jLeft, jens_y-jens.height/2+jTop, jRight-jLeft, jBottom-jTop);
  //rect(r.pos.x-rocketIMG.width/2+rLeft, r.pos.y-rocketIMG.height/2+rTop, rRight-rLeft, rBottom-rTop);

  int numOfPixels = (jRight-jLeft)*(jBottom-jTop);
  color[] jensPixels = new color[numOfPixels];
  color[] rocketPixels = new color[numOfPixels];
  color[] collidingPixels = new color[numOfPixels];

  int snippetWidth = jRight-jLeft;
  int snippetHeight = jBottom-jTop;

  System.out.println(color(255, 00, 00));

  color[] rocketPixelsMirrored = new int[rocketIMG.pixels.length];
  for (int i = 0; i<rocketIMG.pixels.length; i++) {
    if (r.speed.x>0) {
      rocketPixelsMirrored[i] = rocketIMG.pixels[i];
    } else {
      rocketPixelsMirrored[i] = rocketIMG.pixels[rocketIMG.pixels.length-1-i];
    }
  }

  for (int i = 0; i<numOfPixels; i++) {
    jensPixels[i] = jens.pixels[jens.width*(jTop+i/snippetWidth)+(jLeft+i%snippetWidth)];
    rocketPixels[i] = rocketPixelsMirrored[rocketIMG.width*(rTop+i/snippetWidth)+rLeft+i%snippetWidth];
    //if ((alpha(jensPixels[i])>0 && alpha(rocketPixels[i])>0)) return true;
    collidingPixels[i] = (alpha(jensPixels[i])>0 && alpha(rocketPixels[i])>0) ? 1 : 0;
  }


  //for (int i = 0; i<jensPixels.length; i++) {
  //  rectMode(CORNER);
  //  noStroke();
  //  fill(jensPixels[i]);
  //  rect(10+(i%snippetWidth)*5, 10+(i/snippetWidth)*5, 5, 5);
  //}
  //for (int i = 0; i<rocketPixels.length; i++) {
  //  rectMode(CORNER);
  //  noStroke();
  //  fill(rocketPixels[i]);
  //  rect(10+(i%snippetWidth)*5, 200+(i/snippetWidth)*5, 5, 5);
  //}
  for (int i = 0; i<collidingPixels.length; i++) {
    if (collidingPixels[i]==1) {
      text("COLLISION DETECTED!!!",200,200);
      break;
    }
  }
  for (int i = 0; i<collidingPixels.length; i++) {
    if (collidingPixels[i]==1) {
      rectMode(CORNER);
      noStroke();
      fill(1);
      rect(r.pos.x-rocketIMG.width/2+rLeft+(i%snippetWidth), r.pos.y-rocketIMG.height/2+rTop+(i/snippetWidth), 1, 1);  //draw Snippet Box
    }
  }
  
  return false;

  //if (xLeft<0) {
  //  rLeft = jens_x-jens.width/2 + ;
  //  jLeft = 0;
  //if (xRight>jens_x+jens.width/2) {
  //  rRight = jens_x+jens.width/2
  //  jRigth = jens_x;
  //}
  //if (yTop<0) {
  //  rTop = 
  //  JTop
  //}
  //if (yBottom>jens_y+jens.height/2) {
  //}

  //{
  //  int[] jensPixels;
  //  int[] rocketPixels;

  //  return false;
  //}

  //for (int p : rocketIMG.pixels) {
  //}
}
