ArrayList<Link> links = new ArrayList<Link>(); 
ArrayList<PointMass> pointMasses = new ArrayList<PointMass>();

float distance = 10;
float gravity = 1;
float lastMouseX;
float lastMouseY;
ArrayList<PointMass> grabbed = new ArrayList<PointMass>();

int rows = 20;
int cols = 30;

PImage clothIMG;

PointMass getPoint(int row, int col) {
  return pointMasses.get(row*30 + col);
}

void drawCloth(int rows, int cols) {
  PointMass cur;
  noStroke();

  for (int y = 0; y < rows-1; y++) {
    for (int x = 0; x < cols-1; x++) {

      //bottom right triangle
      beginShape();
      texture(clothIMG);
      cur = getPoint(y, x+1);
      vertex(cur.x, cur.y, (x+1)*distance, y*distance);
      cur = getPoint(y+1, x+1);
      vertex(cur.x, cur.y, (x+1)*distance, (y+1)*distance);
      cur = getPoint(y+1, x);
      vertex(cur.x, cur.y, x*distance, (y+1)*distance);
      endShape();

      //top left triangle
      beginShape();
      texture(clothIMG);
      cur = getPoint(y, x);
      vertex(cur.x, cur.y, x*distance, y*distance);
      cur = getPoint(y, x+1);
      vertex(cur.x, cur.y, (x+1)*distance, y*distance);
      cur = getPoint(y+1, x);
      vertex(cur.x, cur.y, x*distance, (y+1)*distance);
      endShape();
    }
  }
}

void setup() {
  clothIMG = loadImage("cloth.jpg");
  clothIMG.resize(300,200);

  size(600, 600, P3D);

  for (int y = 0; y<rows; y++) {
    for (int x = 0; x<cols; x++) {
      pointMasses.add(new PointMass(100+x*distance, 100+y*distance, (y==0)?true:false));
      if (y!=0) {
        pointMasses.get(y*cols+x).createLink(pointMasses.get(y*cols + x - cols));
      }
      if (x!=0) {
        pointMasses.get(y*cols+x).createLink(pointMasses.get(y*cols + x - 1));
      }
    }
  }
  //pointMasses.get(19).mass = 100;

  for (int i = 0; i<cols; i++) {
    PointMass curr = pointMasses.get(i);
    curr.mass = 1000;
    curr.drawThis = false;
  }
}

void draw() {

  background(100);
  strokeWeight(1);

  //for (int i = 0; i<1; i++) {
  //  for (PointMass pM : pointMasses) {
  //    pM.velX = pM.x-pM.lastX;
  //    pM.velY = pM.y-pM.lastY;
  //  }
  //}
  //for (int i = 0; i<20; i++) {
  //  PointMass thisPoint = getPoint(0,i);
  //  thisPoint.x = mouseX;
  //  thisPoint.y = mouseY;
  //}
  for (int i = 0; i<100; i++) {
    int j = 0;
    while (j<links.size()) {
      links.get(j).solve();
      j++;
    }
  }
  for (PointMass pM : pointMasses) {
    pM.update();
    pM.draw();
  }
  for (Link link : links) {
    link.draw();
  }
  drawCloth(rows, cols);


  //if (mousePressed && mouseButton==LEFT && links.size()!=0) {
  //  links.remove((int)random(links.size()));
  //}
  if (grabbed!=null)
    if (mousePressed && mouseButton==LEFT) {
      for (PointMass p : grabbed) {
        p.accX += (mouseX - p.x)*p.mouseGrabScalar;
        p.accY += (mouseY - p.y)*p.mouseGrabScalar;
      }
      //grabbed.mass = 1;
      //grabbed.drawThis = false;
      //grabbed.x = mouseX;
      //grabbed.y = mouseY;
      //grabbed.velX = 0;
      //grabbed.velY = 0;
    } else {
      //grabbed.mass = 1;
      //grabbed.drawThis = false;
      grabbed.clear();
    }

  lastMouseX = mouseX;
  lastMouseY = mouseY;

  text("Links: "+links.size(), 0, 10);
}

void mousePressed() {
  if (mouseButton==LEFT) {
    for (PointMass p : pointMasses) {
      if (dist(mouseX, mouseY, p.x, p.y)<20) {
        p.mouseGrabScalar = 1/(pow(dist(p.x, p.y, mouseX, mouseY), 0.1));
        grabbed.add(p);
      }
    }
  }
}
