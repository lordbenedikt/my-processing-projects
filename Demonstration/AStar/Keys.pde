void keyPressed() {
  //add key to list
  if (!keys.contains(keyCode)) {
    keys.add(keyCode);
  }

  //delete Knoten
  if (keyCode==((int)'X')) {
    for(Knoten k : selection) {
      k.delete();
    }
    selection.clear();
  }

  //assign start/ziel Knoten
  if (keys.contains(CONTROL)) {
    if (keyCode==((int)'S')) {
      if (!selection.isEmpty())
        start = selection.get(selection.size()-1);
    }
    if (keyCode==((int)'Z')) {
      if (!selection.isEmpty())
        ziel = selection.get(selection.size()-1);
    }
    //link all selected Knoten
    if (keyCode==((int)'L')) {
      for (int i = 0; i<selection.size(); i++) {
        for (int j = i+1; j<selection.size(); j++) {
          selection.get(i).link(selection.get(j));
        }
      }
    }
    //unlink all selected Knoten
    if (keyCode==((int)'K')) {
      for (int i = 0; i<selection.size(); i++) {
        for (int j = i+1; j<selection.size(); j++) {
          removeKante(selection.get(i), selection.get(j));
        }
      }
    }
  }

  //move selection
  if (keyIsDown('g')) {
    moving = true;
  }
}

void keyReleased() {
  if (keys.contains(keyCode))
    keys.remove((Integer)keyCode);
}

boolean keyIsDown(char c) {
  return keys.contains((int)Character.toUpperCase(c));
}

boolean keyIsDown(int x) {
  return keys.contains(x);
}
