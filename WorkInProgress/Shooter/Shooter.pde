Ufo ufo = new Ufo(200,200);
Rocket rocket = new Rocket(300,300);
Player ply = new Player(400,400);

ArrayList<Bullet> bullets = new ArrayList<Bullet>();

void setup() {
  size(800, 600);
  graphicsCollision = createGraphics(width, height);
  loadImages();
}

void draw() {
  background(30);
  ufo.update();
  rocket.update();
  ply.update();
  
  int i = 0;
  while(i<bullets.size()) {
    bullets.get(i).update();
    i++;
  }
  
  rocket.x = mouseX;
  rocket.y = mouseY;
  //fill(255);
  //text(isColliding(ufo,rocket) ? "true" : "false",20,20);
  // pixel collision
   //image(graphicsCollision,300,300,800,600);
}
