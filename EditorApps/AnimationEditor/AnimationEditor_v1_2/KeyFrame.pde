class KeyFrame {
  Vertex[] vertices;
  Link[] links;
  KeyFrame(ArrayList<Vertex> vertices,ArrayList<Link> links) {
    this.vertices = new Vertex[vertices.size()];
    this.links = new Link[links.size()];
    for(int i = 0; i<vertices.size();i++) {
      this.vertices[i] = new Vertex(vertices.get(i).pos.x,vertices.get(i).pos.y,vertices.get(i).texturePos);
      for(Vertex v : this.vertices[i].linkedTo) {
      }
    }
    for(int i = 0; i<links.size();i++) {
      this.links[i] = new Link(this.vertices[vertices.indexOf(links.get(i).v1)],this.vertices[vertices.indexOf(links.get(i).v2)]);
    }
  }
  
}
