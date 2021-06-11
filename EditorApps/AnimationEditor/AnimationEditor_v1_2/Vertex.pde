class Vertex {
  PVector pos;
  PVector texturePos;
  PVector beforeTransformation;
  ArrayList<Vertex> linkedTo = new ArrayList<Vertex>();
  boolean selected = false;
  boolean isBeingMoved = false;
  boolean texture = false;

  Vertex(float x, float y) {
    pos = new PVector(x, y);
    texturePos = pos.copy();
  }
    Vertex(float x, float y, PVector texturePos) {
    pos = new PVector(x,y);
    this.texturePos = texturePos;
  }
  void draw() {
    //draw links
    //for (Vertex v : linkedTo) {
    //  stroke(255);
    //  line(pos.x, pos.y, v.pos.x, v.pos.y);
    //}

    noStroke();
    if (selected) 
      fill(255);
    else
      fill(255, 150, 70);
    rect(pos.x-2, pos.y-2, 4, 4);
  }
  void update() {
    //move selection
    if (selected && movingVertices) {
      pos.x += mouseMovement.x;
      pos.y += mouseMovement.y;
    }
  }
  void click() {
    if (keyIsDown(CONTROL)) {
      unselect();
      return;
    }
    if (dist(pos.x, pos.y, mouseX, mouseY) < 30) {
      if (selected) unselect(); 
      else select();
    } else {

      //add/substract to selection
      if (!keyIsDown(SHIFT))
        unselect();
    }
  }
  void select() {
    selected = true;
    selectedVertices.add(this);
  }
  void unselect() {
    selected = false;
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
void deleteVertex(Vertex v) {
  vertices.remove(v);
  selectedVertices.remove(v);
}
Vertex createVertexSelected(float x, float y) {
  Vertex v = createVertex(x, y);
  v.select();
  return v;
}

void drawVertex(float x, float y) {
  noStroke();
  fill(255, 150, 70);
  rect(x-2, y-2, 4, 4);
}
PVector getCenter(ArrayList<Vertex> vertices) {
  if (vertices.size()==0) return new PVector(0,0);
  float minX = vertices.get(0).pos.x;
  float minY = vertices.get(0).pos.y;
  float maxX = vertices.get(0).pos.x;
  float maxY = vertices.get(0).pos.y;
  for(Vertex v : vertices) {
    if (v.pos.x < minX) minX = v.pos.x;
    if (v.pos.y < minY) minY = v.pos.y;
    if (v.pos.x > maxX) maxX = v.pos.x;
    if (v.pos.y > maxY) maxY = v.pos.y;
  }
  PVector center = new PVector( (minX+maxX)/2, (minY+maxY)/2 );
  return center;
}
