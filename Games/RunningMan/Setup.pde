public void settings() {
  size(1000, 600, P3D);
}

class TestClass {
  public float firstValue = 3.1416f;
  public int secondValue = 42;
  public String thirdValue = "Hello world";
}

float hey = 5;

public void setup() {
  frameRate(100);
  //setFloatField("hey",11);
  //System.out.println(hey);
  //TestClass test = new TestClass();
  //try {
  //  System.out.println(getValueOf(runner,"x"));
  //  System.out.println(getValueOf(test, "firstValue"));
  //  System.out.println(getValueOf(test, "secondValue"));
  //  System.out.println(getValueOf(test, "thirdValue"));
  //} 
  //catch(Exception e) {
  //}
  textBoxes.add(new TextBox(100, 100, 100, 30));
  textBoxes.add(new TextBox(300, 100, 100, 30));

  //load map
  loadMap("map00.txt");

  //load images
  for (int i = 0; i<8; i++) {
    runImage[i] = loadImage("run0" + i + ".png");
  }
  standImage[0] = loadImage("stand00.png");
  forestBG = loadImage("forest_night.jpg");
  mountainsBG = loadImage("mountains.jpg");
  grassImage = loadImage("grass.png");
  tableIMG = loadImage("table.png");
  tableIMG.resize(100, 50);

  ////border of level
  //solidRects.add(new SolidRect(-10000, -1500, 20000, 1000));     //top 
  //solidRects.add(new SolidRect(-10000, 1700, 20000, 1000));      //bottom 
  //solidRects.add(new SolidRect(10000, -1500, 1000, 21000));      //left 
  //solidRects.add(new SolidRect(-11000, -1500, 1000, 21000));     //right 

  //create buttons and sliders
  menuButtons[0] = new Button("PLAY", width/2-80, 190, 160, 50, color(255), 30);
  menuButtons[1] = new Button("EDITOR", width/2-80, 260, 160, 50, color(255), 30);
  editorButtons[0] = new Button("Player", 10, 40, 80, 30, color(255), 10);
  editorButtons[1] = new Button("Rectangle", 10, 70, 80, 30, color(255), 10);
  editorButtons[2] = new Button("Laser:DOWN", 10, 100, 80, 30, color(255), 10);
  editorButtons[3] = new Button("Table", 10, 130, 80, 30, color(255), 10);
  saveButton = new Button("Save", width-125, 20, 50, 20, color(255), 8);
  loadButton = new Button("Load", width-75, 20, 50, 20, color(255), 8);
  for (int i = 0; i<2; i++) {
    for (int j = 0; j<5; j++) {
      mapButtons[i*5+j] = new Button(""+(i*5+j), width-100+30*i, 60+30*j, 20, 20, WHITE, 8);
    }
  }
}

//Level setup
//Camera
Camera cam = new Camera();
//Buttons, Sliders
Button[] menuButtons = new Button[2];
Button[] editorButtons = new Button[4];
Button saveButton;
Button loadButton;
Button[] mapButtons = new Button[10];
ArrayList<Slider> editorSliders = new ArrayList<Slider>();

//Player character
Runner runner = new Runner(50, 99);
//Landscape
//SOLID RECTS
//Positions of rects is specified in setup method
ArrayList<SolidRect> solidRects = new ArrayList<SolidRect>();
//LASERS
ArrayList<Laser> lasers = new ArrayList<Laser>();
//PREFABS
ArrayList<Prefab> prefabs = new ArrayList<Prefab>();


//Editor necessities
CreateRect createRect = new CreateRect(0, 0, 9999, 9999);
ArrayList<TextBox> textBoxes = new ArrayList<TextBox>();
TextBox activeTextBox;
int laserDirection = 90;
Configurable selection = null;

//Settings
float plySpeed = 8;
int groundColor = color(100, 100, 100);
float gravity = 0.8;
GM state = GM.MENU;

//necessary variables
int tool = 0;
int mapNum = 0;
int currentMap = 0;

//COLORS
final int WHITE = color(255);
final int GREY = color(100);

enum GM { 
  MENU, PLAY, EDITOR, GAME_OVER, PAUSE
};
