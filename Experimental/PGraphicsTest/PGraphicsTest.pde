PGraphics layer0;
PGraphics layer1;
PGraphics layer2;
PGraphics glow;

void setup() {
  size(800, 600);
  glow = createGraphics(40,40);
  layer0 = createGraphics(width, height);
  layer1 = createGraphics(width, height);
  layer2 = createGraphics(width, height);
  glow.beginDraw();
  glow.rect(-1,-1,glow.width+2,glow.width+2);
  glow.loadPixels();
  for(int i = 0; i<glow.pixels.length;i++) {
    color c = glow.pixels[i];
    float opacity = map(dist(glow.width/2,glow.width/2,i%glow.width,i/glow.width),0,glow.width/2,255,0);
    glow.pixels[i] = color(red(c),green(c),blue(c),opacity);
  }
  glow.updatePixels();
  glow.endDraw();
}

void draw() {
  background(0, 0, 40);
  image(glow,mouseX,mouseY);
}
