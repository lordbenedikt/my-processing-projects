import java.io.*;

void saveToFile() {
  saveClear("Bild.txt");
    Integer currentFill = null;
    Integer currentStroke = null;
    Float currentStrWeight = null;
    for (Drawable el : drawables) {
      if(currentFill==null || el.getFillColor()!=currentFill) {
        saveAdd("Bild.txt", "fill(" + colorToRGB(el.getFillColor()) + ");\n");
        currentFill = el.getFillColor();
      }
      if(currentStroke==null || currentStrWeight==null || currentStrWeight<0 || el.getStrokeColor()!=currentStroke) {
        saveAdd("Bild.txt", "stroke(" + colorToRGB(el.getStrokeColor()) + ");\n");
        currentStroke = el.getStrokeColor();
      }
      if(currentStrWeight==null || el.getStrWeight()!=currentStrWeight) {
        if(el.getStrWeight()<0 && currentStrWeight!=null && currentStrWeight>=0) {
          saveAdd("Bild.txt", "noStroke();\n");
        } else {
          saveAdd("Bild.txt", "strokeWeight(" + el.getStrWeight() + ");\n");
          currentStrWeight = el.getStrWeight();
        }

      }
      saveAdd("Bild.txt", el.toString());
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
    FileReader reader = new FileReader(name);
    BufferedReader bufferedReader = new BufferedReader(reader);
    String line;
    while ((line = bufferedReader.readLine()) != null) {
      // Handle line
    }
    System.out.println("Loaded "+name);
    reader.close();
  }
  catch (IOException e) {
    System.out.println("File not Found!");
    e.printStackTrace();
  }
}
