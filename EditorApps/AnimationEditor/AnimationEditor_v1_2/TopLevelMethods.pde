PVector mouseMovement() {
  PVector movement = new PVector(mouseX-lastMouseX,mouseY-lastMouseY);
  lastMouseX = mouseX;
  lastMouseY = mouseY;
  return movement;
}
PVector mousePos() {
  return new PVector(mouseX,mouseY);
}
