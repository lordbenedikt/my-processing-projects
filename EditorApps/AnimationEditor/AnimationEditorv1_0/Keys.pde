float lastMouseX = mouseX;
float lastMouseY = mouseY;
PVector mouseMovement;

PVector dragFrom;
boolean dragSelect = false;

Set<Integer> pressedKeys = new HashSet<Integer>();

void mousePressed() {
  dragFrom = new PVector(mouseX, mouseY);
}
void mouseDragged() {
  if (dist(dragFrom.x, dragFrom.y, mouseX, mouseY)>3) {
    dragSelect = true;
  }
}
void mouseReleased() {
  if (dragSelect) {
    dragSelect = false;
    for (Vertex v : vertices) {
      v.selected = false;
      float vx = v.pos.x;
      float vy = v.pos.y;
      if (vx < dragFrom.x && vx < mouseX) continue;
      if (vx > dragFrom.x && vx > mouseX) continue;
      if (vy < dragFrom.y && vy < mouseY) continue;
      if (vy > dragFrom.y && vy > mouseY) continue;
      v.selected = true;
    }
  } else {
    if (movingVertices) {
      movingVertices = false;
    } else {
      //create Vertex
      if (keyIsDown(CONTROL)) {
        createVertexSelected(mouseX,mouseY);
      } else {
        for (Vertex v : vertices) {
          v.select();
        }
      }
    }
  }
}
void keyPressed() {
  //add keys to list of pressed keys
  if (keyCode==SHIFT) pressedKeys.add(new Integer(SHIFT));
  if (keyCode==CONTROL) pressedKeys.add(new Integer(CONTROL));

  //move
  if (key=='g') {
    movingVertices = true;
  }

  //merge vertices
  if (key=='m') {
    int i = 0;
    while(i < vertices.size()) {
      if(vertices.get(i).selected) {
        
        //if more than one selected vertex
        if(vertices.size()>1) {
          
          if(vertices.get(i).linkedTo.isEmpty()) {
          vertices.remove(i);
          continue;
          }
          
        }
      }
      i++;
    }
  }

  //delete
  if (key=='x') {
    int i = 0;
    while (i<vertices.size()) {
      if (vertices.get(i).selected) {
        vertices.remove(i);
        continue;
      }
      i++;
    }
  }

  if (keyCode==DELETE) {
    int i = 0;
    while (i<vertices.size()) {
      if (vertices.get(i).selected) {
        vertices.remove(i);
        continue;
      }
      i++;
    }
  }

  //extrude
  if (key=='e') {
    int j = vertices.size();
    for (int i = 0; i<j; i++) {
      if (vertices.get(i).selected) {
        vertices.get(i).selected = false;
        Vertex newVertex = new Vertex(vertices.get(i).pos.x, vertices.get(i).pos.y);
        newVertex.selected = true;
        vertices.add(newVertex);
        newVertex.linkTo(vertices.get(i));
        movingVertices = true;
      }
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
