ArrayList<Integer> pressedKeys = new ArrayList<Integer>();

void keyPressed() {
  if (!pressedKeys.contains(keyCode)) {
    pressedKeys.add(keyCode);
  }
}

void keyReleased() {
  if (pressedKeys.contains(keyCode)) {
    pressedKeys.remove((Integer)keyCode);
  }
}

boolean keyCodeIs(char c) {
  return keyCode==Character.toUpperCase(c);
}

boolean keyIsDown(int k) {
  return pressedKeys.contains(k);
}
boolean keyIsDown(char c) {
  return keyIsDown((int)Character.toUpperCase(c));
}
