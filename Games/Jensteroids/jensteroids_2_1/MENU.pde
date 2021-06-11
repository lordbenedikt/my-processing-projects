void Menu() {
  image(menu_background, 0, 0);
  fill(255);

  textAlign(CENTER, CENTER);
  textSize(100);

  text("JENSTEROIDS!", width/2, 150);
  rectMode(CENTER);
  fill(255, 0, 0);
  rect(width/2, startButton_y, 100, 50 );
  fill(255);
  textSize(25);
  text("START", width/2, startButton_y);
  textSize(15);
  text("Ben&Jens Corporation BETA version 2.1", 695, 595 );

  boolean onButton = insideBox(mouseX, mouseY, width/2-50, startButton_y-25, width/2+50, startButton_y+25);
  if (mousePressed && onButton) state = GameModes.PLAY; 
  if (!onButton) cursor(ARROW);
  if (onButton) {
    cursor(HAND);
    rectMode(CENTER);
    fill(255);
    rect(width/2, startButton_y, 100, 50);
    fill(255, 0, 0);
    textSize(25);
    text("START", width/2, startButton_y);
  }
}
