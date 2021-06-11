class Knoten {
  float x;
  float y;
  Knoten(float x, float y) {
    this.x = x;
    this.y = y;
  }
  void link(Knoten knoten) {
    Kante newKante = new Kante(this, knoten);
    for (Kante k : kanten) {
      if (k.equals(newKante)) return;
    }
    kanten.add(newKante);
  }
  ArrayList<Kante> getKanten() {
    ArrayList<Kante> attached = new ArrayList<Kante>();
    for (Kante kante : kanten) {
      if (kante.a == this || kante.b == this)
        attached.add(kante);
    }
    return attached;
  }
  void delete() {
    kanten.removeAll(getKanten());
    knoten.remove(this);
  }
  ArrayList<Knoten> neighbours() {
    ArrayList<Knoten> neighbours = new ArrayList<Knoten>();
    for(Kante k : getKanten()) {
      if (!neighbours.contains(k.a) && k.a != this) {
        neighbours.add(k.a);
      }
      if (!neighbours.contains(k.b) && k.b != this) {
        neighbours.add(k.b);
      }
    }
    return neighbours;
  }
  void draw() {
    noStroke();
    fill(255);
    if (path.contains(this)) fill(255,255,0);
    if (this == start) fill(0, 255, 0);
    if (this == ziel) fill(255, 0, 0);
    circle(x, y, 10);
  }
}

ArrayList<Kante> getKanten(ArrayList<Knoten> multipleKnoten) {
  ArrayList<Kante> result = new ArrayList<Kante>();
  for (Knoten k : multipleKnoten) {
    for (Kante kk : k.getKanten()) {
      if (!result.contains(kk))
        result.add(kk);
    }
  }
  return result;
}
