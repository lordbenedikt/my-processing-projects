ArrayList<Integer> pressedKeys = new ArrayList<Integer>();

void keyPressed() {
  if (!pressedKeys.contains(keyCode)) {
    pressedKeys.add(keyCode);
  }
  if (key=='r') {
    ply.pos = new PVector(500,100);
    ply.lastPos = ply.pos.copy();
  }
}
void keyReleased() {
  if(pressedKeys.contains(keyCode)) {
    pressedKeys.remove((Integer)keyCode);
  }
}
boolean keyIsDown(int i) {
  return pressedKeys.contains(i);
}
boolean keyIsDown(char c) {
  return keyIsDown((int)Character.toUpperCase(c));
}
