ArrayList<Link> links = new ArrayList<Link>(); 
ArrayList<PointMass> pointMasses = new ArrayList<PointMass>();

float distance = 10;
float gravity = 1;
float lastMouseX;
float lastMouseY;
ArrayList<PointMass> grabbed = new ArrayList<PointMass>();

void setup() {
  size(600, 600);
  int rows = 20;
  int cols = 30;
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
        p.mouseGrabScalar = 1/(pow(dist(p.x,p.y,mouseX,mouseY),0.1));
        grabbed.add(p);
      }
    }
  }
}
