import java.util.*;

ArrayList<Vertex> vertices = new ArrayList<Vertex>();
ArrayList<Vertex> selectedVertices = new ArrayList<Vertex>();
ArrayList<Link> links = new ArrayList<Link>();
ArrayList<KeyFrame> keyFrames = new ArrayList<KeyFrame>();

int count = 0;
int count2 = 0;

boolean movingVertices = false;

void setup() {
  size(600, 600);

  vertices.add(new Vertex(100, 100));
  vertices.add(new Vertex(100, 200));
  vertices.add(new Vertex(140, 180));
}

void draw() {

  mouseMovement = mouseMovement();

  background(0);

  //count keyFrame
  if (count<100) count++;
  else {
    if (keyFrames.size()>0) {
      count2 = (count2 + 1) % keyFrames.size();
    }
    count = 0;
  }

  //draw keyFrame animation
  println(count2);
  if (!keyFrames.isEmpty()) {
    for (int i = 0; i<keyFrames.get(count2).vertices.length; i++) {
      Vertex vCurrent = keyFrames.get(count2).vertices[i];
      Vertex vNext = keyFrames.get((count2+1) % keyFrames.size()).vertices[i];
      drawVertex(  (vCurrent.pos.x*(100-count)/100 + (vNext.pos.x*count)/100), (vCurrent.pos.y*(100-count)/100 + vNext.pos.y*count/100)  );
    }
    println(keyFrames.get(count2).links.length);
    for (int i = 0; i<keyFrames.get(count2).links.length; i++) {
      Link lCurrent = keyFrames.get(count2).links[i];
      Link lNext = keyFrames.get((count2+1) % keyFrames.size()).links[i];
      drawLink(  (lCurrent.v1.pos.x*(100-count)/100 + (lNext.v1.pos.x*count)/100), (lCurrent.v1.pos.y*(100-count)/100 + lNext.v1.pos.y*count/100), 
        (lCurrent.v2.pos.x*(100-count)/100 + (lNext.v2.pos.x*count)/100), (lCurrent.v2.pos.y*(100-count)/100 + lNext.v2.pos.y*count/100)  );
    }
  }


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
    } else {
      links.remove(i);
      continue;
    }
    i++;
  }

  //draw selectBox
  if (dragSelect) {
    noFill();
    stroke(255);
    rect(dragFrom.x, dragFrom.y, mouseX-dragFrom.x, mouseY-dragFrom.y);
  }
}
