//Keys
boolean keyW = false;
boolean keyS = false;
boolean keyA = false;
boolean keyD = false;
boolean keyUp = false;
boolean keyDown = false;
boolean keyLeft = false;
boolean keyRight = false;
boolean keyEsc = false;
boolean keySpace = false;
boolean keyR = false;
boolean keyShift = false;
boolean keyDel = false;

public void keyPressed() {
  if (keyCode == ESC) {
    key = 0;
    keyEsc = true;
  }
  if (state==GM.EDITOR) {
    if (activeTextBox!=null) {
      handleInput(key);
      return;
    }
  }
  if (keyCode == UP) keyUp = true;
  if (keyCode == DOWN) keyDown = true;
  if (keyCode == LEFT) keyLeft = true;
  if (keyCode == RIGHT) keyRight = true;
  if (keyCode == SHIFT) keyShift = true;
  if (keyCode == DELETE) keyDel = true;
  if (Character.toUpperCase(key) == 'W') keyW = true;
  if (Character.toUpperCase(key) == 'S') keyS = true;
  if (Character.toUpperCase(key) == 'A') keyA = true;
  if (Character.toUpperCase(key) == 'D') keyD = true;
  if (key == ' ') keySpace = true;
  if (Character.toUpperCase(key) == 'R') keyR = true;
}

public void keyReleased() {
  //if (keyCode == ESC) keyEsc = false;
  if (keyCode == UP) keyUp = false;
  if (keyCode == DOWN) keyDown = false;
  if (keyCode == LEFT) keyLeft = false;
  if (keyCode == RIGHT) keyRight = false;
  if (keyCode == SHIFT) keyShift = false;
  if (keyCode == DELETE) keyDel = false;
  if (Character.toUpperCase(key) =='W') keyW = false;
  if (Character.toUpperCase(key) == 'S') keyS = false;
  if (Character.toUpperCase(key) == 'A') keyA = false;
  if (Character.toUpperCase(key) == 'D') keyD = false;
  if (key == ' ') keySpace = false;
  if (Character.toUpperCase(key) == 'R') keyR = false;
}
void handleInput(char key) {
  if (key==BACKSPACE) {
    if(activeTextBox.value.length()>0) {
      System.out.println(activeTextBox.value.length());
      activeTextBox.value = activeTextBox.value.substring(0,activeTextBox.value.length()-1);
    }
    return;
  }
  if (key==ENTER) {
    activeTextBox.setValue();
    activeTextBox = null;
    return;
  }
    activeTextBox.value = activeTextBox.value + key;
}
