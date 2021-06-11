class Kante {
  Knoten a;
  Knoten b;
  Kante(Knoten a, Knoten b) {
    this.a = a;
    this.b = b;
  }
  boolean equals(Kante k) {
    if (a==k.a && b==k.b) return true;
    if (b==k.a && a==k.b) return true;
    return false;
  }
  void draw() {
    strokeWeight(2);
    if(path.contains(a) && path.contains(b)) {
      strokeWeight(5);
      stroke(255,255,0);
    }
    line(a.x, a.y, b.x, b.y);
  }
}

Kante getKante(Knoten a, Knoten b) {
  Kante wanted = new Kante(a,b);
  for (Kante k : kanten) {
    if (k.equals(wanted)) 
      return k;
  }
  return null;
}

void removeKante(Knoten a, Knoten b) {
  Kante k = getKante(a,b);
  if (k!=null)
    kanten.remove(k);
}
