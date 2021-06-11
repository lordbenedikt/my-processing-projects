void keyPressed() {
  if (key == '+') {
    screen.player.addSegment();
  }
  if (keyCode == UP) {
    if (player.getAbove(player.body[0]) != player.body[1]) {
      screen.player.direction = 0;
    }
  }
  if (keyCode == DOWN) {
    if (player.getBelow(player.body[0]) != player.body[1]) {
      screen.player.direction = 2;
    }
  }
  if (keyCode == LEFT) {
    if (player.getLeft(player.body[0]) != player.body[1]) {
      screen.player.direction = 3;
    }
  }
  if (keyCode == RIGHT) {
    if (player.getRight(player.body[0]) != player.body[1]) {
      screen.player.direction = 1;
    }
  }
  if (Character.toUpperCase(key) == Character.toUpperCase('r')) {
    
  }
}
