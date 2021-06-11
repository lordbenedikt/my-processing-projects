PGraphics graphicsCollision;

boolean isColliding(Drawable obj1, Drawable obj2) {
  PImage obj1_image = obj1.getImage();
  PImage obj2_image = obj2.getImage();
  float obj1_maxDist = sqrt(pow(obj1_image.width, 2) + pow(obj1_image.height, 2))/2f;
  float obj2_maxDist = sqrt(pow(obj2_image.width, 2) + pow(obj2_image.height, 2))/2f;

  int xMin = (int)(obj1.getPos().x - obj1_maxDist);
  int xMax = (int)(obj1.getPos().x + obj1_maxDist);
  int yMin = (int)(obj1.getPos().y - obj1_maxDist);
  int yMax = (int)(obj1.getPos().y + obj1_maxDist);
  int xMin2 = (int)(obj2.getPos().x - obj2_maxDist);
  int xMax2 = (int)(obj2.getPos().x + obj2_maxDist);
  int yMin2 = (int)(obj2.getPos().y - obj2_maxDist);
  int yMax2 = (int)(obj2.getPos().y + obj2_maxDist);
  xMin = max(xMin, xMin2);
  xMax = min(xMax, xMax2);
  yMin = max(yMin, yMin2);
  yMax = min(yMax, yMax2);
  
  if(xMin > xMax || yMin > yMax) {
    return false;
  }

  graphicsCollision.beginDraw();
  graphicsCollision.clear();

  graphicsCollision.imageMode(CENTER);
  graphicsCollision.tint(0, 255, 0, 100);
  obj1.drawThis(graphicsCollision);
  graphicsCollision.tint(255, 0, 0, 100);
  obj2.drawThis(graphicsCollision);
  graphicsCollision.endDraw();

  graphicsCollision.loadPixels();
  int precision = 2;
  for (int y = yMin; y<yMax; y = y+precision) {
    if (y<0 || y>=graphicsCollision.height) continue;
    for (int x = xMin; x<xMax; x = x+precision) {
      if (x<0 || x>=graphicsCollision.width) continue;
      color c = graphicsCollision.pixels[y*width+x];
      graphicsCollision.pixels[y*width+x] = color(0);
      if ((red(c)>0)&&(green(c)>0))
        return true;
    }
  }
  return false;
}
