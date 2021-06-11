import java.util.*;

ArrayList<Vertex> vertices = new ArrayList<Vertex>();
ArrayList<Vertex> selectedVertices = new ArrayList<Vertex>();
ArrayList<Link> links = new ArrayList<Link>();
ArrayList<KeyFrame> keyFrames = new ArrayList<KeyFrame>();
ArrayList<Vertex> curFrame = new ArrayList<Vertex>();

int count = 0;
int count2 = 0;

boolean movingVertices = false;
boolean scaling = false;
boolean rotating = false;

PImage texture;

void setup() {
  texture = loadImage("cloth2.jpg");
  texture.resize(600,600);
  
  size(600, 600, P3D);

  vertices.add(new Vertex(100, 100));
  vertices.add(new Vertex(100, 200));
  vertices.add(new Vertex(140, 180));
}

void draw() {


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
  //println(count2);
  curFrame.clear();
  if (!keyFrames.isEmpty()) {
    for (int i = 0; i<keyFrames.get(count2).vertices.length; i++) {
      Vertex vCurrent = keyFrames.get(count2).vertices[i];
      Vertex vNext = keyFrames.get((count2+1) % keyFrames.size()).vertices[i];
      Vertex curVertex = new Vertex((vCurrent.pos.x*(100-count)/100 + (vNext.pos.x*count)/100), (vCurrent.pos.y*(100-count)/100 + vNext.pos.y*count/100), vCurrent.texturePos);
      curFrame.add(curVertex);
      //drawVertex(  curFrame.get(curFrame.size()-1)  );
    }
    println(keyFrames.get(count2).links.length);
    for (int i = 0; i<keyFrames.get(count2).links.length; i++) {
      Link lCurrent = keyFrames.get(count2).links[i];
      Link lNext = keyFrames.get((count2+1) % keyFrames.size()).links[i];
      drawLink(  (lCurrent.v1.pos.x*(100-count)/100 + (lNext.v1.pos.x*count)/100), (lCurrent.v1.pos.y*(100-count)/100 + lNext.v1.pos.y*count/100), 
        (lCurrent.v2.pos.x*(100-count)/100 + (lNext.v2.pos.x*count)/100), (lCurrent.v2.pos.y*(100-count)/100 + lNext.v2.pos.y*count/100)  );
    }
  }
  //draw texture of current frame
  noStroke();
  beginShape();
  texture(texture);
  for(Vertex v : curFrame) {
    vertex(v.pos.x,v.pos.y,v.texturePos.x,v.texturePos.y);
  }
  endShape();

  mouseMovement = mouseMovement();

  //scale selected vertices
  if (scaling) {
    for (Vertex v : selectedVertices) {
      v.pos.x = v.beforeTransformation.x + (v.beforeTransformation.x - centerOfTransform.x)*(mouseX-mouseAnchor.x-(mouseY-mouseAnchor.y))/100;
      v.pos.y = v.beforeTransformation.y + (v.beforeTransformation.y - centerOfTransform.y)*(mouseX-mouseAnchor.x-(mouseY-mouseAnchor.y))/100;
    }
  }

  //rotate selected vertices
  if (rotating) {
    for (Vertex v : selectedVertices) {
      PVector relativeToCenter = PVector.sub(v.beforeTransformation,centerOfTransform);
      v.pos = centerOfTransform.copy().add(relativeToCenter.rotate((mouseX-mouseAnchor.x-(mouseY-mouseAnchor.y))/100));
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
  
  //draw texture
  noStroke();
  beginShape();
  texture(texture);
  for(Vertex v : vertices) {
    vertex(v.pos.x,v.pos.y,v.texturePos.x,v.texturePos.y);
  }
  endShape();

  //draw selectBox
  if (dragSelect) {
    fill(255, 30);
    stroke(255);
    rect(dragFrom.x, dragFrom.y, mouseX-dragFrom.x, mouseY-dragFrom.y);
  }
}
