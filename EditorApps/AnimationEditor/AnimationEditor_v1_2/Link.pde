class Link {
  Vertex v1;
  Vertex v2;
  Link(Vertex v1, Vertex v2) {
    this.v1 = v1;
    this.v2 = v2;
  }
  void draw() {
    strokeWeight(1);
    stroke(255, 150, 70);
    line(v1.pos.x,v1.pos.y,v2.pos.x,v2.pos.y);
  }
}

void drawLink(float x1, float y1, float x2, float y2,float weight) {
    strokeWeight(weight);
    stroke(255, 150, 70);
    line(x1,y1,x2,y2);
}
void drawLink(float x1, float y1, float x2, float y2) {
  drawLink(x1,y1,x2,y2,1);
}
