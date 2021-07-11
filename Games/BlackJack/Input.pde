void mousePressed() {
  if (mouseButton==LEFT) {
    hit(currentPlayer);
  }
  if (mouseButton==RIGHT) {
    currentPlayer++;
  }
}

void keyPressed() {
  if (Character.toUpperCase(key)=='R') {
    reset(1);
  }
  if (Character.toUpperCase(key)=='N') {
    nextRound();
  }
}
