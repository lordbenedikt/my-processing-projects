PImage image_ufo;
PImage image_rocket;

void loadImages() {
  imageMode(CENTER);
  image_ufo = loadImage("UFO_small.png", "png");
  image_rocket = loadImage("rocket_small.png", "png");
  image_ufo.resize(120,60);
  image_rocket.resize(100,60);
}
