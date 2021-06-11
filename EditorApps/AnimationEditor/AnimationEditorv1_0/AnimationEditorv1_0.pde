import java.util.*;

ArrayList<Vertex> vertices = new ArrayList<Vertex>();
ArrayList<Vertex> selectedVertices = new ArrayList<Vertex>();
ArrayList<Link> links = new ArrayList<Link>();

boolean movingVertices = false;

void setup() {
  size(600, 600);

  vertices.add(new Vertex(100, 100));
  vertices.add(new Vertex(100, 200));
  vertices.add(new Vertex(140, 180));
}

void draw() {
  println(keyIsDown(SHIFT));

  mouseMovement = mouseMovement();

  background(0);

  //for all vertices
  int i = 0;
  while (i<vertices.size()) {
    vertices.get(i).update();
    vertices.get(i).draw();
    i++;
  }

  //for all links
  i = 0;
  while (i<links.size()) {
    if (vertices.contains(links.get(i).v1) && vertices.contains(links.get(i).v2)) {
      links.get(i).draw();
    }
    else {
      links.remove(i);
      continue;
    }
    i++;
  }
  
  //draw selectBox
  if (dragSelect) {
    noFill();
    stroke(255);
      rect(dragFrom.x,dragFrom.y,mouseX-dragFrom.x,mouseY-dragFrom.y);
  }

}
