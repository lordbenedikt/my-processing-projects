//boolean isCollidingPixels(Rocket r) {
//  int rX = (int) ((r.pos.x-rocketIMG.width/2) - (jens_x-jens.width/2));
//  int rY = (int) ((r.pos.y-rocketIMG.height/2) - (jens_y-jens.height/2));

//  if (rX>jens.width || rX+rocketIMG.width<0 || rY>jens.height || rY+rocketIMG.height<0) {
//    return false;
//  }

//  int rLeft = 0;
//  int rRight = rocketIMG.width;
//  int rTop = 0;
//  int rBottom = rocketIMG.height;

//  int jLeft = rX;
//  int jRight = rX+rocketIMG.width;
//  int jTop = rY;
//  int jBottom = rY+rocketIMG.height;

//  if (rX<0) {
//    rLeft = -rX;
//    jLeft = 0;
//  }
//  if (rX+rocketIMG.width>jens.width) {
//    rRight = jens.width-rX;
//    jRight = jens.width;
//  }
//  if (rY<0) {
//    rTop = -rY;
//    jTop = 0;
//  }
//  if (rY+rocketIMG.height>jens.height) {
//    rBottom = jens.height-rY;
//    jBottom = jens.height;
//  }

//  int numOfPixels = (jRight-jLeft)*(jBottom-jTop);
//  color[] jensPixels = new color[numOfPixels];
//  color[] rocketPixels = new color[numOfPixels];
//  color[] collidingPixels = new color[numOfPixels];

//  int snippetWidth = jRight-jLeft;
//  int snippetHeight = jBottom-jTop;


//  color[] rocketPixelsMirrored = new int[rocketIMG.pixels.length];
//  for (int i = 0; i<rocketIMG.pixels.length; i++) {
//    if (r.speed.x>0) {
//      rocketPixelsMirrored[i] = rocketIMG.pixels[i];
//    } else {
//      rocketPixelsMirrored[i] = rocketIMG.pixels[rocketIMG.pixels.length-1-i];
//    }
//  }

//  for (int i = 0; i<numOfPixels; i++) {
//    jensPixels[i] = jens.pixels[jens.width*(jTop+i/snippetWidth)+(jLeft+i%snippetWidth)];
//    rocketPixels[i] = rocketPixelsMirrored[rocketIMG.width*(rTop+i/snippetWidth)+rLeft+i%snippetWidth];
//    if ((alpha(jensPixels[i])>0 && alpha(rocketPixels[i])>0)) {
//       collidingPixels[i] = 1;
//       //return true;
//    } 
//  }

//  //draw snippet box
//  strokeWeight(3);
//  noFill();
//  rectMode(CORNER);
//  rect(jens_x-jens.width/2+jLeft, jens_y-jens.height/2+jTop, jRight-jLeft, jBottom-jTop);

//  for (int i = 0; i<collidingPixels.length; i++) {
//    if (collidingPixels[i]==1) {
//      fill(1);
//      text("COLLISION DETECTED!!!", 200, 200);
//      break;
//    }
//  }

//  //draw colliding pixels
//  for (int i = 0; i<collidingPixels.length; i++) {
//    if (collidingPixels[i]==1) {
//      rectMode(CORNER);
//      noStroke();
//      fill(1);
//      rect(r.pos.x-rocketIMG.width/2+rLeft+(i%snippetWidth), r.pos.y-rocketIMG.height/2+rTop+(i/snippetWidth), 1, 1);
//    }
//  }

//  return false;
//}
