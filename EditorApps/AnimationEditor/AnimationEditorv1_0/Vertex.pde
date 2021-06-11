class Vertex {
  PVector pos;
  ArrayList<Vertex> linkedTo = new ArrayList<Vertex>();
  boolean selected = false;
  boolean isBeingMoved = false;

  Vertex(float x, float y) {
    pos = new PVector(x, y);
  }
  void draw() {
    noStroke();
    if (selected) 
      fill(255);
    else
      fill(255, 150, 70);
    rect(pos.x-2, pos.y-2, 4, 4);
  }
  void update() {
    if (selected && movingVertices) {
      pos.x += mouseMovement.x;
      pos.y += mouseMovement.y;
    }
  }
  void select() {
    if (keyIsDown(CONTROL)) {
      selected = false;
      return;
    }
    if (dist(pos.x, pos.y, mouseX, mouseY) < 20) {
      selected = !selected;
    } else {

      //add/substract to selection
      if (!keyIsDown(SHIFT))
        selected = false;
    }
  }
  void remove() {
    vertices.remove(this);
    selectedVertices.remove(this);
  }
  void linkTo(Vertex v) {
    Link newLink = new Link(this, v);
    this.linkedTo.add(v);
    v.linkedTo.add(this);
    links.add(newLink);
  }
}
Vertex createVertex(float x, float y) {
  Vertex v = new Vertex(x, y);
  vertices.add(v);
  return v;
}
void createVertexSelected(float x, float y) {
  Vertex v = createVertex(x,y);
  selectedVertices.add(v);
}
