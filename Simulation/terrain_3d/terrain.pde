int rows, cols;
int scl = 40;
int w = 3000;
int h = 3000;
float terrain[][];
float flying = 0;

void setup(){
  size(800,600,P3D);
  cols = w/scl;
  rows = h/scl;
  terrain = new float[cols+1][rows+1];
}

void draw() {
  flying -= 0.1;
  
  System.out.println(rows);
  System.out.println(cols);
  float yOff = flying;
  for(int y = 0; y<rows+1; y++) {
    float xOff = 0;
    for(int x = 0; x<cols+1; x++) {
      terrain[x][y] = map(noise(xOff,yOff),0,1,-150,150);
      xOff += 0.1;
    }
    yOff += 0.1;
  }
  
  background(0);
  
  translate(width/2,height/2);
  rotateX(PI/3);
  
  translate(-w/2,-h/2);
  for(int y = 0; y<rows; y++) {
    beginShape(TRIANGLE_STRIP);
    for(int x = 0; x<cols; x++) {
      stroke(255);
      noFill();
      vertex(x*scl,y*scl,terrain[x][y]);
      vertex(x*scl,(y+1)*scl,terrain[x][y+1]);
    }
    endShape();
  }
}
