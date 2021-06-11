void jens(float x, float y) {
  fill(242, 216, 159);                     
  ellipse(x, y, 80, 80);
  fill(255);
  ellipse(x+15, y, 15, 15);
  ellipse(x-15, y, 15, 15);
  fill(0);
  ellipse(x+15, y+3, 5, 5);
  ellipse(x-15, y+3, 5, 5);
  noFill();
  line(x-10, y+15, x+10, y+15);

  //line(x,y+50,x,y+250);
} 

void drawJens() {
  imageMode(CENTER);
  image(jens, jens_x, jens_y, 80, 80);
}

void moveJens() {
  if (keyS) jens_y += 8;
  if (keyW) jens_y -= 8;
  if (keyA) jens_x -= 8;
  if (keyD) jens_x += 8;
}

void checkEdgesJens() {
  if (jens_x < 40) jens_x = 40;
  if (jens_x > 760) jens_x = 760;
  if (jens_y < 40 ) jens_y = 40;
  if (jens_y > 560) jens_y = 560;
}
