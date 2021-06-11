float mouseLastX;
float mouseLastY;

void mousePressed() {
  if (keyIsDown(CONTROL)) {
    if (mouseButton==LEFT) {
      Knoten newKnoten = new Knoten(mouseX, mouseY);
      knoten.add(newKnoten);
      for (Knoten k : selection) {
        kanten.add(new Kante(k, newKnoten));
      }
      selection.clear();
      selection.add(newKnoten);
    }
  } else if (keyIsDown(SHIFT)) {
    if (mouseButton==LEFT) {
      Knoten closest = getClosestToMouse();
      if (closest != null) {
        if (!selection.contains(closest)) {
          selection.add(closest);
        } else {
          selection.remove(closest);
        }
      }
    }
  } else if (mouseButton==LEFT) {
    if (!moving) {
      //select
      selection.clear();
      float shortestDistance = 50;
      for (Knoten k : knoten) {
        float currentDistance = dist(k.x, k.y, mouseX, mouseY);
        if (currentDistance < shortestDistance) {
          shortestDistance = currentDistance;
          selection.clear();
          selection.add(k);
        }
      }
    } else {
      if (!moving) {
        selection.clear();
      } else {
        moving = false;
      }
    }
  } else if (mouseButton==RIGHT) {
    if (!moving) {
      selection.clear();
    } else {
      moving = false;
    }
  }
}

Knoten getClosestToMouse() {
  float shortestDistance = 50;
  Knoten closest = null;
  for (Knoten k : knoten) {
    float currentDistance = dist(k.x, k.y, mouseX, mouseY);
    if (currentDistance < shortestDistance) {
      shortestDistance = currentDistance;
      closest = k;
    }
  }
  return closest;
}
