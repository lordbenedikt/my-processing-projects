import java.util.*;

Labyrinth l1 = new Labyrinth(50,50,500,30);

void setup() {
  size(600, 600);
}

void draw() {
  background(255);
  l1.draw();
}

void mousePressed() {
  l1 = new Labyrinth(50,50,500,20);
}
