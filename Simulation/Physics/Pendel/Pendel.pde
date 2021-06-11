float pinX = 300;
float pinY = 100;

float l = 200;
float g = -0.3;

float angle = PI/3;
float lastAngle = angle;
float acceleration = 0;
float speed = 0;
float lastSpeed = speed;

void setup() {
  size(600,600);
}

void draw() {
  background(200);
  
  float x = pinX + sin(angle)*l;
  float y = pinY + cos(angle)*l;
  
  line(pinX,pinY,x,y);
  circle(x,y,40);
  
  acceleration = g/l * sin(lastAngle);
  speed = lastSpeed + acceleration;
  angle = lastAngle + speed;
  
  lastAngle = angle;
  lastSpeed = speed;
  
  saveFrame("mySketch-####.jpg");
}
