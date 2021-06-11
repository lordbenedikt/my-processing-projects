import java.util.Random;
import java.util.Collections;

Random r = new Random();
int s = 4;
int dispersion = 1;
int rows;
int cols;
int[][] raster;
int count = 0;

void setup() {
  size(600, 600);
  cols = width/s;
  rows = height/s;
  raster = new int[cols][rows];

  randomize();
  for (int i = 0; i<1; i++) {
    model(raster, dispersion);
  }
}

void mouseClicked() {
  if (mouseButton==RIGHT) {
    randomize();
  }
  if (mouseButton==LEFT) {
    for (int i = 0; i<1; i++) {
      model(raster, dispersion);
    }
  }
}

void keyPressed() {
  if (key=='1') {
    dispersion = 1;
  }
  if (key=='2') {
    dispersion = 2;
  }
  if (key=='3') {
    dispersion = 3;
  }
  if (key=='4') {
    dispersion = 4;
  }
  if (key=='5') {
    dispersion = 5;
  }
  if (key=='6') {
    dispersion = 6;
  }
  if (key=='7') {
    dispersion = 7;
  }
  if (key=='8') {
    dispersion = 8;
  }
  if (key=='9') {
    dispersion = 9;
  }
  if (key=='0') {
    dispersion = 10;
  }
}

void draw() {
  background(0);
  noStroke();
  fill(255);
  for (int i = 0; i<raster.length; i++) {
    for (int j = 0; j<raster[i].length; j++) {
      if (raster[i][j]==1) {
        rect(i*s, j*s, s, s);
      }
    }
  }
  //if(count%100 == 0) {
  //randomize();
  //}
  if(count%1 == 0) {
    model(raster,dispersion);
  }
  count++;
  //loadPixels();
  //for(int i = 0; i<raster.length; i++) {
  //  for(int j = 0; j<raster[i].length; j++) {
  //      pixels[i*width+j] = color(raster[i][j]*255);
  //  }
  //}
  //updatePixels();
}

void model(int[][] _raster, int l) {
  ArrayList<Pos> positions = new ArrayList<Pos>();
  for (int i = 0; i<_raster.length; i++) {
    for (int j = 0; j<_raster[i].length; j++) {
      positions.add(new Pos(i, j));
    }
  }
  Collections.shuffle(positions);

  for (Pos p : positions) {
    float countWhite = 0;
    float countBlack = 0;
    float quotient = 0;
    for (int k = p.x-l; k<=p.x+l; k++) {
      for (int m = p.y-l; m<=p.y+l; m++) {
        float multiplier = 1/(sqrt(pow(k-p.x,2)+pow(m-p.y,2))+1);
        quotient += multiplier;
        if (k<0 || k>=_raster.length) {
          countBlack += multiplier;
        } else if (m<0 || m>=_raster[k].length) {
          countBlack += multiplier;
        } else if (_raster[k][m]==1) {
          countWhite += multiplier;
        } else {
          countBlack += multiplier;
        }
      }
    }
    //fireworks effect
    //if ((countWhite/(float)(countWhite+countBlack)>=random(0,1.1)))
    if (countWhite>countBlack) {
      _raster[p.x][p.y] = 1;
    } else {
      _raster[p.x][p.y] = 0;
    }
  }
}

void randomize() {
  raster = new int[cols][rows];
  for (int i = 0; i<raster.length; i++) {
    for (int j = 0; j<raster[i].length; j++) {
      if (random(0, 1)>0.5) raster[i][j] = 1;
      else raster[i][j] = 0;
    }
  }
  model(raster,dispersion);
}

class Pos {
  int x;
  int y;
  Pos(int x, int y) {
    this.x = x;
    this.y = y;
  }
}
