void drawHouse(float x, float y) {
  fill(100);
  strokeWeight(3);
  rect(x, y, 200, 500);
  for (int i = 1; i<stockwerke; i++) {
    line(x, y+houseHeight/stockwerke*i, x+houseWidth, y+houseHeight/stockwerke*i);
  }
}
