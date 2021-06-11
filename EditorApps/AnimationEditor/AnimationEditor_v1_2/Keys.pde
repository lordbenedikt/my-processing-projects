float lastMouseX = mouseX;
float lastMouseY = mouseY;
PVector mouseAnchor = mousePos();
PVector mouseMovement;
PVector centerOfTransform;

PVector dragFrom;
boolean dragSelect = false;

Set<Integer> pressedKeys = new HashSet<Integer>();

void mousePressed() {
  dragFrom = new PVector(mouseX, mouseY);
}
void mouseDragged() {
  if (!scaling) {
    if (dist(dragFrom.x, dragFrom.y, mouseX, mouseY)>3) {
      dragSelect = true;
    }
  }
}
void mouseReleased() {
  if (rotating) {
    rotating = false;
  } else if (scaling) {
    scaling = false;
  } else if (dragSelect) {
    dragSelect = false;
    for (Vertex v : vertices) {
      if (!keyIsDown(SHIFT)) {
        v.unselect();
      }
      float vx = v.pos.x;
      float vy = v.pos.y;
      if (vx < dragFrom.x && vx < mouseX) continue;
      if (vx > dragFrom.x && vx > mouseX) continue;
      if (vy < dragFrom.y && vy < mouseY) continue;
      if (vy > dragFrom.y && vy > mouseY) continue;
      if (v.selected) v.unselect();
      else v.select();
    }
  } else {
    if (movingVertices) {
      movingVertices = false;
    } else {
      //create Vertex
      if (keyIsDown(CONTROL)) {
        createVertexSelected(mouseX, mouseY);
      } else {
        for (Vertex v : vertices) {
          v.click();
        }
      }
    }
  }
}
void keyPressed() {
  //add keys to list of pressed keys
  if (keyCode==SHIFT) pressedKeys.add(new Integer(SHIFT));
  if (keyCode==CONTROL) pressedKeys.add(new Integer(CONTROL));

  //apply texture
  if (key=='t') {
    for(Vertex v : selectedVertices) {
      v.texture = true;
      v.texturePos = v.pos.copy();
    }
  }

  //move
  if (key=='g') {
    movingVertices = true;
  }

  //scale
  if (key=='s') {
    scaling = true;
    centerOfTransform = getCenter(selectedVertices);
    mouseAnchor = mousePos();
    for (Vertex v : selectedVertices) {
      v.beforeTransformation = v.pos.copy();
    }
  }

  //rotate
  if (key=='r') {
    rotating = true;
    centerOfTransform = getCenter(selectedVertices);
    mouseAnchor = mousePos();
    for (Vertex v : selectedVertices) {
      v.beforeTransformation = v.pos.copy();
    }
  }

  //merge vertices
  if (key=='m') {

    HashSet<Vertex> allLinkedToVertices = new HashSet<Vertex>();

    int i = 0;
    int numOfSelectedVertices = selectedVertices.size();
    float xTotal = 0;
    float yTotal = 0;
    while (i<selectedVertices.size()) {

      Vertex v = selectedVertices.get(i);
      xTotal += v.pos.x;
      yTotal += v.pos.y;
      for (Vertex vert : v.linkedTo) {
        if (!selectedVertices.contains(vert)) {
          allLinkedToVertices.add(vert);
        }
      }
      deleteVertex(selectedVertices.get(i));
    }
    Vertex newVertex = createVertexSelected(xTotal/numOfSelectedVertices, yTotal/numOfSelectedVertices);
    for (Vertex v : allLinkedToVertices) {
      newVertex.linkTo(v);
    }
  }

  //delete
  if (key=='x') {
    vertices.removeAll(selectedVertices); 
    selectedVertices.clear();
  }

  //add keyframe
  if (key=='k') {
    keyFrames.add(new KeyFrame(vertices, links));
  }

  //delete vertices
  if (keyCode==DELETE) {
    vertices.removeAll(selectedVertices); 
    selectedVertices.clear();
  }

  //extrude
  if (key=='e') {
    ArrayList<Vertex> sV = new ArrayList<Vertex>(selectedVertices); 
    for (Vertex v : sV) {
      v.unselect(); 
      Vertex newVertex = createVertexSelected(v.pos.x, v.pos.y); 
      newVertex.linkTo(v); 
      movingVertices = true;
    }
  }
}
void keyReleased() {
  //remove keys from list of pressed keys
  if (keyCode==SHIFT) pressedKeys.remove(new Integer(SHIFT)); 
  if (keyCode==CONTROL) pressedKeys.remove(new Integer(CONTROL));
}
boolean keyIsDown(int pressedKey) {
  return pressedKeys.contains(pressedKey);
}
