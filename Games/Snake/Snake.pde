import java.util.Random;

Random r = new Random();
Screen screen;
color snakeColor = color(0, 255, 0);
Player player;

void setup() {
  size(800, 600);
  restart();
}

void restart() {
  screen = new Screen(800, 600, 30, 40);
  player = screen.player;
}

void draw() {
  screen.update();
  screen.draw();
}
