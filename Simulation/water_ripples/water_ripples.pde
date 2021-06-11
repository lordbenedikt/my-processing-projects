int cols,rows;
float[][] current;
float[][] previous;

float dampening = 0.95;

void setup() {
  size(600, 400);
  cols = width;
  rows = height;
  current = new float[cols][rows];
  previous = new float[cols][rows];
}

void mousePressed() {
  current[mouseX][mouseY] = 5000;
}

void draw() {
  background(0);
  
  float[][] temp = previous;
  previous = current;
  current = temp;
  
  System.out.println(current[10][10]);
  
  loadPixels();
  for (int i = 1; i < cols-1; i++) {
    for (int j = 1; j < rows-1; j++) {
      current[i][j] = (
        previous[i-1][j] + 
        previous[i+1][j] +
        previous[i][j-1] + 
        previous[i][j+1]) / 2 -
        current[i][j];
      current[i][j] = current[i][j] * dampening;
      int index = i + j * cols;
      float pixColor = current[i][j];
      pixels[index] = color(map(pixColor,-500,500,0,255));
    }
  }

  updatePixels();
}
