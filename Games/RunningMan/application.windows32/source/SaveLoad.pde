KeyPos[] keyPositions = {new KeyPos(0, 0)};

void saveMap(String name) {
  System.out.println("Saved to "+name);
  saveMapClear(name);
  saveMapAdd(name, String.format("player:%d,%d\n", (int)runner.x, (int)Math.floor(runner.y)));
  saveMapAdd(name, String.format("cam:%d,%d\n", (int)cam.pos.x, (int)cam.pos.y));
  for (SolidRect r : solidRects) {
    String line = String.format("rect:%d,%d,%d,%d,%d\n", (int)r.x1, (int)r.y1, (int)(r.x2-r.x1), (int)(r.y2-r.y1), r.visible?1:0);
    saveMapAdd(name, line);
  }
  for (Laser las : lasers) {
    String line = String.format("laser:%f,%f,%f,%f,%f,%f,keyPos=", las.pos.x, las.pos.y, las.directionOrigin, las.interval, las.onTime, las.delay);
    for (int i = 0; i<las.keyPositions.length; i++) {
      line += String.format("%f/%f;", las.keyPositions[i].dir, las.keyPositions[i].time);
    }
    line += "\n";
    saveMapAdd(name, line);
  }
}
void saveMapClear(String name) {
  try {
    FileWriter writer = new FileWriter(name, false);
    writer.close();
  }  
  catch (IOException e) {
    e.printStackTrace();
  }
}
void saveMapAdd(String name, String content) {
  try {
    FileWriter writer = new FileWriter(name, true);
    writer.write(content);
    writer.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}
void loadMap(String name) {
  solidRects.clear();
  lasers.clear();
  prefabs.clear();
  try {
    FileReader reader = new FileReader(name);
    BufferedReader bufferedReader = new BufferedReader(reader);

    String type;
    float v[];

    String line;
    while ((line = bufferedReader.readLine()) != null) {
      String[] aspects = line.split(":");
      
      //If line is valid
      if (aspects.length>1) {
        type = aspects[0];
        String valuesString[] = aspects[1].split(",");
        v = new float[valuesString.length];
        
        for (int i = 0; i<valuesString.length; i++) {
                   //System.out.println(valuesString[i]);
          if (isNumber(valuesString[i]))
            v[i] = Float.parseFloat(valuesString[i]);
            
          if (valuesString[i].contains("keyPos")) {
            String[] keyPosString = (valuesString[i].split("="))[1].split(";");
            keyPositions = new KeyPos[keyPosString.length];
            for (int j = 0; j<keyPosString.length; j++) {
              String[] temp = keyPosString[j].split("/");
              keyPositions[j] = new KeyPos(Float.parseFloat(temp[0]), Float.parseFloat(temp[1]));
            }
          }
          
        }
        
        loadObject(type,v);
        
      }
      currentMap = mapNum;
    }
    System.out.println("Loaded "+name);
    reader.close();
  }
  catch (IOException e) {
    System.out.println("File not Found!");
    e.printStackTrace();
  }
}

boolean isNumber(String s) {
  if (s == null) {
    return false;
  }
  try {
    double d = Double.parseDouble(s);
  } 
  catch (NumberFormatException nfe) {
    return false;
  }
  return true;
}
boolean isBoolean(String s) {
  if (s.equals("true")||s.equals("false")) return true;
  return false;
}  
Savable objectFromString() {
  Savable res = new KeyPos(0, 0);
  return res;
}
void loadObject(String type, float[] v) {
  if (type.equals("rect")) {
          solidRects.add(new SolidRect(v[0], v[1], v[2], v[3], v[4]==1?true:false));
        }
        if (type.equals("player")) {
          runner.x = v[0];
          runner.y = v[1];
        }
        if (type.equals("cam")) {
          cam.pos.x = v[0];
          cam.pos.y = v[1];
        }
        if (type.equals("laser")) {
          lasers.add(new Laser(v[0], v[1], v[2], v[3], v[4], v[5], keyPositions));
        }
}
