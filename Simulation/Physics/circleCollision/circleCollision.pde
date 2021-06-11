Circle ball = new Circle(300, 300, 40);

float mouseXLast;
float mouseYLast;
float grabX;
float grabY;

void setup() {
  size(600, 600);
}

void draw() {
  background(100);

  if (mousePressed && mouseButton==LEFT) {
    ball.x += mouseX - (ball.x+grabX);
    ball.y += mouseY - (ball.y+grabY);
    ball.velX = 0;
    ball.velY = 0;
  }

  ball.update();
  if(mousePressed && mouseButton==LEFT) {
    line(ball.x+grabX, ball.y+grabY, mouseX, mouseY);
  }

  mouseXLast = mouseX;
  mouseYLast = mouseY;
}

void mousePressed() {
  if (mouseButton==LEFT) {
    grabX = mouseX-ball.x;
    grabY = mouseY-ball.y;
  }
}
