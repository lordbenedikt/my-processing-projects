List<Integer> pressedKeys = new ArrayList<Integer>();

float dragFromX;
float dragFromY;

void mousePressed() {
  if (mouseButton==CENTER) {
    pivotX = mouseX;
    pivotY = mouseY;
  } else {
    // set drag anchor point
    dragFromX = mouseX;
    dragFromY = mouseY;
    // check ToolbarClicks
    for (ToolbarItem item : toolbar.items) {
      item.click();
    }
    strokeWeightInput.click();
    colorPicker.click();

    if (!toolbarAction) {
      if (mouseButton==LEFT) {
        toolCreate(false);
      } else if (mouseButton==RIGHT) {
        toolCreate(true);
      }
    }
  }
}

void mouseReleased() {
  toolbarAction = false;
}

void keyPressed() {
  strokeWeightInput.input();
  if (!pressedKeys.contains(keyCode)) {
    pressedKeys.add(keyCode);
  }
  if (keyIsDown(CONTROL) && keyCodeIs('s')) {
    saveToFile();
  }
  if (keyIsDown(CONTROL) && keyCodeIs('z')) {
    if (drawables.size()>0) {
      int indexLast = drawables.size()-1;
      redoStack.add(drawables.get(indexLast));
      drawables.remove(indexLast);
    }
  }
  if (keyIsDown(CONTROL) && keyCodeIs('y')) {
    if (redoStack.size()>0) {
      int indexLast = redoStack.size()-1;
      drawables.add(redoStack.get(indexLast));
      redoStack.remove(indexLast);
    }
  }
}

void keyReleased() {
  if (!pressedKeys.contains(keyCode)) {
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
  return keyIsDown(Character.toUpperCase(c));
}
