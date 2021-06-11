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
