boolean isInsideRect(PVector v, PVector p1, PVector p2) {
      if (v.x < p1.x && v.x < p2.x) return false;
      if (v.x > p1.x && v.x > p2.x) return false;
      if (v.y < p1.y && v.y < p2.y) return false;
      if (v.y > p1.y && v.y > p2.y) return false;
      return true;
}
