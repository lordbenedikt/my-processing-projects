void Menu() {
  background(space);
  fill(255);
  textSize(100);
  text("JENSTEROIDS!", 95, 150);
  rectMode(CENTER);
  fill(255, 0, 0);
  rect(startButton_x, startButton_y, 100, 50 );
  fill(255);
  textSize(25);
  text("START", startButton_x -38, startButton_y + 9);
  textSize(15);
  text("Jens Fernández Mühlke  BETA version 1.0", 495, 595 );

  if (mousePressed & ((startButton_x -50) < mouseX & mouseX < (startButton_x + 50) ) & (mouseY > startButton_y - 25 & mouseY < startButton_y +25)) state = GameModes.PLAY;
  if (!(( startButton_x -50 < mouseX  & mouseX < ( startButton_x + 50) ) & (mouseY > startButton_y - 25 & mouseY < startButton_y +25))) cursor(ARROW);
  if ((( startButton_x -50 < mouseX  & mouseX < ( startButton_x + 50) ) & (mouseY > startButton_y - 25 & mouseY < startButton_y +25))) {
    cursor(HAND);
    rectMode(CENTER);
    fill(255);
    rect(startButton_x, startButton_y, 100, 50);
    fill(255, 0, 0);
    textSize(25);
    text("START", startButton_x -38, startButton_y + 9);
  }
}
