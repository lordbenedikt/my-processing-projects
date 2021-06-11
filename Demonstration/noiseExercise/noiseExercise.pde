float w = 2;
//float x = 0;
//float y = 0;
float base = 300;
int sectionc = 10;
float[] yy = new float[sectionc+1];

void setup() {
  size(600,600);
  for(int i = 0; i< yy.length; i++) {
    yy[i] = random(-300,300);
  }
}

void mouseClicked() {
  for(int i = 0; i< yy.length; i++) {
    yy[i] = random(-300,300);
  }
}

void draw() {
  background(255);
  fill(0);
  int prec = 10000;
  for(float i = 0; i<prec; i++) {
    int sectionWidth = prec/sectionc;
    float y = smoothlerp(yy[(int)i/sectionWidth],
              yy[((int)i+sectionWidth)/sectionWidth],
              (i%sectionWidth)/sectionWidth);
    circle((i/prec*width)+1,base+y,w);
  }
}

float myLerp(float a, float b, float x) {
  return a * (1-x) + b*x;
}
float smoothlerp(float a, float b, float x) {
  return myLerp(a,b,smoothstep(x));
}
float smoothstep(float x) {
  return 3 * pow(x,2) - 2 * pow(x,3);
}
