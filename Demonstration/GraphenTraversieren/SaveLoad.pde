import java.io.*;

void saveToFile() {
  saveClear("Graph.txt");
  for (Node n : g.nodes) {
    saveAdd("Graph.txt", n.name + " (" + n.x + "," + n.y + ") ->");
    for (Node subNode : n.connectedTo) {
      saveAdd("Graph.txt", " " + subNode.name);
    }
    saveAdd("Graph.txt", "\n");
  }
}
void saveClear(String name) {
  try {
    FileWriter writer = new FileWriter(sketchPath("")+name, false);
    writer.close();
  }  
  catch (IOException e) {
    e.printStackTrace();
  }
}
void saveAdd(String name, String content) {
  try {
    FileWriter writer = new FileWriter(sketchPath("")+name, true);
    writer.write(content);
    writer.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}
void loadFile(String name) {
  try {
    FileReader reader = new FileReader(sketchPath("")+name);
    BufferedReader bufferedReader = new BufferedReader(reader);

    g.nodes.clear();
    ArrayList<String> lines = new ArrayList<String>();
    String line;
    while ((line = bufferedReader.readLine()) != null) {
      lines.add(line);
    }
    for (String l : lines) {
      String[] sides = l.split(" -> ");
      String[] nameCoords = sides[0].split(" ");
      String coords[] = nameCoords[1].substring(1, nameCoords[1].length()-1).split(",");
      float x = parseFloat(coords[0]);
      float y = parseFloat(coords[1]);
      Node newNode = new Node(x, y, nameCoords[0].charAt(0));
      g.addNode(newNode);
    }
    for (String l : lines) {
      String[] sides = l.split(" -> ");
      if (sides.length>1) {
        String[] pointsTo = sides[1].split(" ");
        for (String s : pointsTo) {
          g.connect(sides[0].split(" ")[0].charAt(0), s.charAt(0), false);
        }
      }
    }


    System.out.println("Loaded "+name);
    reader.close();
  }
  catch (IOException e) {
    System.out.println("File not Found!");
    //e.printStackTrace();
  }
}
